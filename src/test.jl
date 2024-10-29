include("utils.jl")
using BenchmarkTools
using PrettyTables 
using Colors 

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
    color_array = [if i in obs_idx ? green : blue for i in 1:nv(N.graph)]
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