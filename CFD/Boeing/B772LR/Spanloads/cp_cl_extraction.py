import typing
import os
import json

import numpy as np
import tecplot as tp
from tecplot.exception import *
from tecplot.constant import *
import matplotlib.pyplot as plt


def cp_to_cCl(cp_file: str) -> float:
    """
    Reads an x vs. cp file output by Tecplot 360 and calculates the c*Cl value
    for the section
    """
    # Read the Tecplot-generated .dat file

    raw_cp_data = np.loadtxt(cp_file, skiprows=8)


    # Split the data at the point of maximum cp (the stagnation point)
    #max_cp_index = np.argmax(raw_cp_data[:, 1])
    min_x_index = np.argmin(raw_cp_data[:, 0])
    #print(f"{min_x_index = }, {len(raw_cp_data[:, 0]) = }")
    x_lower, cp_lower = raw_cp_data[min_x_index:,
                                    0], raw_cp_data[min_x_index:, 1]
    x_upper, cp_upper = raw_cp_data[:min_x_index +
                                    1, 0], raw_cp_data[:min_x_index+1, 1]

    # If the i-ordered points for either surface are in descending order of x, flip x and cp
    if x_lower[-1] < x_lower[0]:
        x_lower = np.flip(x_lower)
        cp_lower = np.flip(cp_lower)
    if x_upper[-1] < x_upper[0]:
        x_upper = np.flip(x_upper)
        cp_upper = np.flip(cp_upper)

    # Plot
    #print(f"{cp_file = }")
    #plt.plot(x_lower, cp_lower, color="indianred", marker="x")
    #plt.plot(x_upper, cp_upper, color="cornflowerblue", marker="x")
    #plt.gca().invert_yaxis()
    #plt.show()

    # Integrate over the lower surface
    cCl_lower = np.trapz(y=cp_lower, x=x_lower)
    cCl_upper = np.trapz(y=cp_upper, x=x_upper)

    # Calculate cCl
    cCl = cCl_lower - cCl_upper
    

    return cCl


def extract_cps(y_values: typing.Iterable, data_dir: str):
    for y in y_values:
        tp.active_frame().plot_type = PlotType.Cartesian3D
        tp.active_frame().plot().slice(0).origin.y = y

        zone = tp.active_frame().plot().slices(0).extract(mode=ExtractMode.OneZonePerConnectedRegion,
                                                          transient_mode=TransientOperationMode.AllSolutionTimes)
        

        zones = [z for z in zone]
        y_string = str(y).replace(".", "pt")
        
        for z in zones:
            z_string = z.name.split("region ")[-1][0]
            
            tp.data.save_tecplot_ascii(os.path.join(data_dir, f"cp_y={y_string}_region={z_string}.dat"),
                                       # Zone must correspond to last zone added
                                       zones=[z],
                                       # These are SU2 specific, representing X and Pressure_Coefficient
                                       variables=[0, 12],
                                       include_text=False,
                                       precision=9,
                                       include_geom=False,
                                       include_data_share_linkage=True,
                                       use_point_format=True)


def main():
    data_dir = r"/Users/prateekranjan/Documents/Github/TASOPT.jl/CFD/Boeing/B772LR/Spanloads/data/"
    y_vals = np.array([round(v, 3) for v in np.linspace(0.0, 32.3113, 200)])  # 0.001, 20.5, 120
    
    # print(f"{y_vals = }")
    tp.session.connect()

    print("Extracting cp..")
    extract_cps(y_values=y_vals, data_dir=data_dir)
    print("cp extraction done!")
    cCl_dict = {}
    print("Computing cCl")
    for root, dirs, files in os.walk(data_dir):
        for name in files:
            print("Current filename:",name)
            cCl = cp_to_cCl(os.path.join(root, name))
            split_str = name.split("_")
            y_val = split_str[1].split("=")[-1].replace("pt", ".")
            if y_val not in cCl_dict.keys():
                cCl_dict[y_val] = cCl
            else:
                #pass
                cCl_dict[y_val] += cCl
    print("cCl extraction done!")
    b = 32.3113 * 2
    cbar = 11.832
    S = 420.142 * 2
    y = np.array([float(k) for k in cCl_dict.keys()])
    cCl_cbar = np.array([v for v in cCl_dict.values()]) / cbar
    sort_idx = np.argsort(y)
    y_sorted = y[sort_idx]
    cCl_cbar_sorted = cCl_cbar[sort_idx]
    eta = y_sorted / (b / 2)
    trapz = np.trapz(cCl_cbar_sorted, x=eta) * cbar * b / S
    print(f"measured CL = {trapz}")
    export_data = {"b": b, "cbar": cbar, "S": S, "eta": eta.tolist(), "cCl_cbar": cCl_cbar_sorted.tolist()}
    with open(os.path.join(os.path.dirname(data_dir), "spanload.json"), "w") as f:
        json.dump(export_data, fp=f)
    plt.plot(eta, cCl_cbar_sorted)
    plt.show()


if __name__ == "__main__":
    main()
