import matplotlib.pyplot as plt
plt.style.use('seaborn-v0_8-deep')
# Setting global font properties
plt.rcParams.update({
    'font.size': 16,
    'font.family': 'Times New Roman',
    'font.weight': 'bold'
})

# Data for plotting
cl_fraction_categories = ['WING', 'FUSE', 'TAIL', 'PYLON', 'NACELLE']
cl_fraction_values = [1.006368, 0.097306, -0.09271, -0.001252, -0.009714 ]
bar_colors = ['C0', 'C1', 'C2', 'C3', 'C4'] * 3  # Repeating colors for simplicity

# Reduce spacing between bars by adjusting the bar width
bar_width = 0.35

# Creating the plot
plt.figure()

bars = plt.bar(range(len(cl_fraction_categories)), cl_fraction_values, color=bar_colors, edgecolor='black', width=bar_width)
#bars = plt.bar(cl_fraction_categories, cl_fraction_values, color=bar_colors, edgecolor='black', width=bar_width)
# Adding value labels to bars
for i, bar in enumerate(bars):
    yval = bar.get_height()
    label_position = yval + 0.01 if yval > 0 else 0.01  # Offset for negative values above the x-axis
    plt.text(bar.get_x() + bar.get_width()/2, label_position, round(yval, 4), 
             ha='center', va='bottom', rotation=90)

# Adjusting plot aesthetics
#plt.xlabel('Categories', fontweight='bold')
plt.ylabel('Values', fontweight='bold')
plt.gca().spines['bottom'].set_visible(True)
plt.gca().spines['bottom'].set_linewidth(1.5)
plt.gca().spines['bottom'].set_position(('data', 0))
plt.gca().spines['left'].set_visible(False)
plt.gca().axes.get_yaxis().set_visible(False)
plt.ylim([-0.1, 1.1])
for spine in ['top', 'right', 'left']:
    plt.gca().spines[spine].set_visible(False)
plt.xticks([])  # Hide x-axis category names

# Adding a horizontally aligned legend
#plt.legend(bars, cl_fraction_categories, loc='upper center', bbox_to_anchor=(0.5, -0.1), 
#           ncol=len(cl_fraction_categories), prop={'weight':'bold', 'size':12})

plt.legend(bars, cl_fraction_categories, loc='upper right', 
           ncol=1, prop={'weight':'bold', 'size':14})

F = plt.gcf()
Size = F.get_size_inches()
F.set_size_inches(Size[0]*1.5, Size[1]*1.5, forward=True) # Set forward to True to resize window along with plot in figure.
#F.set_size_inches(Size[0]*3.5, Size[1]*1.5, forward=True) # Set forward to True to resize window along with plot in figure.


plt.rcParams['figure.dpi'] = 300
plt.rcParams['savefig.dpi'] = 300


plt.savefig('B763ER_CL_Decomp.png')
plt.show()
