import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
#from scipy.fft import fft, fftfreq
import matplotlib.ticker as tck
import matplotlib.ticker as ticker

#plt.style.use('seaborn-v0_8-dark-palette')
plt.style.use('seaborn-v0_8-deep')

df0 = pd.read_csv('Data/B772LE.csv', skiprows = 0)

Arr0 = df0.to_numpy()


# Factor for drag count
Factor = 10000

AOA = Arr0[:,0]

CL_M80 = Arr0[:,1]
CL_M70 = Arr0[:,4]
CL_M60 = Arr0[:,7]
CL_M50 = Arr0[:,10]

CMF_M80 = Arr0[:,2]
CMF_M70 = Arr0[:,5]
CMF_M60 = Arr0[:,8]
CMF_M50 = Arr0[:,11]

CLN_M80 = Arr0[:,3]
CLN_M70 = Arr0[:,6]
CLN_M60 = Arr0[:,9]
CLN_M50 = Arr0[:,12]


fig1 = plt.figure()
ax1 = fig1.gca()

# Specify dataset# Plot dataset

#ax1.plot(H,CL_SA, color = 'black',  label = 'SA', linewidth = 2, marker='o', markersize=10, mec = 'black', mfc = 'steelblue')
#ax1.plot(H,CL_ST, color = 'black',  label = 'SST', linewidth = 2, marker='s', markersize=10, mec = 'black', mfc = 'steelblue')

ax1.plot(CL_M80, CMF_M80,  label = r'$Ma_{\infty}: 0.80$', linewidth = 2.5,linestyle = 'solid', marker='o', markersize=10, mec = 'black', mfc = 'C0',markeredgewidth=2)
ax1.plot(CL_M70, CMF_M70,  label = r'$Ma_{\infty}: 0.70$', linewidth = 2.5,linestyle = 'solid', marker='p', markersize=10, mec = 'black', mfc = 'C0',markeredgewidth=2)
ax1.plot(CL_M60, CMF_M60, label = r'$Ma_{\infty}: 0.60$', linewidth = 2.5,linestyle = 'solid', marker='s', markersize=10, mec = 'black', mfc = 'C0',markeredgewidth=2)
ax1.plot(CL_M50, CMF_M50,  label = r'$Ma_{\infty}: 0.50$', linewidth = 2.5,linestyle = 'solid', marker='d', markersize=10, mec = 'black', mfc = 'C0',markeredgewidth=2)



ax1.set_xlabel(r'$C_L$',fontname="Times New Roman", fontsize = 22)
ax1.set_ylabel(r'$C_{M_{fuse}}$',fontname="Times New Roman", fontsize = 22)
plt.legend(loc = 'upper right', frameon=True, fontsize = 14)


# Plot grid properties
ax1.grid(which='major', color='black', linestyle='-', linewidth='0.05')
ax1.minorticks_on()
ax1.grid(which='minor', color='black', linestyle=':', linewidth='0.05')


# Remove frame boxes
#ax1.spines['top'].set_visible(False)
#ax1.spines['right'].set_visible(False)

for axis in ['top','bottom','left','right']:
  ax1.spines[axis].set_linewidth(1.5)

#ax1.axvline(linewidth=4, color="r")

# Modify axes ticks properties
plt.xticks(fontname = "Times New Roman", fontsize  = 20)
plt.yticks(fontname = "Times New Roman", fontsize = 20)

#ax1.yaxis.set_minor_locator(tck.AutoMinorLocator())
#ax1.xaxis.set_minor_locator(tck.AutoMinorLocator())

ax1.tick_params(bottom=True, top=True, left=True, right=True)
ax1.tick_params(labelbottom=True, labeltop=False, labelleft=True, labelright=False)

ax1.tick_params(which='major', length=10, width=1.2, direction='in')
ax1.tick_params(which='minor', length=5, width=1.2, direction='in')

#ax1.xaxis.set_major_locator(ticker.LinearLocator(6))
#ax1.yaxis.set_major_locator(ticker.LinearLocator(5))
#ax1.invert_xaxis()

F = plt.gcf()
Size = F.get_size_inches()
F.set_size_inches(Size[0]*1.5, Size[1]*1.5, forward=True) # Set forward to True to resize window along with plot in figure.
#F.set_size_inches(Size[0]*3.5, Size[1]*1.5, forward=True) # Set forward to True to resize window along with plot in figure.
plt.tight_layout()
plt.rcParams['figure.dpi'] = 300
plt.rcParams['savefig.dpi'] = 300
plt.savefig('CL_CMF_B772.png')

#plt.xlim([1.5e-05, 4e-05])
#plt.ylim([0.475,0.700])

plt.show()
