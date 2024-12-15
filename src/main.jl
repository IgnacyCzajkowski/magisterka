include("utils.jl")

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

#algorithm_test(N, inf_prob_vec, 0.0)
Utils.main(betas_vect, network_params, observer_count, gamma_start, gamma_step, i_max, j_max)