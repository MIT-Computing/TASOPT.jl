import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import cartopy.crs as ccrs
from cartopy import crs as ccrs, feature as cfeature
import numpy as np
import cartopy.feature as cfeature
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.ticker as ticker

def plotContour(dsf):

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

















