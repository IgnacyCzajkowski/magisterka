import numpy as np  
import matplotlib.pyplot as plt 

gammas_seq = []
gammas_par = []

avg_prec_seq = []
avg_prec_par = []

avg_prec_err_seq = []
avg_prec_err_par = []

avg_rank_seq = []
avg_rank_par = [] 

sizes = []

k = 3

file = open('src/parallel_vs_sequential/data_seq.txt', 'r')
for line in file:
        gammas_seq.append(float(line.split(" ")[0])) 
        prec = []
        prec_err = []
        rank = []
        for n in range(5):
            prec.append(float(line.split(" ")[3*n+1]))
            prec_err.append(float(line.split(" ")[3*n+2]))
            rank.append(float(line.split(" ")[3*n+3])) 
        avg_prec_seq.append(np.mean(prec))
        avg_prec_err_seq.append(k * np.mean(prec_err))
        avg_rank_seq.append(np.mean(rank)) 
        sizes.append(10)
file.close() 

file = open('src/parallel_vs_sequential/data_par.txt', 'r')
for line in file:
        gammas_par.append(float(line.split(" ")[0])) 
        prec = []
        prec_err = []
        rank = []
        for n in range(5):
            prec.append(float(line.split(" ")[3*n+1]))
            prec_err.append(float(line.split(" ")[3*n+2]))
            rank.append(float(line.split(" ")[3*n+3])) 
        avg_prec_par.append(np.mean(prec))
        avg_prec_err_par.append(k * np.mean(prec_err))
        avg_rank_par.append(np.mean(rank)) 
        sizes.append(10)
file.close()

plt.scatter(gammas_seq, avg_prec_seq, label = 'Sequential')
plt.errorbar(gammas_seq, avg_prec_seq, avg_prec_err_seq, ls = 'none')
plt.scatter(gammas_par, avg_prec_par, label = 'Parallel')
plt.errorbar(gammas_par, avg_prec_par, avg_prec_err_par, ls = 'none')
plt.xlabel('Gamma')
plt.ylabel('Avg Prec')
plt.title('Precision Comparison')
plt.legend()
plt.savefig('src/parallel_vs_sequential/prec_comparison.png')
plt.close()

plt.scatter(gammas_seq, avg_rank_seq, label = 'Sequential')
plt.scatter(gammas_par, avg_rank_par, label = 'Parallel')
plt.xlabel('Gamma')
plt.ylabel('Avg Rank')
plt.title('Rank Comparison')
plt.legend()
plt.savefig('src/parallel_vs_sequential/rank_comparison.png')