from herbie import Herbie
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import cartopy.crs as ccrs
from cartopy import crs as ccrs, feature as cfeature

plt.style.use('seaborn-v0_8-dark-palette')

verbose = 0

# Pressure levels pertaining to cruise altitudes
PRESSURE_LEVELS = [450, 425, 400, 375, 350, 325, 300, 275,250, 225, 200, 175, 150] #(mbar)

H = Herbie(
    "2023-05-01 12:00",  # model run date
    model="hrrr",  # model name
    product="sfc",  # model produce name (model dependent)
    fxx=1,  # forecast lead time
)

if verbose == 1:
    # Location of GRIB file
    print("Location of the GRIB file:" + str(H.grib))

    # Locatin of index file
    print("Index: " + str(H.idx))

    print("Total Inventory " + str(H.inventory))

    #H.inventory(searchString=":10 m above ground")
    print("--------------------------------------------------------------------\n")
    print("Full Inventory velocity: " + str(H.inventory(searchString="[U|V]GRD:")))
    print("--------------------------------------------------------------------\n")

    # All fields at 34,000 ft
    #.inventory(searchString=":500 mb:")
    print("--------------------------------------------------------------------\n")
    print("Velocity @ cruise: " + str(H.inventory(searchString=":250 mb:")))
    print("--------------------------------------------------------------------\n")


#  Download all fields at 34,000 ft (250 mb) and read them with xarray.
ds = H.xarray(":250 mb:", remove_grib=False)


df = ds.to_dataframe()

print(df)


# Plot the data
ds.u.plot(cmap=plt.cm.coolwarm)
#plt.show()

print("Passing")