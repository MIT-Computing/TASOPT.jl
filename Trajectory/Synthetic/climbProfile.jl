using Printf
using PyPlot

# Constant and initial conditions 

# Thrust in pounds-force (lbf)
T = 200000 * 0.224809 

# Weight of the aircraft in pounds-force (lbf)
W = 700000 * 0.224809

# Air density at sea level in slugs/ft^3 (simplified assumption)
rho = 1.225 * 0.00194

# Wing area in square feet (ft^2)
S = 124.6 * 10.7639

# Drag coefficient (simplified assumption)
C_D = 0.025


# Climbing speed in feet per second (ft/s)
V = 250 * 3.28084

# Acceleration due to gravity in feet per second squared (ft/s^2)
g = 32.174

# Convert weight to mass in slugs
mass = W / g


# Calculate Drag in pounds-force (lbf)
D = 0.5 * C_D * rho * V^2 * S

# Calculate climb angle (gamma) in radians
gamma = asin((T - D) / W)

# Calculate climb rate in feet per second (ft/s)
climb_rate = V * sin(gamma)

# Calculate time to climb to a certain altitude in feet
altitude_target = 10000 * 3.28084  # Target altitude in feet

time_to_climb = altitude_target / climb_rate

# Time array for plotting, assuming a constant time step
time_step  = 1 # seconds

# Total simulation time in seconds
total_time = ceil(Int, time_to_climb)

# Time array from 0 to total time in seconds
times = 0:time_step:total_time


# Altitute at each time step
altitudes = [t* climb_rate for t in times]

# Plotting
fig, ax = subplots()
ax.plot(times, altitudes, label="Climb Profile")
ax.set_xlabel("Time (s)")
ax.set_ylabel("Altitude (ft)")

ax.set_title("Aircraft Climb Profile")
ax.legend()
ax.grid(true)

# Set DPI for the plot
fig.dpi = 300

# Save the plot
fig.savefig("climb_profile_matplotlib.png", dpi  = 300)