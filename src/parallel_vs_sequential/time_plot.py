import matplotlib.pyplot as plt 

file = open('src\parallel_vs_sequential\j_max_benchmark.txt', 'r')
j_array = []
times_seq = []
times_par = []

for i, line in enumerate(file):
    if i != 0:
        j_array.append(int(line.split(' ')[0]))
        times_par.append(float(line.split(' ')[1]))
        times_seq.append(float(line.split(' ')[2]))

plt.scatter(j_array, times_seq, label = 'Sequential')
plt.scatter(j_array, times_par, label = 'Parallel')
plt.legend()
plt.xlabel('j_max')
plt.ylabel('Time[s]')
plt.title('Sequential vs Parallel Time') 
plt.savefig('src\parallel_vs_sequential\seq_vs_par_time.png')       