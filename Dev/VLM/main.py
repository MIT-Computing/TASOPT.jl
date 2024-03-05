import numpy as np
import matplotlib.pyplot as plt
from scipy.sparse.linalg import gmres

# Wing geometry parameters
span = 10.0  # Total span of the wing
root_chord = 1.5  # Chord length at the root of the wing
tip_chord = 1.0  # Chord length at the tip of the wing
num_spanwise = 10  # Number of panels spanwise
num_chordwise = 4  # Number of panels chordwise

# Aerodynamic conditions
alpha = 5.0  # Freestream angle of attack in degrees
V_inf = 1.0  # Freestream velocity in m/s
rho = 1.225  # Air density in kg/m^3

# Calculate span and chord distributions
y_positions = np.linspace(0, span / 2, num_spanwise + 1)  # Spanwise positions from root to tip (semi-span)
chord_lengths = np.linspace(root_chord, tip_chord, num_spanwise + 1)  # Chord lengths from root to tip

# Initialize lists to hold control point coordinates
control_points_x = []  # Chordwise positions of control points
control_points_y = []  # Spanwise positions of control points

# Generate control points for each panel
for i in range(num_spanwise):
    span_start = y_positions[i]
    span_end = y_positions[i + 1]
    span_mid = (span_start + span_end) / 2
    
    chord_start = chord_lengths[i]
    chord_end = chord_lengths[i + 1]
    chordwise_positions = np.linspace(chord_start, chord_end, num_chordwise + 1)
    
    for j in range(num_chordwise):
        chord_start = chordwise_positions[j]
        chord_end = chordwise_positions[j + 1]
        chord_mid = (chord_start + chord_end) / 2
        
        control_points_x.append(chord_mid)
        control_points_y.append(span_mid)

# Number of control points (total panels)
num_control_points = len(control_points_x)

# Initialize the AIC matrix
AIC = np.zeros((num_control_points, num_control_points))

# Define the vortex influence function
def vortex_influence(x_i, y_i, x_j, y_j):
    r = np.sqrt((x_i - x_j)**2 + (y_i - y_j)**2)
    if r == 0:
        return 0  # Avoid division by zero
    else:
        return 1 / (4 * np.pi * r)

# Populate the AIC matrix
for i in range(num_control_points):
    for j in range(num_control_points):
        x_i, y_i = control_points_x[i], control_points_y[i]
        x_j, y_j = control_points_x[j], control_points_y[j]
        AIC[i, j] = vortex_influence(x_i, y_i, x_j, y_j)

# Solve for circulation strengths (gamma) using GMRES
alpha_rad = np.radians(alpha)
RHS = np.sin(alpha_rad) * np.ones(num_control_points)
gamma, exitCode = gmres(AIC, RHS)

# Calculate spanwise lift distribution
lift_per_panel = rho * V_inf * gamma
spanwise_lift = np.zeros(num_spanwise)
for i in range(num_spanwise):
    spanwise_lift[i] = np.sum(lift_per_panel[i * num_chordwise : (i + 1) * num_chordwise])

# Plot the spanwise lift distribution
plt.figure(figsize=(10, 5))
plt.plot(y_positions[:num_spanwise], spanwise_lift, '-o', label='Spanwise Lift Distribution')
plt.xlabel('Span Position (m)')
plt.ylabel('Lift (N)')
plt.title('Spanwise Lift Distribution')
plt.legend()
plt.grid(True)
plt.show()
