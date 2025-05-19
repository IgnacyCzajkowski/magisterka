import matplotlib.pyplot as plt 
import seaborn as sns 
import pandas as pd 
import os

plt.rcParams['axes.labelsize'] = 12
plt.rcParams['text.usetex'] = True 

main_betas = ["1", "08", "06", "04"]
noise_betas = ["_03", "_05", "_07", "_09"]
network_names = ["ba", "er"]
target_gammas = [0.0, 0.8, 1.6]

fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(14, 18), gridspec_kw={'width_ratios': [1, 1], 'wspace': 0.15, 'hspace': 0.25})

# For storing all heatmap mappables to build a shared colorbar later
heatmap_mappables = []

for col, network in enumerate(network_names):
    comb_dict = {}
    for main_b in main_betas:
        for noise_b in noise_betas:
            file_name = main_b + 4 * noise_b + ".txt"
            dir_path = f"wyniki_nowe/propv1/rozne_bety/{network}/{file_name}"
            
            if not os.path.exists(dir_path):
                print(f"File not found: {dir_path}")
                continue

            with open(dir_path, "r") as file:
                main_b_val = float(main_b[0] + "." + main_b[1]) if len(main_b) > 1 else 1.0
                noise_b_val = float(noise_b[1] + "." + noise_b[2]) if noise_b != "_1" else 1.0

                for line in file:
                    gamma = float(line.split(" ")[0])
                    precision = float(line.split(" ")[1])

                    if gamma not in comb_dict:
                        comb_dict[gamma] = {'main beta': [], 'noise beta': [], 'precision': []}
                    
                    comb_dict[gamma]['main beta'].append(main_b_val)
                    comb_dict[gamma]['noise beta'].append(noise_b_val)
                    comb_dict[gamma]['precision'].append(precision)

    for row, gamma in enumerate(target_gammas):
        ax = axs[row, col]
        if gamma in comb_dict:
            data = comb_dict[gamma]
            df = pd.DataFrame(data)
            heatmap_data = df.pivot(index='noise beta', columns='main beta', values='precision')

            # Create the heatmap
            sns_heatmap = sns.heatmap(
                heatmap_data,
                annot=True,
                cmap="coolwarm",
                ax=ax,
                cbar=False,  # Turn off individual colorbars
                vmin=0, vmax=1  # Normalize across all plots if needed
            )

            # Save the heatmap object for a shared colorbar
            heatmap_mappables.append(sns_heatmap.get_children()[0])

            ax.set_title(f"{network.upper()}")
            ax.set_xlabel(r'$\beta_{main}$')
            ax.set_ylabel(r'$\beta_{noise}$')
            ax.label_outer()  
        else:
            ax.set_visible(False)

# Add gamma labels on the right side of each row
for row_idx, gamma in enumerate(target_gammas):
    fig.text(0.92, 0.84 - row_idx * 0.3, r'$\alpha$ = '+f"{gamma}", va='center', fontsize=18)

# Create one shared colorbar at the bottom
cbar_ax = fig.add_axes([0.25, 0.04, 0.5, 0.02])  # [left, bottom, width, height]
fig.colorbar(heatmap_mappables[0], cax=cbar_ax, orientation='horizontal', label='Precision')

# Final adjustments and save
plt.tight_layout(rect=[0, 0.1, 0.9, 1])  # leave space for colorbar and gamma labels
plt.savefig("combined_heatmaps_with_shared_cbar.pdf")
plt.show()
