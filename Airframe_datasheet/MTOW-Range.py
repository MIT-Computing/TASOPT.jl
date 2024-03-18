import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
#from scipy.fft import fft, fftfreq
import matplotlib.ticker as tck
import matplotlib.ticker as ticker

#plt.style.use('seaborn-v0_8-dark-palette')
plt.style.use('seaborn-v0_8-deep')

df0 = pd.read_csv('MTOW-Range.csv', skiprows = 0)

Arr0 = df0.to_numpy()

MTOW = Arr0[:,1] * 0.001
Range = Arr0[:,2] 

fig1 = plt.figure()
ax1 = fig1.gca()

ax1.plot(Range, MTOW, linewidth = 0,linestyle = 'solid', marker='s', markersize=10, mec = 'black', mfc = 'C0',markeredgewidth=2)




ax1.set_xlabel('Range (nmi)',fontname="Times New Roman", fontsize = 22)
ax1.set_ylabel('MTOW (x100 lbs)',fontname="Times New Roman", fontsize = 22)



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
#plt.tight_layout()
plt.rcParams['figure.dpi'] = 300
plt.rcParams['savefig.dpi'] = 300
plt.savefig('MTWO-Range.png')

plt.xlim([2500, 9000])
plt.ylim([100,800])

plt.show()
