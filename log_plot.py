import numpy as np 
import matplotlib.pyplot as plt 
import sys 
from scipy.optimize import curve_fit

plt.rcParams['axes.labelsize'] = 12 

file_names = ["1", "2", "3", "4", "5", "8", "10", "15", "20", "50"]
#plt.figure(figsize=(10, 6))

inf_num_arr = []
avg_prec_arr = []
avg_err_arr = []
sizes = []
k = 1.5

for file_name in file_names:
    dir = "wyniki\\zaleznosc_od_iilosci_inf\\betas07\\er\\"
    dir += file_name 
    file = open(dir + ".txt", "r")
    inf_num = int(file_name)
    inf_num_arr.append(inf_num)
    prec = []
    prec_err = []
    for line in file:
        if line.split(" ")[0] == "1.6":
            for n in range(inf_num):
                prec.append(float(line.split(" ")[3*n+1]))
                prec_err.append(float(line.split(" ")[3*n+2]))
            avg_prec_arr.append(np.mean(prec))
            avg_err_arr.append(k * np.mean(prec_err))    
            sizes.append(10)
    file.close()

fitX = np.logspace(np.log10(min(inf_num_arr[3:])), np.log10(max(inf_num_arr[3:])))

def ExpFunc(x, a, b):
    return a * np.power(x, b)


popt, pcov = curve_fit(ExpFunc, inf_num_arr[3:], avg_prec_arr[3:])
plt.plot(fitX, ExpFunc(fitX, *popt), 'g-', label="({0:.3f}*x**{1:.3f})".format(*popt))




plt.scatter(inf_num_arr, avg_prec_arr, sizes, label = "data")
plt.errorbar(inf_num_arr, avg_prec_arr, avg_err_arr, ls = 'none')
plt.title("Precision vs inf number (propv1, ER, beta0.7, gamma1.6)")
plt.xlabel("Inf number")
plt.ylabel("Avg Prec")
plt.yscale('log')
plt.xscale('log')
plt.legend()
plt.savefig(f"inf_num_vs_avg_prec_log_{sys.argv[1]}.pdf")         