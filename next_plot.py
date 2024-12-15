import numpy as np  
import matplotlib.pyplot as plt 
import sys 

#print(plt.rcParams.keys())

#plt.rcParams['text.usetext'] = True 
plt.rcParams['axes.labelsize'] = 12 

file_names = ["1_07", "1_07_07", "1_07_07_07", "1_07_07_07_07"]
network_names = ["ba", "er"]

plt.figure(figsize=(18, 18))

fig_prec, axs_prec = plt.subplots(4, 2)
fig_rank, axs_rank = plt.subplots(4, 2) 

k = 3

for i, file_name in enumerate(file_names):
    for j, network_name in enumerate(network_names):
        dir = "wyniki\\rozne_bety\\"
        dir += network_name + "\\" + file_name
        file = open(dir + ".txt", "r")

        background_inf_num = (len(file_name) - 1) // 3

        gammas = []
        
        avg_prec = []
        avg_prec_err = []
        
        avg_background_prec = []
        avg_background_prec_err = []
        
        avg_rank = []
        avg_background_rank = []

        for line in file:
            gammas.append(float(line.split(" ")[0]))
            avg_prec.append(float(line.split(" ")[1]))
            avg_prec_err.append(k * float(line.split(" ")[2]))
            avg_rank.append(float(line.split(" ")[3]))

            prec = []
            prec_err = []
            rank = []
            sizes = []
            
            for n in range(background_inf_num):
                prec.append(float(line.split(" ")[3 * (n+1) + 1]))
                prec_err.append(float(line.split(" ")[3 * (n+1) + 2]))
                rank.append(float(line.split(" ")[3 * (n+1) + 3]))
            
            avg_background_prec.append(np.mean(prec))
            avg_background_prec_err.append(k * np.mean(prec_err))
            avg_background_rank.append(np.mean(rank))
            sizes.append(10)
        file.close()     

        axs_prec[i, j].scatter(gammas, avg_prec, sizes, label = "#beta_1.0 = 1")   #   x - > network, y - > beta       
        axs_prec[i, j].errorbar(gammas, avg_prec, avg_prec_err, ls='none') 

        axs_rank[i, j].scatter(gammas, avg_rank, sizes, label = "#beta_1.0 = 1") 

        axs_prec[i, j].scatter(gammas, avg_background_prec, sizes, label = "beta_0.7")      
        axs_prec[i, j].errorbar(gammas, avg_background_prec, avg_background_prec_err, ls='none') 

        axs_rank[i, j].scatter(gammas, avg_background_rank, sizes, label = "#beta_0.7")

for x, axs in enumerate([axs_prec, axs_rank]):
    ylabel = "Avg Prec" if x == 0 else "Avg Rank"
    for ax in axs.flat:
        ax.set(xlabel='IOL strength alpha', ylabel=ylabel)
        ax.set_xticks(np.arange(0, 2.01, step=0.5))
        if x == 0:
            ax.set_yticks(np.arange(0, 1.01, step=0.2))
            ax.set_ylim([0,1])
        else:
            ax.set_yticks(np.arange(0, 80.01, step = 16))
            ax.set_ylim([0, 80]) 
        ax.grid() 
        ax.label_outer()

    axs[0, 1].legend(loc='upper left', fontsize="8", bbox_to_anchor=(-0.15, 0.98))
    axs[0, 0].set_title(label="BA")
    axs[0, 1].set_title(label="ER")    

for i in range(1, 5):
    axs_prec[i - 1, 1].text(2.1, 0.5, "#b0.7=" + str(i)) 
    axs_rank[i - 1, 1].text(2.1, 50, "#b0.7=" + str(i))     

fig_prec.savefig(f"background_prec_{sys.argv[1]}.pdf") 
fig_rank.savefig(f"background_rank_{sys.argv[1]}.pdf")     