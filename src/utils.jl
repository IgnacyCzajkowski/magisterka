module Utils 

using Graphs
using GraphPlot
using Setfield
using Plots
using Statistics
using StatsBase
using LinearAlgebra

using PrettyTables
using ProgressMeter 

#Struktura implementująca sieć
struct Network
    graph::Graph
    network_state::Matrix{Int}
    source_idx_matrix::Matrix{Int}
end

#Struktura implementująca obserwatora
mutable struct Observer
    idx::Int
    t::Int 
end

#Funkcja inicjalizująca początkowy stan sieci
function initialize_info_source(network_state::Matrix{Int})
    len = size(network_state)[2]
    inf_num = size(network_state)[1]
    source_indx_matrix::Matrix{Int} = zeros(inf_num, 1)
    for inf in 1:inf_num
        idx = rand(1:len)
        network_state[inf, idx] = 1
        source_indx_matrix[inf, 1] = idx
    end
    return source_indx_matrix 
end

#Funkcja tworząca sieć typu E-R o podanych parametrach i inicjalizująca stan początkowy sieci
function generate_network(nodes::Int, prob::Float16, inf_number::Int)
    G::Graph = erdos_renyi(nodes, prob)
    network_state::Matrix{Int} = zeros(inf_number, nodes)
    
    clusters = connected_components(G)
    if length(clusters) > 1
        for i in 1:(length(clusters) - 1)
            add_edge!(G, clusters[i][1], clusters[i+1][1])
        end 
    end         
      
    source_idx_matrix::Matrix{Int} = initialize_info_source(network_state) 
    N = Network(G, network_state, source_idx_matrix)
    return N
end

#Funkcja tworząca sieć typu B-A o podanych parametrach i inicjalizująca stan początkowy sieci
function generate_network(nodes::Int, base_nodes::Int, edges::Int, inf_number::Int)
    G = barabasi_albert(nodes, base_nodes, edges, complete = true)
    network_state::Matrix{Int} = zeros(inf_number, nodes)
    source_idx_matrix::Matrix{Int} = initialize_info_source(network_state) 
    N = Network(G, network_state, source_idx_matrix)
    return N
end

#Funkcja wczytująca sieć z pliku
function generate_network(file_name::String, inf_number::Int)
    file = open(file_name, "r")
    longer_format::Bool = length(split(readline(file), " ")) == 2 ? false : true 
    close(file)
    G::Graph = SimpleGraph()
    if !longer_format
        file = open(file_name, "r")
        max_vert::Int = 0
        for line in readlines(file)
            node1::Int = parse(Int, split(line, " ")[1])
            node2::Int = parse(Int, split(line, " ")[2])
            if node1 > max_vert
                max_vert = node1
            end 
            if node2 > max_vert
                max_vert = node2 
            end 
        end 
        add_vertices!(G, max_vert)
        close(file)
    end 
    
    file = open(file_name, "r")
    for (i, line) in enumerate(readlines(file))
        if i == 1 && longer_format
            continue 
        elseif i == 2 && longer_format
            n::Int = parse(Int, split(line, " ")[1])
            add_vertices!(G, n)
        else 
            node1::Int = parse(Int, split(line, " ")[1])
            node2::Int = parse(Int, split(line, " ")[2])
            add_edge!(G, node1, node2)
        end 
    end 
    network_state::Matrix{Int} = zeros(inf_number, nv(G))
    source_idx_matrix::Matrix{Int} = initialize_info_source(network_state)
    N = Network(G, network_state, source_idx_matrix)
    close(file)

    return N 
end     

#Funkcja do aktualizacji stanu węzła o indeksie indx w modelu SI
function  interact_witch_closest(N::Network, indx::Int, inf_prob_loc::Float64, inf_number::Int)
    #neighbors = all_neighbors(N.graph, indx)
    adjency_matrix = Matrix(Graphs.LinAlg.adjacency_matrix(N.graph))
    return N.network_state[indx]
end

#Funkcja do aktualizacji stanu węzła o indeksie indx w modelu FSIR
function  interact_witch_closest_fsir(N::Network, inf_prob_vec::Matrix{Float64}, gamma::Float64, adjency_matrix)
    neighbours_matrix::Matrix{Int} =  N.network_state * adjency_matrix
    inf_overload_matrix = [count(x -> x != 0, col) for col in eachcol(neighbours_matrix .* (1 .- N.network_state))]
    inf_overload_matrix = [x == 0 ? 1 : x for x in inf_overload_matrix]
    inf_overload_matrix = (1 ./ inf_overload_matrix) .^ gamma
    upd_betas = inf_overload_matrix' .* inf_prob_vec
    #0 to 1 and 1 to 0 flip: 1-x x{0,1}
    transition_matrix = 1 .- (1 .- upd_betas) .^ neighbours_matrix
    
    new_network_state::Matrix{Int} = N.network_state .+ (1 .- N.network_state) .* Int.(rand() .< transition_matrix)
    return new_network_state
end

#Funkcja do inicjalizacji bet z zadanego rozkladu normalnego
function generate_betas(inf_num::Int, mu::Float64, st::Float64)
    betas = randn(inf_num)
    betas = reshape(betas, inf_num, 1)
    betas = mu .+ st .* betas
    return 0.1 .+ 0.8 .* (betas .- minimum(betas)) ./ (maximum(betas) - minimum(betas))
end     

#Funkcja losująca i inicjalizująca wektor obserwatorów UWAGA: dodano tablice czasów obserwatorów
function getObservers(N::Network, l::Int)
    obs_indxs = sample(1:size(N.network_state, 2), l, replace=false)
    observers_times_matrix = Int(floatmax(Float16)) .* (1 .- N.network_state[:, obs_indxs])
    return obs_indxs, observers_times_matrix
end

#Funkcja służąca aktualizowanie stanu obserwatorów w trakcie symulacji
function actuateObservers(N_new::Network, N_old_state::Matrix{Int}, obs_indxs, observers_times_matrix, time::Int)
    obs_changed_matrix = N_new.network_state[:, obs_indxs] .+ N_old_state[:, obs_indxs] .== 1
    observers_times_matrix[obs_changed_matrix] .= time
end

#Funkcja zwracająca wektor odległości od obserwatorów węzła o indeksie idx
function getDistanceFromObservers(N::Network, obs_indxs)
    d_all = Vector{Vector{Float64}}()
    for idx in 1:size(N.network_state, 2)
        d = Vector{Float64}()
        ds = desopo_pape_shortest_paths(N.graph, idx)
        for ob_indx in obs_indxs
            if ds.dists[ob_indx] > floatmax(Float16)
                push!(d, floatmax(Float16))
            else    
                push!(d, float(ds.dists[ob_indx]))
            end    
        end
        d = collect(d')
        d = reshape(d, 1, :)
        push!(d_all, vec(d))
    end    
    distances_matrix = vcat(d_all'...)
    return distances_matrix #wywalene transpose 
end

#Funkcja zwracająca wyniki algorytmu korelacyjnego dla wszystkich węzłów sieci
function getScore(distances_matrix, observers_times_matrix)
    score_matrix = cor(transpose(distances_matrix), transpose(observers_times_matrix))
    return score_matrix 
end

#Funkcja wyznaczająca precyzję i ranking w symulacji na podstawie wektora wyników
function analizeScore(N::Network, score_matrix)
    prec_vect = Vector{Float64}()   #Wyniki z rozróżnieniem na informacje
    rank_vect = Vector{Float64}()
    for (i, score_i) in enumerate(eachcol(score_matrix))
        solutions = Vector{Int}()
        for j in 1:length(score_i)
            if abs(score_i[j] - maximum(score_i)) < 0.001
                push!(solutions, j)
            end
        end

        src_score_i = score_i[N.source_idx_matrix[i]]
        if N.source_idx_matrix[i] in solutions
            prec = 1.0 / length(solutions)
        else
            prec = 0.0
        end
        rank = maximum(findall(x -> x == src_score_i, sort(score_i, rev=true)))
        
        push!(prec_vect, prec)
        push!(rank_vect, rank)
    end 
    return prec_vect, rank_vect #Zwracamy miary dla kazdej informacji  
end

#Funkcja resetująca stan sieci UWAGA: DO AKTUALIZACJI
function resetExistingNetwork(N::Network)
    new_network_state = Vector{Int}()
    for i in 1:length(N.network_state)
        if i == N.source_idx
            push!(new_network_state, 1)
        else
            push!(new_network_state, 0)
        end
    end
    N = @set N.network_state = new_network_state
end


function algorithm(N::Network, inf_prob_vec::Matrix{Float64}, gamma::Float64, observer_count::Int) 
    adjacency_matrix = Graphs.LinAlg.adjacency_matrix(N.graph)
    obs_indxs, observers_times_matrix = getObservers(N, observer_count)
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
    prec_vect, rank_vect = analizeScore(N, score_matrix)
    return prec_vect, rank_vect
end 

function main(betas_vect, network_params, observer_count::Int, gamma_start::Float64, gamma_step::Float64, i_max::Int, j_max::Int)
    progres_bar = Progress(i_max * j_max, desc="Simulation complition...")
    file = open("data.txt", "w")
    inf_num = length(betas_vect)
    for i in 1:i_max
        rank_mat = zeros(Float64, 0, inf_num)
        prec_mat = zeros(Float64, 0, inf_num)
        gamma_vect = Vector{Float64}()
        gamma = gamma_start + gamma_step * (i - 1)  
        push!(gamma_vect, gamma)
        for j in 1:j_max
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
                while true  #Ading try in case of NaN in cor (0 variance)
                    try  
                        prec_vect, rank_vect = algorithm(N, betas_vect, gamma, observer_count)
                        prec_mat = vcat(prec_mat, reshape(prec_vect, 1, inf_num))
                        rank_mat = vcat(rank_mat, reshape(rank_vect, 1, inf_num))
                        break
                    catch ex 
                        println("Exeption occured")     
                    end 
                end 
                next!(progres_bar)        
                #prec_mat = vcat(prec_mat, reshape(prec_vect, 1, inf_num))
                #rank_mat = vcat(rank_mat, reshape(rank_vect, 1, inf_num))
                #resetExistingNetwork(N)
        end
            avg_prec_vect = [mean(x) for x in eachcol(prec_mat)]
            avg_rank_vect = [mean(x) for x in eachcol(rank_mat)]
            std_dev_prec_vect = [std(x) / sqrt(length(x)) for x in eachcol(prec_mat)]

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

end #Module end 