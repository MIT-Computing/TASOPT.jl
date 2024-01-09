import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.interpolate import griddata
import matplotlib.ticker as ticker

plt.style.use('seaborn-v0_8-deep')

# Load data
df0 = pd.read_csv('Boeing/B737-900/B739PRD.csv', header=None)
Arr0 = df0.to_numpy()

Factor  =1.04

# Data
Range = Arr0[:, 0]
Payload = Arr0[:, 1] * Factor

# Create grid to interpolate data
xi = np.linspace(Range.min(), Range.max(), 100)
yi = np.linspace(Payload.min(), Payload.max(), 100)
X, Y = np.meshgrid(xi, yi)

# Interpolate data
Z = griddata((Range, Payload), Payload, (X, Y), method='cubic')

# Plot
fig, ax = plt.subplots()
contourf = ax.contourf(X, Y, Z, levels=50, cmap='viridis')


# Specify plot characteristics
ax.set_xlabel('Range (x 1000 nm)', fontsize=22, fontname="Times New Roman")
ax.set_ylabel('OEW + Payload (x 1000 lbs)', fontname="Times New Roman", fontsize=22)

# Plot grid properties
ax.grid(which='major', color='black', linestyle='-', linewidth='0.02')
ax.minorticks_on()
ax.grid(which='minor', color='black', linestyle=':', linewidth='0.02')

# Modify axes and figure
ax.tick_params(bottom=True, top=True, left=True, right=True)
ax.tick_params(labelbottom=True, labeltop=False, labelleft=True, labelright=False)
ax.tick_params(which='major', length=10, width=1.2, direction='in')
ax.tick_params(which='minor', length=5, width=1.2, direction='in')

plt.xticks(fontname="Times New Roman", fontsize=20)
plt.yticks(fontname="Times New Roman", fontsize=20)

fig.set_size_inches(fig.get_size_inches()*1.5, forward=True)
plt.tight_layout()
plt.rcParams['figure.dpi'] = 300
plt.rcParams['savefig.dpi'] = 300

plt.xlim([0, 6])
plt.ylim([70, 150])

plt.savefig('B739_PRD.png')
plt.show()
