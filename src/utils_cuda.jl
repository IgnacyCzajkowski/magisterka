module CUtils

using Graphs
using GraphPlot
using Setfield
using Plots
using Statistics
using StatsBase
using LinearAlgebra
using PrettyTables
using ProgressMeter
using CUDA    

# Modify Network struct to hold CuArray matrices
struct Network
    graph::Graph
    network_state::CuArray{Int}
    source_idx_matrix::CuArray{Int}
end

#=
function interact_witch_closest_fsir(N::Network, inf_prob_vec::CuArray{Float64}, gamma::Float64, adjency_matrix::CuArray{Int})
    neighbours_matrix::CuArray{Int} =  N.network_state * adjency_matrix
    inf_overload_matrix = [count(x -> x != 0, col) for col in eachcol(neighbours_matrix .* (1 .- N.network_state))]
    inf_overload_matrix = CUDA.CuArray([x == 0 ? 1 : x for x in inf_overload_matrix])
    inf_overload_matrix = (1 ./ inf_overload_matrix) .^ gamma
    upd_betas = permutedims(inf_overload_matrix) .* inf_prob_vec # permutedims -> transform on gpu 
    #0 to 1 and 1 to 0 flip: 1-x x{0,1}
    transition_matrix = 1 .- (1 .- upd_betas) .^ neighbours_matrix
    
    new_network_state::CuArray{Int} = N.network_state .+ (1 .- N.network_state) .* Int.(rand() .< transition_matrix)
    return new_network_state
end
=#

function interact_witch_closest_fsir(N::Network, inf_prob_vec::CuArray{Float64}, gamma::Float64, adjency_matrix::CuArray{Int})
    neighbours_matrix = N.network_state * adjency_matrix  # This remains a CuArray since all operands are CuArrays

    # Calculate inf_overload_matrix using CUDA-compatible methods
    # Use a custom kernel for counting non-zero elements in each column
    inf_overload_matrix = CUDA.zeros(Int, size(neighbours_matrix, 2))
    CUDA.@sync count_nonzero_columns!(inf_overload_matrix, neighbours_matrix, N.network_state)
    
    # Transform inf_overload_matrix and continue using CuArrays
    inf_overload_matrix = max.(inf_overload_matrix, 1)  # Element-wise max to replace values of 0 with 1
    inf_overload_matrix = (1.0 ./ inf_overload_matrix) .^ gamma  # Element-wise operations on CuArray
    upd_betas = permutedims(inf_overload_matrix) .* inf_prob_vec  # GPU-compatible transpose and broadcast

    # Transition matrix computation
    transition_matrix = 1 .- (1 .- upd_betas) .^ neighbours_matrix

    # Update new network state with GPU-compatible random sampling
    new_network_state = N.network_state .+ (1 .- N.network_state) .* Int.(CUDA.rand(size(transition_matrix)) .< transition_matrix)
    return new_network_state
end

function count_nonzero_columns!(output::CuArray{Int}, matrix::CuArray{Int}, network_state::CuArray{Int})
    rows, cols = size(matrix)
    @cuda threads=256 blocks=ceil(Int, cols/256) count_nonzero_kernel!(output, matrix, network_state, rows, cols)
end

# Define the kernel as a separate function
function count_nonzero_kernel!(output::CuArray{Int}, matrix::CuArray{Int}, network_state::CuArray{Int}, rows::Int, cols::Int)
    tid = threadIdx().x + (blockIdx().x - 1) * blockDim().x
    if tid <= cols
        count = 0
        for row in 1:rows
            if matrix[row, tid] != 0 && network_state[row] == 0
                count += 1
            end
        end
        output[tid] = count
    end
end




# Custom correlation function for CuArray
function gpu_correlation(A::CuArray{Float64}, B::CuArray{Float64})
    n = size(A, 1)
    mean_A = mean(A, dims=1)
    mean_B = mean(B, dims=1)
    
    centered_A = A .- mean_A
    centered_B = B .- mean_B
    
    covariance = sum(centered_A .* centered_B, dims=1) / (n - 1)
    stddev_A = sqrt.(sum(centered_A .^ 2, dims=1) / (n - 1))
    stddev_B = sqrt.(sum(centered_B .^ 2, dims=1) / (n - 1))
    
    correlation = covariance ./ (stddev_A .* stddev_B)
    return correlation
end

# Modified getScore function
function getScore(distances_matrix::CuArray{Float64}, observers_times_matrix::CuArray{Float64})
    score_matrix = gpu_correlation(transpose(distances_matrix), transpose(observers_times_matrix))
    return score_matrix
end

function analizeScore(N::Network, score_matrix::CuArray{Float64})
    inf_num = size(score_matrix, 2)
    prec_vect = CUDA.zeros(Float64, inf_num)  # Precision for each information
    rank_vect = CUDA.zeros(Float64, inf_num)

    for i in 1:inf_num
        score_i = score_matrix[:, i]
        
        # Find solution indices with scores close to maximum
        max_score = maximum(score_i)
        solutions = findall(x -> abs(x - max_score) < 0.001, score_i)
        
        # Source score and precision calculation
        src_score_i = score_i[N.source_idx_matrix[i]]
        prec = N.source_idx_matrix[i] in solutions ? 1.0 / length(solutions) : 0.0
        
        # Ranking calculation
        sorted_scores = sort(score_i, rev=true)
        rank = findfirst(x -> x == src_score_i, sorted_scores)
        
        prec_vect[i] = prec
        rank_vect[i] = rank
    end
    
    return prec_vect, rank_vect
end

# Modify algorithm function to use CuArrays
function algorithm(N::Network, inf_prob_vec::CuArray{Float64}, gamma::Float64, observer_count::Int)
    adjacency_matrix = CuArray(Graphs.LinAlg.adjacency_matrix(N.graph))  # Transfer adjacency matrix to GPU
    obs_indxs, observers_times_matrix = getObservers(N, observer_count)
    time_step::Int = 1
    while !all(x -> x != Int(floatmax(Float16)), observers_times_matrix)
        N_temp_state = copy(N.network_state)
        N = @set N.network_state = interact_witch_closest_fsir(N, inf_prob_vec, gamma, adjacency_matrix)
        actuateObservers(N, N_temp_state, obs_indxs, observers_times_matrix, time_step)
        time_step += 1
        if time_step > 100000   # Termination condition
            println("Stuck in loop")
            break
        end
    end
    distances_matrix = getDistanceFromObservers(N, obs_indxs)
    score_matrix = getScore(distances_matrix, observers_times_matrix)
    prec_vect, rank_vect = analizeScore(N, score_matrix)
    return prec_vect, rank_vect
end

# Modify main to handle CuArrays and track simulation progress
function main(betas_vect, network_params, observer_count::Int, gamma_start::Float64, gamma_step::Float64, i_max::Int, j_max::Int)
    progres_bar = Progress(i_max * j_max, desc="Simulation completion...")
    file = open("data.txt", "w")
    inf_num = length(betas_vect)
    for i in 1:i_max
        rank_mat = CUDA.zeros(Float64, 0, inf_num)
        prec_mat = CUDA.zeros(Float64, 0, inf_num)
        gamma_vect = CuArray{Float64}(undef, i_max)
        gamma = gamma_start + gamma_step * (i - 1)
        gamma_vect[i] = gamma
        for j in 1:j_max
            N = generate_network(network_params, inf_num)  # Generate network for each simulation

            while true  # Retry if NaN in correlation
                try
                    prec_vect, rank_vect = algorithm(N, betas_vect, gamma, observer_count)
                    prec_mat = vcat(prec_mat, reshape(prec_vect, 1, inf_num))
                    rank_mat = vcat(rank_mat, reshape(rank_vect, 1, inf_num))
                    break
                catch ex
                    println("Exception occurred")
                end
            end
            next!(progres_bar)  # Update progress bar

        end

        avg_prec_vect = [mean(x) for x in eachcol(prec_mat)]
        avg_rank_vect = [mean(x) for x in eachcol(rank_mat)]
        std_dev_prec_vect = [std(x) / sqrt(length(x)) for x in eachcol(prec_mat)]

        # Save results to file
        write(file, string(gamma) * " ")
        for i in 1:inf_num
            end_char::String = i == inf_num ? "\n" : " "
            write(file, string(avg_prec_vect[i]) * " " * string(std_dev_prec_vect[i]) * " " * string(avg_rank_vect[i]) * end_char)
        end
    end
    close(file)
end 

# Exporting all functions 
for name in names(@__MODULE__, all=true)
    if isdefined(@__MODULE__, name) && isa(getfield(@__MODULE__, name), Function)
        @eval export $name 
    end    
end     

end # Module end 