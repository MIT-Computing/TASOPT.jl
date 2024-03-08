using Printf
using PyPlot

# Constant and initial conditions 

# Thrust in pounds-force (lbf)
T = 200000 * 0.224809 

# Weight of the aircraft in pounds-force (lbf)
W = 700000 * 0.224809

# Air density at sea level in slugs/ft^3 (simplified assumption)
rho_sea_level = 1.225 * 0.00194

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

# Function to calculate thrust at a given altitude
function thrust_at_altitude(altitude)
    thrust_decrease_rate = T / 36000

    if altitude <=36000
        return T - thrust_decrease_rate * altitude
    else
        #Beyond 36000 ft, thrust decreases more sharply or levels off
        return  T - thrust_decrease_rate * 36000
    end
end

function rate_of_climb(T, D, V, W)

    # Compute the steady state rate of climb
    ROC = V* (T-D)/W
    return ROC
end

# Time marching settings
time_step = 1
total_time = 1800
times = 0:time_step:total_time

# Initialize arrays for altitude and rate of climb
altitudes = zeros(length(times))
climb_rates = zeros(length(times))

# Initial conditions
current_altitude = 0.0

for i in eachindex(times)
    global current_altitude
    global altitudes
    global climb_rates
    thrust = thrust_at_altitude(current_altitude)
    rho = rho_sea_level * exp(-current_altitude / (29.92 * 1000 / g))  # Exponential decrease with altitude
    D = 0.5 * C_D * rho * V^2 * S

    ROC = rate_of_climb(thrust, D, V, W)

    climb_rates[i] = ROC

    if i > 1
        # If this is the second collocation point, update the altitude
        current_altitude += ROC * time_step
        altitudes[i] = current_altitude
    end
end

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

