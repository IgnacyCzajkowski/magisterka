include("utils.jl")
using Base.Threads: @threads
using Setfield
using Statistics
using Printf
using Graphs
using GraphPlot
using Plots
using StatsBase
using LinearAlgebra

using PrettyTables
using ProgressMeter

function SI_step(N::Utils.Network, beta::Float64)
    next_state = copy(N.network_state)
    for idx in 1:length(N.network_state)
        if N.network_state[idx] == 1
            for neigh_idx in all_neighbors(N.graph, idx)
                if rand() < beta
                    next_state[neigh_idx] = 1
                end     
            end    
        end     
    end    
    return next_state
end   

function algorithm_si(N::Utils.Network, beta::Float64, observer_count::Int) 
    println(N.source_idx_matrix) #Debug 
    adjacency_matrix = Graphs.LinAlg.adjacency_matrix(N.graph)
    obs_indxs, observers_times_matrix = Utils.getObservers(N, observer_count)
    time_step::Int = 1
    while !all(x -> x != Int(floatmax(Float16)), observers_times_matrix)
        N_temp_state = copy(N.network_state)
        N = @set N.network_state = SI_step(N, beta)        
        Utils.actuateObservers(N, N_temp_state, obs_indxs, observers_times_matrix, time_step)
        time_step += 1
        if time_step > 100000   #Warunek brzegowy symulacji
            println("Utknieto w pętli")
            break
        end
    end 
    #println(observers_times_matrix) #Debug 
    distances_matrix = Utils.getDistanceFromObservers(N, obs_indxs)
    println(distances_matrix[N.source_idx_matrix[1], :]) #Debug 
    score_matrix = Utils.getScore(distances_matrix, observers_times_matrix)
    prec_vect, rank_vect = Utils.analizeScore(N, score_matrix)
    return prec_vect, rank_vect
end 

params_array = Vector{}()
file = open("params.txt", "r")
for line in readlines(file)
    data_text = split(split(line, "#")[1], " ")
    push!(params_array, data_text)
end  
close(file) 
if length(params_array[1]) == 1
    network_params = [String(params_array[1][1])]
elseif length(params_array[1]) == 2
    #erdos_reyni::Bool = true
    n = parse(Int, params_array[1][1])
    p = parse(Float64, params_array[1][2])
    network_params = [n, p]
elseif length(params_array[1]) == 3
    #erdos_reyni = false
    n = parse(Int, params_array[1][1])
    n0 = parse(Int, params_array[1][2])
    k = parse(Int, params_array[1][3])
    network_params = [n, n0, k]
end

println(network_params) #Debug

observer_count::Int = parse(Int, params_array[2][1])
println(observer_count) #Debug

if params_array[3][1] == "gamma"
    use_gamma::Bool = true
    betas_vect = Vector{Float64}()
    for beta_string in params_array[4]
        push!(betas_vect, parse(Float64, beta_string))
    end     
    inf_num = length(betas_vect)
    betas_vect = reshape(betas_vect, :, 1)
    println(inf_num) #Debug 
    println(betas_vect) #Debug 
       
    gamma_start = parse(Float64, params_array[5][1])
    gamma_step = parse(Float64, params_array[5][2])
    i_max = parse(Int, params_array[5][3])
elseif params_array[3][1] == "beta"
    use_gamma = false
    beta_start = parse(Float64, params_array[4][1])
    beta_step = parse(Float64, params_array[4][2])
    i_max = parse(Int, params_array[4][3])
    gamma = parse(Float64, params_array[5][1])
end

j_max::Int = parse(Int, params_array[6][1])
println(j_max) #Debug 
propagation_v2::Bool = parse(Bool, params_array[7][1])


# This function performs j_max simulations for a given gamma (or beta) setting in parallel.
function parallel_simulation_set(betas_vect, network_params, observer_count, gamma, j_max, propagation_v2)
    # Determine the number of information sources from betas_vect
    inf_num = size(betas_vect, 1)
    # Prepare matrices to collect simulation results.
    # We assume each simulation returns a vector of length inf_num for both precision and rank.
    prec_mat = Matrix{Float64}(undef, j_max, inf_num)
    rank_mat = Matrix{Float64}(undef, j_max, inf_num)
    
    @threads for j in 1:j_max
        # Create a network instance depending on network_params.
        #N = nothing
        if length(network_params) == 1
            N::Utils.Network = Utils.generate_network(network_params[1])
        elseif length(network_params) == 2
            nodes::Int = network_params[1]
            prob::Float16 = network_params[2]
            N = Utils.generate_network(nodes, prob, inf_num) 
        elseif length(network_params) == 3
            nodes = network_params[1]
            base_nodes::Int = network_params[2]
            edges::Int = network_params[3]
            N = Utils.generate_network(nodes, base_nodes, edges, inf_num)
        end 
        # Run the simulation.
        local_prec = nothing
        local_rank = nothing
        # In case the simulation throws an exception (for example, NaN in correlation),
        # we retry until success.
        while true
            try
                local_prec, local_rank = algorithm_si(N, betas_vect[1], observer_count)
                break
            catch ex
                @printf("Thread %d: Exception occurred, retrying simulation...\n", threadid())
            end
        end
        
        # Store the simulation results (each thread writes to a separate row).
        prec_mat[j, :] = local_prec
        rank_mat[j, :] = local_rank
    end
    
    println(prec_mat) #Debug 
    return prec_mat, rank_mat
end

# This is the top-level function that loops over the i_max parameter sets,
# runs the j_max simulations in parallel for each, computes the averages and standard deviations,
# and writes the results to an output file.
function parallel_main(betas_vect, network_params, observer_count, gamma_start, gamma_step, i_max, j_max, propagation_v2)
    outfile = open("data.txt", "w")
    # Loop over the different gamma (or beta) values.
    for i in 1:i_max
        gamma = gamma_start + gamma_step*(i - 1)
        #@printf("Running simulations for gamma = %g\n", gamma)
        
        # Run j_max simulations in parallel for this parameter set.
        prec_mat, rank_mat = parallel_simulation_set(betas_vect, network_params, observer_count, gamma, j_max, propagation_v2)
        
        # Compute average precision, average rank, and the standard error for precision.
        inf_num = size(betas_vect, 1)
        avg_prec_vect = [mean(prec_mat[:, k]) for k in 1:inf_num]
        avg_rank_vect = [mean(rank_mat[:, k]) for k in 1:inf_num]
        std_dev_prec_vect = [std(prec_mat[:, k]) / sqrt(j_max) for k in 1:inf_num]
        
        # Write gamma and the measures for each information source.
        # Format: gamma avg_prec std_prec avg_rank for each source.
        write(outfile, string(gamma) * " ")
        for k in 1:inf_num
            end_char = (k == inf_num) ? "\n" : " "
            write(outfile, @sprintf("%g %g %g%s", avg_prec_vect[k], std_dev_prec_vect[k], avg_rank_vect[k], end_char))
        end
    end
    close(outfile)
    #println("Simulation completed. Results saved to data_parallel.txt")
end

# Call the parallel_main function with the parameters parsed from file.
global_start_time = time()
if use_gamma
    parallel_main(betas_vect, network_params, observer_count, gamma_start, gamma_step, i_max, j_max, propagation_v2)
else
    error("Beta-based simulation not implemented in this parallel version.")
end
total_time = time() - global_start_time 

@printf("Total run time: %.2f seconds.\n", total_time)