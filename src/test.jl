include("utils.jl")
using BenchmarkTools
using PrettyTables 
using Colors 


#=
function test_prob_matrix(N::Network, betas_vect::Matrix{Float64}, gamma::Float64)
    # Get teoretical prob matrix 
    #@btime begin #time bench 
    teor_prob_matr = zeros(length(betas_vect), nv(N.graph))
    for inf in 1:length(betas_vect)
        for n in 1:nv(N.graph)
            k = count(x -> N.network_state[inf, x] == 1, all_neighbors(N.graph, n))
            already_has_inf = findall(x -> x == 1, N.network_state[:, n])
            different_inf = []
            for neigh in all_neighbors(N.graph, n)
                different_inf = union(different_inf, findall(x -> x == 1, N.network_state[:, neigh]))
            end 
            num_inf = setdiff(different_inf, already_has_inf)  
            num_inf = length(num_inf)
            if num_inf == 0
                num_inf = 1
            end     
            teor_prob_matr[inf, n] = 1 - (1 - betas_vect[inf] / num_inf ^ gamma) ^ k 
        end     
    end 
    #end #time bench end 
    
    # Get simulation prob matrix 
    #@btime begin #time bench 
    neighbours_matrix::Matrix{Int} =  N.network_state * adjacency_matrix(N.graph)
    inf_overload_matrix = [count(x -> x != 0, col) for col in eachcol(neighbours_matrix .* (1 .- N.network_state))]
    inf_overload_matrix = [x == 0 ? 1 : x for x in inf_overload_matrix]
    inf_overload_matrix = (1 ./ inf_overload_matrix) .^ gamma
    upd_betas = inf_overload_matrix' .* betas_vect
    transition_matrix = 1 .- (1 .- upd_betas) .^ neighbours_matrix
    #prob_matrix = inf_overload_matrix' .* transition_matrix
    #end #time bench end 
    
    #=
    println("Wartosci teoretyczne: ")
    pretty_table(teor_prob_matr)

    println("\n")    
    println("Wartosci z symulacji: ")
    pretty_table(transition_matrix)
    =#

    #True if passed
    return !(false in (abs.(teor_prob_matr .- transition_matrix) .<= 0.0001))
end   

function get_network_with_random_state(nodes::Int, base_nodes::Int, edges::Int, inf_number::Int)
    network = generate_network(nodes, base_nodes, edges, inf_number) 
    for point in network.network_state
        if point == 0 && rand(Bool)
            point = 1
        end 
    end 
    return network         
end     

function plot_network(N::Network, obs_idx)
    green = RGB(0., 1., 0.)
    blue = RGB(0., 0., 1.)
    color_array = [i in obs_idx ? green : blue for i in 1:nv(N.graph)]
    gplot(N.graph, nodelabel=1:nv(N.graph), nodefillc=color_array)
end




#=
for i in 1:1000
    inf_num = rand(1:10)
    betas = 0.1 .+ (0.8 .* rand(inf_num))
    betas = reshape(betas, :, 1)
    gamma = rand() * 3
    network = get_network_with_random_state(1000, 5, 4, inf_num)
    output = test_prob_matrix(network, betas, gamma)
    println(output)
end     
=#

function read_params_from_file(file_name::String)
    params_array = Vector{}()
file = open(file_name, "r")
for line in readlines(file)
    data = split(split(line, "#")[1], " ")
    push!(params_array, data)
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

observer_count::Int = parse(Int, params_array[2][1])
if params_array[3][1] == "gamma"
    use_gamma::Bool = true
    betas_vect = Vector{Float64}()
    for beta_string in params_array[4]
        push!(betas_vect, parse(Float64, beta_string))
    end     
    inf_num = length(betas_vect)
    betas_vect = reshape(betas_vect, :, 1)
       
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
    return network_params, observer_count, betas_vect
end    

function generate_network_from_net_params(network_params)
    if length(network_params) == 1
        N::Network = generate_network(network_params[1])
    elseif length(network_params) == 2
        nodes::Int = network_params[1]
        prob::Float16 = network_params[2]
        N = generate_network(nodes, prob, inf_num) 
    elseif length(network_params) == 3
        nodes = network_params[1]
        base_nodes::Int = network_params[2]
        edges::Int = network_params[3]
        N = generate_network(nodes, base_nodes, edges, inf_num) 
    end
    return N 
end  

function algorithm_test(N::Network, inf_prob_vec::Matrix{Float64}, gamma::Float64, observer_count::Int) 
    adjacency_matrix = Graphs.LinAlg.adjacency_matrix(N.graph)
    
    global obs_times_snapshot
    global obs_dist_snapshot
    global obs_idx 
    global network 
    
    obs_indxs, observers_times_matrix = getObservers(N, observer_count)
    println("obs idx: ", obs_indxs)
    time_step::Int = 1
    while !all(x -> x != Int(floatmax(Float16)), observers_times_matrix)
        N_temp_state = copy(N.network_state)
        N = @set N.network_state = interact_witch_closest_fsir(N, inf_prob_vec, gamma, adjacency_matrix)
        actuateObservers(N, N_temp_state, obs_indxs, observers_times_matrix, time_step)
        time_step += 1
        if time_step > 100000   #Warunek brzegowy symulacji
            println("Utknieto w pętli")
            break
        end
    end
    distances_matrix = getDistanceFromObservers(N, obs_indxs)
    score_matrix = getScore(distances_matrix, observers_times_matrix)

    obs_times_snapshot = observers_times_matrix
    obs_dist_snapshot = distances_matrix
    obs_idx = obs_idx
    network = N 

    prec_vect, rank_vect = analizeScore(N, score_matrix)
    return distances_matrix, observers_times_matrix, score_matrix
end


network_params, observer_count, betas_vect = read_params_from_file("params.txt")

for i in 1:100
    network = generate_network_from_net_params(network_params)
    algorithm_test(network, betas_vect, 0.0, observer_count)
end     
=#

for i in range(1000)
    new_state = Utils.interact
end    