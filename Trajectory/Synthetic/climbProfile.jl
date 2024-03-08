using Printf
using PyPlot

include("utils.jl")
include("atmos.jl")

using .utils
using .Atmos



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


function speed_of_sound_at_altitude(altitude_meters::Float64)
    # Constants
    γ = 1.4  # Adiabatic index
    R = 287.05  # Specific gas constant for dry air, J/(kg·K)
    T0 = 288.15  # Sea level standard temperature, K
    L = -0.0065  # Temperature lapse rate, K/m
    TropopauseAltitude = 11000.0  # Altitude of the tropopause, meters

    # Calculate temperature at altitude
    if altitude_meters <= TropopauseAltitude
        T = T0 + L * altitude_meters  # Temperature decreases linearly in the troposphere
    else
        T = T0 + L * TropopauseAltitude  # Constant temperature in the lower stratosphere
    end

    # Calculate speed of sound
    a = sqrt(γ * R * T)
    return a  # Speed of sound in m/s
end

# Function to calculate thrust at a given altitude
function thrust_at_altitude(altitude)
    thrust_decrease_rate = T / 36000

    # Get the mach number at this collocation point
    a = speed_of_sound_at_altitude(altitude* 0.3048)

    #Compte Mach number at the current altitude
    Mach = (V* 0.3048)/a
    println(a)
    println(Mach)

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
        println("Updating altitude")
        # If this is the second collocation point, update the altitude
        current_altitude += ROC * time_step
        println("Current altitude:", current_altitude)
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

