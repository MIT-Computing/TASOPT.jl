"""
Functions to work with the High Resolution Rapid Refresh (HRRR) weather forecast.
"""

import datetime as dt
import os, glob
import pandas as pd
import numpy as np 
from typing import Tuple
import cartopy.crs as ccrs
import xarray as xr
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import cartopy.crs as ccrs
from cartopy import crs as ccrs, feature as cfeature
import numpy as np
import cartopy.feature as cfeature
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.ticker as ticker

hrrr_proj = ccrs.LambertConformal(central_longitude=-97.5,
                                  central_latitude=38.5,
                                  standard_parallels=[38.5,38.5])



def rotate_hrrr_winds(ds):
    """
    This function rotates the HRRR winds from their grid directions to
    the true North and East directions (i.e. along a lon-lat grid).
    This method is based on that given in the HRRR FAQ.
    
    Parameters
    ----------
    ds: xr.Dataset
        Dataset containing HRRR data
    
    Returns
    -------
    ds: xr.Dataset
        Dataset containing HRRR data with rotated winds 'u_east', 'v_north'
    """
    
    ROTCON_P = 0.6222515 # Cone rotation parameter
    LON_XX_P = -97.5 # Meridian aligned with cartesian x-axis (degrees)
    LAT_TAN_P = 38.5 # Latitude at Lambert conformal projection
    
    # Note that HRRR longitude values are given in [0, 360) by default
    angle2 = np.radians(ROTCON_P * ((ds["longitude"]-360) - LON_XX_P))

    sinx2 = np.sin(angle2)
    cosx2 = np.cos(angle2)
    
    ds["u_east"] = cosx2.broadcast_like(ds["u"]) * ds["u"] \
                    + sinx2.broadcast_like(ds["v"]) * ds["v"]
    ds["v_north"] = - sinx2.broadcast_like(ds["u"]) * ds["u"] \
                    + cosx2.broadcast_like(ds["v"]) * ds["v"]

    return ds

def hrrr_to_geodetic(x, y):
    """
    Transforms coordinates from the 'x','y' coordinate system used in the 
    HRRR data to longitude and latitude. This 'x','y' system is a normalized
    version of a Lambert conformal conic projection centered at -97.5, 38.5. 
    
    Parameters
    ----------
    x: np.array
        'x' coordinate
    y: np.array
        'y' coordinate
   
    Returns
    -------
    longitude: np.array
        Longitude in degrees
    latitude: np.array
        Latitude in degrees
    
    """
    top_left = (-2701000.13032234, -1580581.33691808)
    transformed = ccrs.PlateCarree().transform_points(hrrr_proj, x*3000 + top_left[0], y*3000+top_left[1])
    return transformed[:,0], transformed[:,1]

def pressure_to_altitude(pressure_mbar):
    """
    Convert pressure in millibars to altitude in feet.

    Args:
        pressure_mbar (float): The pressure in millibars.

    Returns:
        float: The corresponding altitude in feet.

    Description:
        This function calculates the altitude in feet based on the provided pressure in millibars.
        It assumes standard atmospheric conditions and uses a simplified conversion formula.
        The formula approximates the relationship between pressure and altitude based on the International Standard Atmosphere model.

        The calculation takes into account the standard pressure at sea level (1013.25 mbar)
        and applies the conversion using a power of 0.190284 and a constant factor of 145366.45.

        The resulting altitude in feet is returned as the output of the function.

    Example:
        >>> pressure = 250
        >>> altitude = pressure_to_altitude(pressure)
        >>> print(f"Altitude: {altitude} feet")
        Altitude: 7526.202123461531 feet
    """

    # Constants for the simplified conversion
    pressure_at_sea_level_mbar = 1013.25  # Pressure at sea level in mbar
    feet_per_meter = 3.28084  # Conversion factor from meters to feet

    # Calculate altitude in feet
    altitude_ft = (1 - (pressure_mbar / pressure_at_sea_level_mbar) ** 0.190284) * 145366.45

    return altitude_ft

def plotContour(dsf):
    """
    Plot wind vectors and wind speed contours on a map.

    Args:
        dsf (xarray.Dataset): A dataset containing wind data with variables 'u_east' and 'v_north'.

    Returns:
        None

    Description:
        This function takes wind data from the provided dataset and plots wind vectors and wind speed contours on a map.
        The wind data should include the eastward component ('u_east') and the northward component ('v_north').

        The function creates a figure with a Lambert Conformal projection and adds map features such as coastlines and borders.

        Wind vectors are represented by arrows, which can be plotted by uncommenting the 'quiver' line in the code.
        By default, wind speed contours are plotted using the 'contourf' function, filling the areas between the contours with colors.

        The contour levels are calculated based on the wind speed range, and the number of levels is set to 10.

        Contour labels are added using the 'clabel' function, displaying wind speeds in the specified format.

        The resulting plot shows the wind vectors and wind speed contours on the map.

    Example:
        >>> ds = xr.open_dataset('wind_data.nc')
        >>> plotContour(ds)
    """
    # Extract the true east and north winds
    u_east = dsf.u_east.values
    v_north = dsf.v_north.values

    # Create a figure and axes with a Lambert Conformal projection
    fig, ax = plt.subplots(figsize=(10, 6), subplot_kw=dict(projection=ccrs.LambertConformal()))  

    # Set the extent to CONUS using PlateCarree projection
    ax.set_extent([-125, -66.5, 20, 50], crs=ccrs.PlateCarree())

    # Add map features
    ax.add_feature(cfeature.COASTLINE)
    ax.add_feature(cfeature.BORDERS)

    # Plot wind vectors
    #ax.quiver(ds.longitude, ds.latitude, u_east, v_north, transform=ccrs.PlateCarree())


    # Add wind contours
    wind_speed = (u_east ** 2 + v_north ** 2) ** 0.5

    # Calculate contour levels based on wind speed range
    min_speed = np.min(wind_speed)
    max_speed = np.max(wind_speed)
    contour_levels = np.linspace(min_speed, max_speed, 10)

    contour = ax.contourf(dsf.longitude, dsf.latitude, wind_speed, contour_levels, cmap='coolwarm',
                     transform=ccrs.PlateCarree())

    # Add contour labels
    ax.clabel(contour, inline=True, fontsize=8, fmt='%1.0f')

    # Show the plot
    plt.show()


def plotSurface(dsf):

    """
    Plot wind speed as a surface plot on a map.

    Args:
        dsf (xarray.Dataset): A dataset containing wind data with variables 'u_east' and 'v_north'.

    Returns:
        None

    Description:
        This function takes wind data from the provided dataset and plots the wind speed as a 2D surface on a map.
        The wind data should include the eastward component ('u_east') and the northward component ('v_north').

        The function creates a figure with a Lambert Conformal projection and adds map features such as coastlines.

        Wind speed is calculated from the wind components, and the resulting surface plot is generated using the 'pcolormesh' function.
        The wind speed values are color-coded on the plot using the 'coolwarm' colormap.

        The extent of the map is set to cover the contiguous United States (CONUS) by default.
        You can uncomment the 'set_extent' line and adjust the latitude and longitude limits to customize the map extent.

        The function adds a colorbar to the plot, displaying the wind speed values and their corresponding color.

        Gridlines, labels, and a frame are added to the plot to enhance readability.

        The resulting plot is saved as 'Wind_field.png' with a DPI of 300 and also displayed on the screen.

    Example:
        >>> ds = xr.open_dataset('wind_data.nc')
        >>> plotSurface(ds)
    """

    # Extract the true east and north winds
    u_east = dsf.u_east.values
    v_north = dsf.v_north.values

    # Add wind contours
    wind_speed = (u_east ** 2 + v_north ** 2) ** 0.5

    # Create a figure and axes with a Lambert Conformal projection
    fig, ax = plt.subplots(figsize=(10, 6), subplot_kw=dict(projection=ccrs.LambertConformal()))

    # Get latitude and longitude limits from the dataset
    lat_min, lat_max = np.min(dsf.latitude), np.max(dsf.latitude)
    lon_min, lon_max = np.min(dsf.longitude), np.max(dsf.longitude)

    # Set the extent based on the latitude and longitude limits
    #ax.set_extent([lon_min, lon_max, lat_min, lat_max], crs=ccrs.PlateCarree())

    # Set the extent to CONUS
    ax.set_extent([-125, -70, 22, 50], crs=ccrs.PlateCarree())

    # Add map features
    ax.add_feature(cfeature.COASTLINE)
    #ax.add_feature(cfeature.BORDERS)

    # Plot wind speed as a 2D surface
    surf = ax.pcolormesh(dsf.longitude, dsf.latitude, wind_speed, shading='auto', cmap='coolwarm',
                     transform=ccrs.PlateCarree(),vmin=np.min(wind_speed), vmax=np.max(wind_speed))


    # Add colorbar
    cbar = plt.colorbar(surf, label = 'Wind Speed (m/s)')
    cbar.set_label(label = 'Wind Speed (m/s)', weight = 'bold', fontsize = 14)
    
    # Set colorbar tick locator and formatter
    ticks = ticker.MultipleLocator(base=10.0)
    cbar.ax.yaxis.set_major_locator(ticks)
    cbar.ax.yaxis.set_major_formatter(ticker.FormatStrFormatter('%0.1f'))


    # Remove the frame around the plot
    ax.set_frame_on(True)

    # Add x and y labels with ticks
    ax.set_xlabel('Longitude')
    ax.set_ylabel('Latitude')

    # Add gridlines
    gl = ax.gridlines(draw_labels=True, linewidth=0.5, color='gray', alpha=0.5, linestyle='--')
    gl.top_labels = True
    gl.right_labels = False
    gl.bottom_labels = False

    # Set the image DPI
    plt.savefig('Wing_field.png', dpi=300)

    # Show the plot
    plt.show()


