import matplotlib.pyplot as plt
import pandas as pd

# Load the data
df0 = pd.read_csv('MTOW-Range.csv', skiprows = 0)
MTOW = df0['MTOW'] * 0.001  # Convert to thousands of lbs
Range = df0['Range']
Airframe = df0['Aiframe']

# Plot styling
plt.style.use('seaborn-v0_8-deep')
fig1 = plt.figure()
ax1 = fig1.gca()

# Define offsets for text labels
x_offset = 100  # Adjust as needed for your data scale
y_offset = 20   # Adjust as needed for your data scale

# Plot each data point and label
for i in range(len(MTOW)):
    if MTOW[i] >= 200:
        ax1.plot(Range[i], MTOW[i], linestyle='None', marker='s', markersize=10, mec='black', mfc='C0', markeredgewidth=2)
        ax1.text(Range[i] + x_offset, MTOW[i] + y_offset, Airframe[i], horizontalalignment='left', verticalalignment='bottom', fontweight='bold', fontsize=12)
    else:
        ax1.plot(Range[i], MTOW[i], linestyle='None', marker='P', markersize=10, mec='black', mfc='C2', markeredgewidth=2)

    

# Axis labels
ax1.set_xlabel('Range (nmi)', fontname="Times New Roman", fontsize=22)
ax1.set_ylabel('MTOW (x100 lbs)', fontname="Times New Roman", fontsize=22)

# Grid and tick settings
ax1.grid(which='major', color='black', linestyle='-', linewidth='0.05')
ax1.minorticks_on()
ax1.grid(which='minor', color='black', linestyle=':', linewidth='0.05')
plt.xticks(fontname="Times New Roman", fontsize=20)
plt.yticks(fontname="Times New Roman", fontsize=20)
ax1.tick_params(which='both', bottom=True, top=True, left=True, right=True, labelbottom=True, labeltop=False, labelleft=True, labelright=False, direction='in', length=10, width=1.2)
ax1.tick_params(which='minor', length=5, width=1.2)

# Plot limits
plt.xlim([2500, 9000])
plt.ylim([100, 900])

F = plt.gcf()
Size = F.get_size_inches()
F.set_size_inches(Size[0]*1.5, Size[1]*1.5, forward=True) # Set forward to True to resize window along with plot in figure.

# DPI settings for saving figure
plt.rcParams['figure.dpi'] = 300
plt.rcParams['savefig.dpi'] = 300
plt.savefig('MTOW-Range_with_names.png')

plt.show()
