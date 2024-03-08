def pressure_to_altitude(pressure_mbar):
    # Constants for the simplified conversion
    pressure_at_sea_level_mbar = 1013.25  # Pressure at sea level in mbar
    feet_per_meter = 3.28084  # Conversion factor from meters to feet

    # Calculate altitude in feet
    altitude_ft = (1 - (pressure_mbar / pressure_at_sea_level_mbar) ** 0.190284) * 145366.45

    return altitude_ft


# Example usage
pressure = 250  # Pressure in millibars
altitude = pressure_to_altitude(pressure)
print(f"Altitude: {altitude} feet")

