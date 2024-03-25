import json
import os

import numpy as np
import matplotlib.pyplot as plt


def format_axis_scientific(ax: plt.Axes, font_family: str = "serif", font_size: int = 16):
    """
    Formats a Matplotlib ``Axes`` similar to the IEEE style
    """
    for tick in ax.get_xticklabels():
        tick.set_fontfamily(font_family)
        tick.set_fontsize(font_size)
    for tick in ax.get_yticklabels():
        tick.set_fontfamily(font_family)
        tick.set_fontsize(font_size)
    ax.minorticks_on()
    ax.tick_params(which="minor", direction="in", length=5, width=1.2, left=True, bottom=True, top=True, right=True)
    ax.tick_params(which="major", direction="in", length=10, width=1.2, left=True, bottom=True, top=True, right=True)


def main():
    cheeta_opt_dir = r"/home/illinois/Documents/cheeta_opt"
    base_dir = os.path.join(cheeta_opt_dir, "euler", "102423", "base")
    opt_dir = os.path.join(cheeta_opt_dir, "euler", "102423", "opt")
    with open(os.path.join(base_dir, "spanload.json"), "r") as f:
        base_data = json.load(f)
    with open(os.path.join(opt_dir, "spanload.json"), "r") as f:
        opt_data = json.load(f)

    plt.rcParams["font.family"] = "serif"
    fig, ax = plt.subplots()
    ax.plot(base_data["eta"], base_data["cCl_cbar"], color="black", marker="s", markersize=0, label="Baseline")
    ax.plot(opt_data["eta"], opt_data["cCl_cbar"], color="steelblue", marker="s", markersize=0, label="Optimized")

    # Calculate the optimum elliptical spanload
    cCl_cbar_0 = 4 * base_data["S"] * 0.617975 / (np.pi * base_data["b"] * base_data["cbar"])
    eta = np.linspace(0, 1, 101)
    cCl_cbar_elliptical = cCl_cbar_0 * np.sqrt(1 - eta**2)
    
    # Plot the elliptical spanload
    ax.plot(eta, cCl_cbar_elliptical, color="gray", label="Elliptical")
    
    # Plot formatting
    ax.set_xlabel(r"$\eta=2y/b$", fontsize=22)
    ax.set_ylabel(r"$cC_l/\bar{c}$", fontsize=22)
    ax.grid(which="major", color="black", ls="-", lw="0.2")
    ax.minorticks_on()
    ax.grid(which="minor", color="black", ls=":", lw="0.2")
    for axis in ["top", "bottom", "left", "right"]:
        ax.spines[axis].set_linewidth(1)
    ax.legend(prop=dict(size=16), framealpha=1.0)
    format_axis_scientific(ax)

    fig.set_tight_layout("tight")

    save_name_noext = os.path.join(cheeta_opt_dir, "euler", "102423", "spanload_comparison")
    fig.savefig(save_name_noext + ".pdf", bbox_inches="tight")
    fig.savefig(save_name_noext + ".png", bbox_inches="tight", dpi=300)

    # Show the plot
    plt.show()


if __name__ == "__main__":
    main()

