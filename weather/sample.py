from herbie import Herbie
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import cartopy.crs as ccrs
from cartopy import crs as ccrs, feature as cfeature
import utils as util
import numpy as np

import postProcess as pp

plt.style.use('seaborn-v0_8-dark-palette')

verbose = 0

# Pressure levels pertaining to cruise altitudes
PRESSURE_LEVELS = [450, 425, 400, 375, 350, 325, 300, 275,250, 225, 200, 175, 150] #(mbar)

H = Herbie(
    "2023-05-23 15:00",  # model run date
    model="hrrr",  # model name
    product="sfc",  # model produce name (model dependent)
    fxx=1,  # forecast lead time
)

#Note: HRRR be default uses Lambert Conformal projection

#  Download all fields at 34,000 ft (250 mb) and read them with xarray.
ds = H.xarray(":250 mb:", remove_grib=False)

# Rotate the wind-field from HRRR grid to true directions
dsf = util.rotate_hrrr_winds(ds)

util.plotSurface(dsf)
