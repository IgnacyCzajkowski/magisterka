using CUDA 
using Graphs
using GraphPlot
using Setfield
using Plots
using Statistics
using StatsBase
using LinearAlgebra
using PrettyTables
using ProgressMeter
using BenchmarkTools 

include("utils.jl")
include("utils_cuda.jl")

#CUDA.versioninfo()

global const a = 3.145
global const dim = 100_000_000


# SAXPY (CPU)
function cpu_saxpy(x::Vector{Float32}, y::Vector{Float32})
    z = zeros(Float32, dim)
    return z .= a .* x .+ y 
end 

function gpu_saxpy(x_gpu::CuArray{Float32}, y_gpu::CuArray{Float32})
    z = CUDA.zeros(Float64, dim)
    return z .= a .* x_gpu .+ y_gpu 
end 
#=
x = CUDA.ones(Float32, dim)
y = CUDA.ones(Float32, dim)

z = CUDA.zeros(Float32, dim)

@btime CUDA.@sync z .= a .* x .+ y #CPU wait until gpu performs task 
=# 
#=
x = ones(Float32, dim)
y = ones(Float32, dim)

@btime cpu_saxpy(x, y) 


x_gpu = CUDA.ones(Float32, dim)
y_gpu = CUDA.ones(Float32, dim)

@btime CUDA.@sync gpu_saxpy(x_gpu, y_gpu)
=#
p::Float16 = 0.008
#@btime Utils.generate_network(1000, p, 5) 
#@btime CUDA.@sync CUtils.generate_network(1000, p, 5)
# CPU 590.400 μs GPU 1.703 ms : Creating E-R network  

@btime network_cpu = Utils.generate_network(1000, 5, 4, 5)
network_cpu = Utils.generate_network(1000, 5, 4, 5)

@btime CUDA.@sync network_gpu = CUtils.Network(network_cpu.graph,
                            CuArray(network_cpu.network_state),
                            CuArray(network_cpu.source_idx_matrix))

network_gpu = CUtils.Network(network_cpu.graph, CuArray(network_cpu.network_state),
                            CuArray(network_cpu.source_idx_matrix))                            
# CPU 582.000 μs GPU 582.000 + 112.500 μs : Creating E-R network with copy to gpu

# Validate for other network types: CPU 312.800 μs GPU 312.800 + 113.600 μs : Creating B-A network with copy to gpu

beta_vect_cpu = [0.9 0.7 0.5 0.4 0.2]
beta_vect_cpu = reshape(beta_vect_cpu, :, 1)
beta_vect_gpu = CuArray(beta_vect_cpu)
gamma = 1.2 
adjency_matrix_cpu = Graphs.LinAlg.adjacency_matrix(network_cpu.graph)
adjency_matrix_gpu = CuArray(Graphs.LinAlg.adjacency_matrix(network_gpu.graph))

@btime Utils.interact_witch_closest_fsir(network_cpu, beta_vect_cpu,
                                        gamma, adjency_matrix_cpu)

@btime CUDA.@sync CUtils.interact_witch_closest_fsir(network_gpu, beta_vect_gpu,
                                                    gamma, adjency_matrix_gpu)        
                                                    
                                                    
                                                    