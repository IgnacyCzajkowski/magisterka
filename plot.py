import numpy as np  
import matplotlib.pyplot as plt 
import sys 

#print(plt.rcParams.keys())

#plt.rcParams['text.usetext'] = True 
plt.rcParams['axes.labelsize'] = 12 

file_names = ["1", "2", "3", "4", "5"]
network_names = ["ba", "er"]
beta_names = ["betas1", "betas07", "betas04"] 
beta_labels = ["b=1.0", "b=0.7", "b=0.4"] 
marker_labels = ['o', 's', '^', '*', 'v']

k = 3

plt.figure(figsize=(18, 18))

fig_prec, axs_prec = plt.subplots(3, 2)
fig_rank, axs_rank = plt.subplots(3, 2)

for i, beta_name in enumerate(beta_names):
    for j, network_name in enumerate(network_names):
        for file_name in file_names:
            dir = "wyniki\\zaleznosc_od_iilosci_inf\\"
            dir += beta_name + "\\" + network_name + "\\"
            dir += file_name
            file = open(dir + ".txt", "r")

            inf_num = int(file_name)
            '''
            beta = beta_name[len("betas"):]
            if beta[0] == "1":
                beta = "1.0"
            else:
                beta = beta[0] + "." + beta[1] 
            '''
            gammas = []
            avg_prec = []
            avg_prec_err  = []
            avg_rank = []
            sizes = []
            for line in file:
                gammas.append(float(line.split(" ")[0])) 
                prec = []
                prec_err = []
                rank = []
                for n in range(inf_num):
                    prec.append(float(line.split(" ")[3*n+1]))
                    prec_err.append(float(line.split(" ")[3*n+2]))
                    rank.append(float(line.split(" ")[3*n+3])) 
                avg_prec.append(np.mean(prec))
                avg_prec_err.append(k * np.mean(prec_err))
                avg_rank.append(np.mean(rank)) 
                sizes.append(10)
            file.close()    

            
            axs_prec[i, j].scatter(gammas, avg_prec, sizes, marker=marker_labels[inf_num-1], label = file_name)   #   x - > network, y - > beta       
            axs_prec[i, j].errorbar(gammas, avg_prec, avg_prec_err, ls='none') 

            axs_rank[i, j].scatter(gammas, avg_rank, sizes, marker=marker_labels[inf_num-1], label = file_name)

for x, axs in enumerate([axs_prec, axs_rank]):
    ylabel = "Avg Precison" if x == 0 else "Avg Rank"
    for ax in axs.flat:
        ax.set(xlabel='IOL strength alpha', ylabel=ylabel)
        ax.set_xticks(np.arange(0, 2.01, step=0.5))
        if x == 0:
            ax.set_yticks(np.arange(0, 1.01, step=0.2))
            ax.set_ylim([0,1])
        else:
            ax.set_yticks(np.arange(0, 55.01, step = 10))
            ax.set_ylim([0, 55]) 
        ax.grid() 
        ax.label_outer()

    axs[0, 1].legend(loc='upper left', fontsize="8", bbox_to_anchor=(-0.15, 0.98))
    axs[0, 0].set_title(label="BA")
    axs[0, 1].set_title(label="ER")

for i in range(len(beta_labels)):
    axs_prec[i, 1].text(2.15, 0.5, beta_labels[i]) 
    axs_rank[i, 1].text(2.15, 27, beta_labels[i]) 

fig_prec.savefig(f"ilosc_inf_prec_{sys.argv[1]}.pdf") 
fig_rank.savefig(f"ilosc_inf_rank_{sys.argv[1]}.pdf")             