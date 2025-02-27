import matplotlib.pyplot as plt 
import numpy as np 
import sys
import plotly.graph_objects as go
 

plt.rcParams['axes.labelsize'] = 12 

main_betas = ["1", "08", "06", "04", "02"]
noise_betas = ["_03", "_05", "_07", "_09"]


network_names = ["ba", "er"]
k = 3



for network in network_names:
    #ax = plt.figure().add_subplot(projection='3d')
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    comb_dict = {}
    for main_b in main_betas:
        for noise_b in noise_betas:
            ax = plt.figure().add_subplot(projection='3d')
            file_name = main_b + 4 * noise_b + ".txt"
            dir = "wyniki\\rozne_bety_propv2\\"
            dir += network + "\\" + file_name
            file = open(dir, "r")
            gammas = []
            avg_prec = []
            if len(main_b) == 1:
                main_b_val = 1.
            else:
                main_b_val = float(main_b[0] + "." + main_b[1])
            noise_b_val = float(noise_b[1] + "." + noise_b[2])
            for line in file:
                gamma = float(line.split(" ")[0])
                avg_prec = float(line.split(" ")[1])
                try:
                    comb_dict[gamma].append(main_b_val)
                except:
                    comb_dict[gamma] = []
                    comb_dict[gamma].append(main_b_val)   
                comb_dict[gamma].append(noise_b_val)
                comb_dict[gamma].append(avg_prec)

    for label, data_points in comb_dict.items():
        m_betas = data_points[::3]
        n_betas = data_points[1::3]
        prec = data_points[2::3]
        fig = go.Figure(data=[go.Scatter3d(
            x=m_betas,
            y=n_betas,
            z=prec,
            mode='markers',
            marker=dict(size=5, color='red')
        )])
        fig.update_layout(
            title=network + ", alpha: " + str(label),
            scene=dict(
        xaxis_title='main beta',  # Label for the X axis
        yaxis_title='noise beta',  # Label for the Y axis
        zaxis_title='precision'   # Label for the Z axis
    )
        )
        fig.write_html("3d_noise_vs_main_prec_" + network + "_" + str(label) + ".html")
        '''
        ax.scatter(m_betas, n_betas, prec, label = label)  
    ax.legend()
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.set_zlim(0, 1) 

    ax.set_xlabel('Main beta')
    ax.set_ylabel('Noise beta')
    ax.set_zlabel('Precision')
    ax.set_title(network)
    html_str = mpld3.fig_to_html(fig)
    #plt.write_html("3d_noise_vs_main_prec_" + network + ".html") 
    with open("3d_noise_vs_main_prec_" + network + ".html", "w") as f:
        f.write(html_str)   
      '''  
