import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
#from scipy.fft import fft, fftfreq
import matplotlib.ticker as tck
import matplotlib.ticker as ticker

#plt.style.use('seaborn-v0_8-dark-palette')
plt.style.use('seaborn-v0_8-deep')

df0 = pd.read_csv('Boeing/B737-600/B736PRD.csv', header = None)



Arr0 = df0.to_numpy()


# Factor for drag count
Factor = 1.2

Range = Arr0[:,0] 
Payload = Arr0[:,1] 

fig1 = plt.figure()
ax1 = fig1.gca()

ax1.plot(Range,Payload,  label = r'$Y^{+}: 10$', linewidth = 0,linestyle = 'solid', marker='o', markersize=10, mec = 'black', mfc = 'C0',markeredgewidth=2)

# Specify plot characteritics
ax1.set_xlabel('Range (X 1000 nm)', fontsize = 22, fontname="Times New Roman")
ax1.set_ylabel('Payload ( X 1000 lbs)',fontname="Times New Roman", fontsize = 22)
#plt.legend(loc = 'upper left', frameon=True, fontsize = 14)


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


ax1.tick_params(bottom=True, top=True, left=True, right=True)
ax1.tick_params(labelbottom=True, labeltop=False, labelleft=True, labelright=False)

ax1.tick_params(which='major', length=10, width=1.2, direction='in')
ax1.tick_params(which='minor', length=5, width=1.2, direction='in')


F = plt.gcf()
Size = F.get_size_inches()
F.set_size_inches(Size[0]*1.5, Size[1]*1.5, forward=True) # Set forward to True to resize window along with plot in figure.

plt.tight_layout()
plt.rcParams['figure.dpi'] = 300
plt.rcParams['savefig.dpi'] = 300
plt.savefig('B736_PRD.png')

plt.xlim([0, 6])
plt.ylim([70,150])

plt.show()
