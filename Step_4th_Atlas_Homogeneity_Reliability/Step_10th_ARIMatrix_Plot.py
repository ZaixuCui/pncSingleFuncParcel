
from string import ascii_letters
import numpy as np
import scipy.io as sio
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set(style="white")

t=sio.loadmat('/data/jux/BBL/projects/pncSingleFuncParcel/Replication//Revision/Atlas_Homogeneity_Reliability/AtlasSimilarity/ARIMatrix_Hongming_Kong.mat')
ARIMatrix_Hongming_Kong = t['ARIMatrix_Hongming_Kong']
z=pd.DataFrame(ARIMatrix_Hongming_Kong);

# Generate a mask for the upper triangle
mask = np.zeros_like(z, dtype=np.bool)
mask[np.triu_indices_from(mask)] = True

# Set up the matplotlib figure
f, ax = plt.subplots(figsize=(11, 9))

# Generate a custom diverging colormap
cmap = sns.diverging_palette(220, 10, as_cmap=True)

# Draw the heatmap with the mask and correct aspect ratio
sns.heatmap(z, square=True);
#sns.heatmap(z, mask=mask, cmap=cmap, vmax=.3, center=0,
#            square=True, linewidths=.5, cbar_kws={"shrink": .5})

f.savefig('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/ARIMatrix.tiff', dpi = 300);
