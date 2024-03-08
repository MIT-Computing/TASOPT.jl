import warnings
import matplotlib.pyplot as plt
import numpy as np
from cartopy import crs as ccrs, feature as cfeature

#plt.style.use('seaborn-v0_8-dark-palette')
plt.style.use('seaborn-v0_8-deep')
#plt.style.use('seaborn-v0_8-paper')
#plt.style.use('bmh')
#plt.style.use('seaborn-v0_8-colorblind')
#plt.style.use('seaborn-v0_8-notebook')
#plt.style.use('seaborn-v0_8-talk')
#plt.style.use('seaborn-v0_8-bright')

# Suppress warnings issued by Cartopy when downloading data files
warnings.filterwarnings('ignore')

projPC = ccrs.PlateCarree()
lonW = -124.7844079
lonE = -66.9513812
latS = 24.7433195
latN = 49.3457868
cLat = (latN + latS) / 2
cLon = (lonW + lonE) / 2
res = '50m'


fig = plt.figure(figsize=(11, 8.5))
ax = plt.subplot(1, 1, 1, projection=ccrs.Orthographic(-98.5795,39.8283))
ax.set_title('CONUS')
#gl = ax.gridlines(
#    draw_labels=True, linewidth=2, color='gray', alpha=0.5, linestyle='--'
#)

ax.set_extent([lonW, lonE, latS, latN])
#ax.set_extent([lonW, lonE, latS, latN], crs=ccrs.Orthographic(-98.5795,39.8283))
ax.coastlines(resolution=res, color='black')
ax.add_feature(cfeature.STATES, linewidth=0.3, edgecolor='black')

plt.rcParams['figure.dpi'] = 300
plt.rcParams['savefig.dpi'] = 300

# Remove frame boxes
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

ax.spines['left'].set_color('black') 
ax.spines['bottom'].set_color('black') 


for axis in ['bottom','left']:
  ax.spines[axis].set_linewidth(1.5)

# Modify axes ticks properties
plt.xticks(fontname = "Times New Roman", fontsize  = 20)
plt.yticks(fontname = "Times New Roman", fontsize = 20)

ax.tick_params(bottom=True, top=False, left=True, right=False)
ax.tick_params(labelbottom=True, labeltop=False, labelleft=True, labelright=False)

ax.tick_params(which='major', length=10, width=1.2, direction='out')
ax.tick_params(which='minor', length=5, width=1.2, direction='out')

F = plt.gcf()
Size = F.get_size_inches()
F.set_size_inches(Size[0]*0.8, Size[1]*0.5, forward=True) # Set forward to True to resize window along with plot in figure.

#ax.stock_img()
plt.show()


print("Passing")