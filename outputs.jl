"""
`weight_buildup` prints out the weight build up for the aircraft
"""
function weight_buildup(parg; io=stdout)

    Wempty  = parg[igWMTO] - parg[igWfuel] - parg[igWpay]
    Whpesys = parg[igWMTO] * parg[igfhpesys]
    Wlgnose = parg[igWMTO] * parg[igflgnose]
    Wlgmain = parg[igWMTO] * parg[igflgmain]
    Wtotadd = Whpesys + Wlgnose + Wlgmain

    printstyled(io, "Weight build-up:\n -------------- \n", color=:bold )
    @printf(io, "Wempty  + %10.1f N (%8.1f lb)\n", Wempty, Wempty/lbf_to_N)
    @printf(io, "Wpay    + %10.1f N (%8.1f lb)\n", parg[igWpay], parg[igWpay]/lbf_to_N)
    @printf(io, "Wfuel   + %10.1f N (%8.1f lb)\n", parg[igWfuel], parg[igWfuel]/lbf_to_N)
    @printf(io, "--------------------\n")
    printstyled(io, @sprintf("WMTO    = %10.1f N (%8.1f lb)\n\n",
                         parg[igWMTO], parg[igWMTO]/lbf_to_N); color=:bold)

    @printf(io,"Wfuse   + %10.1f N (%8.1f lb)\n", parg[igWfuse ], parg[igWfuse ]/lbf_to_N)
    @printf(io,"Wwing   + %10.1f N (%8.1f lb)\n", parg[igWwing ], parg[igWwing ]/lbf_to_N)
    @printf(io,"Wvtail  + %10.1f N (%8.1f lb)\n", parg[igWvtail], parg[igWvtail]/lbf_to_N)
    @printf(io,"Whtail  + %10.1f N (%8.1f lb)\n", parg[igWhtail], parg[igWhtail]/lbf_to_N)
    @printf(io,"Wtesys  + %10.1f N (%8.1f lb)\n", parg[igWtesys], parg[igWtesys]/lbf_to_N)
    @printf(io,"Wftank  + %10.1f N (%8.1f lb)\n", parg[igWftank], parg[igWftank]/lbf_to_N)
    @printf(io,"Wadd    + %10.1f N (%8.1f lb)\n", Wtotadd, Wtotadd/lbf_to_N)
    @printf(io,"--------------------\n")
    printstyled(io, @sprintf("Wempty  = %10.1f N (%8.1f lb)\n\n", 
    parg[igWfuse] + parg[igWwing]+ parg[igWvtail] + parg[igWhtail] + 
    parg[igWtesys] + +parg[igWftank] + Wtotadd, 
    (parg[igWfuse] + parg[igWwing]+ parg[igWvtail] + parg[igWhtail] + 
    parg[igWtesys] + +parg[igWftank] + Wtotadd)/lbf_to_N); color=:bold)

    @printf(io,"Wtshaft + %10.1f N × %d\n", parg[igWtshaft], parpt[ipt_nTshaft])
    @printf(io,"Wcat    + %10.1f N × %d\n", parg[igWcat   ], parpt[ipt_nTshaft])
    @printf(io,"Wgen    + %10.1f N × %d\n", parg[igWgen   ], parpt[ipt_ngen]) 
    @printf(io,"Winv    + %10.1f N × %d\n", parg[igWinv   ], parpt[ipt_nfan]) 
    @printf(io,"Wmot    + %10.1f N × %d\n", parg[igWmot   ], parpt[ipt_nfan]) 
    @printf(io,"Wfan    + %10.1f N × %d\n", parg[igWfan   ], parpt[ipt_nfan]) 
    @printf(io,"--------------------\n")
    printstyled(io,@sprintf("Wtesys  = %10.1f N (%8.1f lb)\n\n",
     parg[igWtesys], parg[igWtesys]/lbf_to_N ), color = :bold)

    @printf(io,"Wftnkins  = %10.1f N (%8.1f lb)\n", parg[igWinsftank ], parg[igWinsftank ]/lbf_to_N) 
    @printf(io,"Wftank    = %10.1f N (%8.1f lb)\n\n", parg[igWftank    ], parg[igWftank    ]/lbf_to_N) 
    @printf(io,"lftank    = %10.1f m (%8.1f ft)\n"  , parg[iglftank    ], parg[iglftank    ]/ft_to_m) 
    @printf(io,"Rftank    = %10.1f m (%8.1f ft)\n"  , parg[igRftank    ], parg[igRftank    ]/ft_to_m) 

    @printf(io,"ηtank   = %3.1f %% \n\n", parg[igWfuel]/(parg[igWfuel] + parg[igWftank])*100)
end

"""
`geometry` prints out the layout of the aircraft
"""
function geometry(parg; io = stdout)

    printstyled(io, "Fuselage Layout:\n -------------- \n", color=:bold )
    @printf(io, "xnose   = %5.1f m (%8.1f ft)\n", parg[igxnose  ] , parg[igxnose   ]/ft_to_m)
    @printf(io, "xend    = %5.1f m (%8.1f ft)\n", parg[igxend   ] , parg[igxend    ]/ft_to_m)
    @printf(io, "xwing   = %5.1f m (%8.1f ft)\n", parg[igxwing  ] , parg[igxwing   ]/ft_to_m)
    @printf(io, "xhtail  = %5.1f m (%8.1f ft)\n", parg[igxhtail ] , parg[igxhtail  ]/ft_to_m)
    @printf(io, "xvtail  = %5.1f m (%8.1f ft)\n", parg[igxvtail ] , parg[igxvtail  ]/ft_to_m)
    @printf(io, "xblend1 = %5.1f m (%8.1f ft)\n", parg[igxblend1] , parg[igxblend1 ]/ft_to_m)
    @printf(io, "xblend2 = %5.1f m (%8.1f ft)\n", parg[igxblend2] , parg[igxblend2 ]/ft_to_m)
    @printf(io, "xshell1 = %5.1f m (%8.1f ft)\n", parg[igxshell1] , parg[igxshell1 ]/ft_to_m)
    @printf(io, "xshell2 = %5.1f m (%8.1f ft)\n", parg[igxshell2] , parg[igxshell2 ]/ft_to_m)
    @printf(io, "xhbend  = %5.1f m (%8.1f ft)\n", parg[igxhbend ] , parg[igxhbend  ]/ft_to_m)
    @printf(io, "xvbend  = %5.1f m (%8.1f ft)\n", parg[igxvbend ] , parg[igxvbend  ]/ft_to_m)
    @printf(io, "xwbox   = %5.1f m (%8.1f ft)\n", parg[igxwbox  ] , parg[igxwbox   ]/ft_to_m)
    @printf(io, "xhbox   = %5.1f m (%8.1f ft)\n", parg[igxhbox  ] , parg[igxhbox   ]/ft_to_m)
    @printf(io, "xvbox   = %5.1f m (%8.1f ft)\n", parg[igxvbox  ] , parg[igxvbox   ]/ft_to_m)
    @printf(io, "xtshaft = %5.1f m (%8.1f ft)\n", parg[igxtshaft] , parg[igxtshaft ]/ft_to_m)
    @printf(io, "xgen    = %5.1f m (%8.1f ft)\n", parg[igxgen   ] , parg[igxgen    ]/ft_to_m)
    @printf(io, "xcat    = %5.1f m (%8.1f ft)\n", parg[igxcat   ] , parg[igxcat    ]/ft_to_m)
    @printf(io, "xftank  = %5.1f m (%8.1f ft)\n", parg[igxftank ] , parg[igxftank  ]/ft_to_m)
    
    SMfwd = (parg[igxNP] - parg[igxCGfwd])/parg[igcma]
    SMaft = (parg[igxNP] - parg[igxCGaft])/parg[igcma]
    printstyled(io, "\nStability:\n -------------- \n", color=:bold )
    @printf(io, "xNP     = %5.1f m (%8.1f ft)\n", parg[igxNP ] , parg[igxNP ]/ft_to_m)
    @printf(io, "xCGfwd  = %5.1f m (%8.1f ft)\n", parg[igxCGfwd ] , parg[igxCGfwd ]/ft_to_m)
    @printf(io, "xCGaft  = %5.1f m (%8.1f ft)\n", parg[igxCGaft ] , parg[igxCGaft ]/ft_to_m)
    @printf(io, "xSMfwd  = %5.4f\n", SMfwd)
    @printf(io, "xSMaft  = %5.4f\n", SMaft)

    
    printstyled(io, "\nWing Layout:\n -------------- \n", color=:bold )
    @printf(io, "AR      = %5.3f \n" , parg[igAR     ])
    @printf(io, "sweep   = %5.3f \n" , parg[igsweep  ])
    @printf(io, "lambdas = %5.3f \n" , parg[iglambdas])
    @printf(io, "lambdat = %5.3f \n" , parg[iglambdat]) 
    co = parg[igco]
    cs = parg[igco]*parg[iglambdas]
    ct = parg[igco]*parg[iglambdat]

    @printf(io, "co      = %5.1f m (%8.1f ft)\n" , co, co / ft_to_m )
    @printf(io, "cs      = %5.1f m (%8.1f ft)\n" , cs, cs / ft_to_m )
    @printf(io, "ct      = %5.1f m (%8.1f ft)\n" , ct, ct / ft_to_m )
    @printf(io, "bo      = %5.1f m (%8.1f ft)\n" , parg[igbo], parg[igbo]/ft_to_m   )
    @printf(io, "bs      = %5.1f m (%8.1f ft)\n" , parg[igbs], parg[igbs]/ft_to_m   )
    @printf(io, "b       = %5.1f m (%8.1f ft)\n" , parg[igb ], parg[igb ]/ft_to_m   )
    @printf(io, "S       = %5.1f m²(%8.1f ft²)\n" , parg[igS ], parg[igS ]/ft_to_m^2 )


end

function stickfig(parg, pari, parm; ax = nothing, label_fs = 16)

    # Wing
        co = parg[igco]
        cs = parg[igco]*parg[iglambdas]
        ct = parg[igco]*parg[iglambdat]

        sweep = parg[igsweep  ]
        λs = parg[iglambdas]
        λt = parg[iglambdat]

        bo = parg[igbo]
        bs = parg[igbs]
        b  = parg[igb ]

        xax = 0.40
        xcLE = -xax
        xcTE = 1.0 - xax

        dx = parg[igxwbox]      
        etas = bs/b
        etao = bo/b
        cosL = cos(sweep*pi/180.0)
        tanL = tan(sweep*pi/180.0)

        xs = tanL*(bs-bo)/2.0
        xt = tanL*(b -bo)/2.0

        xw = zeros(6)
        yw = zeros(6)

        #X locations of wing vertices
        xw[1] =      co*xcLE + dx
        xw[2] = xs + cs*xcLE + dx
        xw[3] = xt + ct*xcLE + dx
        xw[4] = xt + ct*xcTE + dx
        xw[5] = xs + cs*xcTE + dx
        xw[6] =      co*xcTE + dx
        
        #Y locations of wing vertices
        yw[1] = bo/2.0
        yw[2] = bs/2.0
        yw[3] = b /2.0
        yw[4] = b /2.0
        yw[5] = bs/2.0
        yw[6] = bo/2.0
    # Fuse
        Rfuse = parg[igRfuse]
        wfb   = parg[igwfb]

        anose    = parg[iganose]
        btail    = parg[igbtail]

        xnose    = parg[igxnose   ]
        xend     = parg[igxend    ]
        xblend1  = parg[igxblend1 ]
        xblend2  = parg[igxblend2 ]
        xhtail   = parg[igxhtail  ]
        xvtail   = parg[igxvtail  ]
        xwing    = parg[igxwing   ]

        xwbox    = parg[igxwbox   ]
        xhbox    = parg[igxhbox   ]
        xvbox    = parg[igxvbox   ]

        lcyl = xblend2 - xblend1
        xtail = xvtail 
        
        hwidth = Rfuse + wfb
        
        nnose = 10
        ntail = 10

        xf = zeros(nnose + ntail + 1)
        yf = zeros(nnose + ntail + 1)

        if pari[iifclose] == 0
            dytail = -hwidth 
        else
            dytail = -0.2*hwidth
        end

        for i = 1: nnose
            fraci = float(i-1)/float(nnose-1)
            fracx = cos(0.5*pi*fraci)

            k = i
            xf[k] = xblend1 + (xnose-xblend1)*fracx
            yf[k] = hwidth*(1.0 - fracx^anose)^(1.0/anose)
        end

        for i = 1: ntail
            fraci = float(i-1)/float(ntail-1)
            fracx = fraci

            k = i + nnose
            xf[k] = xblend2 + (xend-xblend2)*fracx
            yf[k] = hwidth + dytail*fracx^btail
        end

        k = k+1
        xf[k] = xf[k-1]
        yf[k] = 0.

    
    # Tail
        xh = zeros(6)
        yh = zeros(6)
        
        boh = parg[igboh]
        Sh  = parg[igSh]
        ARh = parg[igARh]
        lambdah = parg[iglambdah]
        sweeph  = parg[igsweeph]

        bh = sqrt(Sh*ARh)
        coh = Sh/(boh + (bh-boh)*0.5*(1.0+lambdah))


        dx = xhbox
        tanLh = tan(sweeph*π/180.0)
        cth = coh*lambdah

        xaxh = 0.40

        xoLEh = coh*(    - xaxh) + dx
        xoTEh = coh*(1.0 - xaxh) + dx
        xtLEh = cth*(    - xaxh) + dx + 0.5*(bh - boh)*tanLh
        xtTEh = cth*(1.0 - xaxh) + dx + 0.5*(bh - boh)*tanLh

        yoLEh = 0.5*boh
        yoTEh = 0.5*boh
        ytLEh = 0.5*bh
        ytTEh = 0.5*bh


        if (pari[iifclose] == 0)
            xcLEh = xoLEh
            xcTEh = xoTEh
            ycLEh = yoLEh
            ycTEh = yoTEh
        else
            xcLEh = coh*(    - xaxh) + dx + 0.5*(0. - boh)*tanLh
            xcTEh = coh*(1.0 - xaxh) + dx + 0.5*(0. - boh)*tanLh
            ycLEh = 0.0
            ycTEh = 0.0
        end

        if  (false)
            yoLEh = hwidth
            xoLEh = yoLEh*tanLh + xcLEh
            if (xoLEh > xblend2)
                fracx = min( (xoLEh-xblend2)/(xend-xblend2) , 1.0 )
                yoLEh = hwidth + dytail*fracx^btail
                xoLEh = yoLEh*tanLh + xcLEh
            end
            if (xoLEh > xblend2)
                fracx = min( (xoLEh-xblend2)/(xend-xblend2) , 1.0 )
                yoLEh = hwidth + dytail*fracx^btail
                xoLEh = yoLEh*tanLh + xcLEh
            end

            yoTEh = 0.0
            xoTEh = yoTEh*tanLh + xcTEh
            if (xoTEh > xblend2)
                fracx = min( (xoTEh-xblend2)/(xend-xblend2) , 1.0 )
                yoTEh = hwidth + dytail*fracx^btail
                xoTEh = yoTEh*tanLh + xcTEh
            end
            if (xoTEh > xblend2)
                fracx = min( (xoTEh-xblend2)/(xend-xblend2) , 1.0 )
                yoTEh = hwidth + dytail*fracx^btail
                xoTEh = yoTEh*tanLh + xcTEh
            end
        
        end
        


        xh[ 1] = xcLEh
        xh[ 2] = xoLEh
        xh[ 3] = xtLEh
        xh[ 4] = xtTEh
        xh[ 5] = xoTEh
        xh[ 6] = xcTEh
  
        yh[ 1] = ycLEh
        yh[ 2] = yoLEh
        yh[ 3] = ytLEh
        yh[ 4] = ytTEh
        yh[ 5] = yoTEh
        yh[ 6] = ycTEh
  

    # Fuel tank
        Rtank = Rfuse - 0.1 # Account for clearance_fuse
        l = max(ltank, parg[iglftank])
        ARtank = 2.0
        xcyl0 = parg[igxftank] - l/2 + Rtank/ARtank
        xcyl1 = parg[igxftank] + l/2 - Rtank/ARtank
        ntank = 8
        xt = zeros(ntank*2 )
        yt = zeros(ntank*2 )
        for i = 1: ntank
            fraci = float(i-1)/float(ntank-1)
            fracx = cos(0.5*pi*fraci)

            k = i
            xt[k] = xcyl0 - Rtank/ARtank*fracx
            yt[k] = sqrt(Rtank^2 * max((1 - ((xt[k]-xcyl0)/(Rtank/ARtank))^2), 0.0) )
        end
        # k = k+1
        # xt[k] = xcyl0 + parg[iglftank]
        # yt[k] = Rtank
        for i = 1: ntank
            fraci = float(i-1)/float(ntank-1)
            fracx = sin(0.5*pi*fraci)

            k = i + ntank
            xt[k] = xcyl1 + (xcyl1 + Rtank/ARtank - xcyl1)*fracx
            yt[k] = sqrt(Rtank^2 * max((1 - ((xt[k]-xcyl1)/(Rtank/ARtank))^2), 0.0) )
        end

        # xt = LinRange(xcyl0 - Rfuse/ARtank , xcyl0, 20 )
        # yt = zeros(length(xt))
        # @. yt = sqrt(Rfuse^2 * max((1 - ((xt-xcyl0)/(Rfuse/ARtank))^2), 0.0) )

        xshell = zeros(ntank)
        yshell = zeros(ntank)
        AR = 3.0
        xshellcenter = parg[igxshell2] - Rfuse/AR
        for i = 1: ntank
            fraci = float(i-1)/float(ntank-1)
            fracx = sin(0.5*pi*fraci)

            k = i
            xshell[k] = xshellcenter + Rfuse/AR *fracx
            yshell[k] = sqrt(Rfuse^2 * max((1 - ((xshell[k]-xshellcenter)/(Rfuse/AR))^2), 0.0) )
        end

    #Seats
    yseats = zeros(Int(seats_per_row/2))
    yseats[1] = seat_width/2.0
    yseats[2] = yseats[1] + seat_width
    yseats[3] = yseats[2] + 2*aisle_halfwidth + seat_width
       # aisle
       for col = 4:Int(seats_per_row/2)
        yseats[col] = yseats[col-1] + seat_width
       end
    
    xseats = zeros(rows)'
    xseats[1] = parg[igxshell1 ] + 10.0*ft_to_m 
    for r in 2:rows
        emergency_exit = 0.0
        if (r == 12 || r == 13)
            emergency_exit = seat_pitch/2
        end
        xseats[r] = xseats[r-1] + seat_pitch + emergency_exit
    end

    ## Plot
    if ax === nothing
        plt.style.use(["~/prash.mplstyle"])
        fig, ax = plt.subplots(figsize=(8,5), dpi = 100)
    else
        ax.cla()
    end
        # Plot wing
            ax.plot(xw, yw, "-k")
            ax.plot(xw, -yw, "-k")
            
            # Panel break
            ax.plot(xw[[2,5]],  yw[[2,5]], "-k", lw = 1.0, alpha = 0.5)
            ax.plot(xw[[2,5]], -yw[[2,5]], "-k", lw = 1.0, alpha = 0.5)
        
        # Plot Tail
        tailz = 1
        pari[iifclose] == 1 ? tailz = 21 : tailz = 1
            # ax.plot(xh,  yh, "-k", zorder = tailz)
            # ax.plot(xh, -yh, "-k", zorder = tailz)
            ax.fill_between(xh, -yh, yh, facecolor = "w", alpha = 0.8, edgecolor = "k", zorder = tailz, linewidth = 2.0)

        # Plot fuse
            # ax.fill(xf,  yf, facecolor = "w", edgecolor = "k")
            # ax.fill(xf, -yf, facecolor = "w", edgecolor = "k")
            ax.fill_between(xf, -yf, yf, facecolor = "w", edgecolor = "k", zorder = 5, linewidth = 2.0)
            
            # Tank
            ax.plot(xt,  yt, "k", lw = 1.5, zorder = 10)
            ax.plot(xt, -yt, "k", lw = 1.5, zorder = 10)
            ax.fill_between(xt, -yt, yt, facecolor = "r", alpha = 0.1, edgecolor = "k", zorder = 6, linewidth = 1.0)
            ax.text(parg[igxftank], 0.0, "LH\$_2\$", fontsize = label_fs-2.0, zorder = 10, ha="center", va="center")

            ax.plot(xshell,  yshell, "k", lw = 1.5, zorder = 10)
            ax.plot(xshell, -yshell, "k", lw = 1.5, zorder = 10)

        # Plot NP and CG range
            ax.scatter(parg[igxNP], 0.0, color = "k", marker="o", zorder = 21, label = "NP")
            ax.text(parg[igxNP], -1.0, "NP", fontsize=label_fs-2.0, ha="center", va="center", zorder = 21)

            ax.annotate("", xy=(parg[igxCGfwd ] , 0.0), xytext=(parg[igxCGaft ] , 0.0),
            fontsize=16, ha="center", va="bottom",
            arrowprops=Dict("arrowstyle"=> "|-|, widthA=0.2, widthB=0.2"),
            zorder = 21, label = "CG movement")
            ax.text(0.5*(parg[igxCGfwd ]+parg[igxCGaft ]), -1.0, "CG", fontsize=label_fs-2.0, ha="center", va="center", zorder = 21)

        # Show seats
            ax.scatter(ones(length(yseats),1).*xseats, ones(1,rows).* yseats, color = "gray", alpha = 0.1, marker = "s", s=15, zorder = 21)
            ax.scatter(ones(length(yseats),1).*xseats, ones(1,rows).*-yseats, color = "gray", alpha = 0.1, marker = "s", s=15, zorder = 21)
     
     # diagnostic marks
    #  ax.scatter(parg[igxftank] - l/2, 0.0, color = "k", marker="o", zorder = 21)
    #  ax.scatter(parg[igxftank], 0.0, color = "b", marker="o", zorder = 21)
    #  ax.scatter(parg[igxblend2], 0.0, color = "k", marker="o", zorder = 21)
    #  ax.plot([parg[igxftank]-l/2, parg[igxftank]+l/2],[0.0, 0.0], zorder = 21)



    # Annotations
    ax.text(0, 15, @sprintf("PFEI = %5.3f J/Nm\nSpan = %5.1f m\nco    = %5.1f m\nRfuse = %5.1f m\nL/D = %3.2f",
     parm[imPFEI], parg[igb], parg[igco], parg[igRfuse], para[iaCL, ipcruise1]/para[iaCD, ipcruise1]),
     fontsize = label_fs, ha="left", va="top")

    yloc = -20
    ax.annotate("", xy=(0.0, yloc), xytext=( xf[end], yloc),
            fontsize=16, ha="center", va="bottom",
            arrowprops=Dict("arrowstyle"=> "|-|, widthA=0.5, widthB=0.5"),
             zorder = 30)
    ax.text(xend/2, yloc, @sprintf("l = %5.1f m", xend), bbox=Dict("ec"=>"w", "fc"=>"w"), ha="center", va="center", fontsize = 14, zorder = 31)

    # Span annotations:
    codeD = true
    codeE = false
    xcodeD = -2.0
    xcodeE = -3.5
        if codeD
            # ICAO code D 
            bmaxD = 36
            ax.vlines(xcodeD, -bmaxD/2, bmaxD/2, lw = 5, alpha = 0.2, color = "y")
            ax.hlines( bmaxD/2, xcodeD, 40.0, lw = 5, alpha = 0.2, color = "y")
            ax.hlines(-bmaxD/2, xcodeD, 40.0, lw = 5, alpha = 0.2, color = "y")
            ax.text(20, bmaxD/2+1, "ICAO Code D/ FAA Group III", color = "y", alpha = 0.8, fontsize = 12, ha="center", va="center")
        end
        if codeE
            # ICAO code E
            bmaxE = 52
            ax.vlines(xcodeE, -bmaxE/2, bmaxE/2, lw = 5, alpha = 0.2, color = "b")
            ax.hlines( bmaxE/2, xcodeE, 40.0, lw = 5, alpha = 0.2, color = "b")
            ax.hlines(-bmaxE/2, xcodeE, 40.0, lw = 5, alpha = 0.2, color = "b")
            ax.text(20, bmaxE/2+1, "ICAO Code E/ FAA Group IV", color = "b", alpha = 0.5, fontsize = 12, ha="center", va="center")
        end

    if codeE
        ax.set_ylim(-27,27)
    elseif codeD
        ax.set_ylim(-23,23)
    else
        ax.set_ylim(-20, 20)
    end
    ax.set_aspect(1)
    ax.set_ylabel("y[m]")
    ax.set_xlabel("x[m]")
    plt.tight_layout()
    # ax.legend()

    return ax
end

function plot_details(parg, pari, para, parm; ax = nothing)
        ## Create empty plot
        if ax === nothing
            plt.style.use(["~/prash.mplstyle", "seaborn-colorblind"])
            fig, atemp = plt.subplots(2, 2, figsize=(8,5), dpi = 100, gridspec_kw=Dict("height_ratios"=>[1, 3], "width_ratios"=>[1,3]))
            gs = atemp[1,2].get_gridspec()
            gssub = matplotlib.gridspec.SubplotSpec(gs, 0,1)
            atemp[1,1].remove()
            atemp[1,2].remove()
            axbig = fig.add_subplot(gssub)
            ax = [axbig, atemp[2,1], atemp[2,2]]
        else
            for a in ax
                a.cla()
            end
        end

        # Drag build-up
        LoD     = para[iaCL, ipcruise1]/ para[iaCD, ipcruise1]
        CL      = para[iaCL, ipcruise1]
        CD      = para[iaCD, ipcruise1]
        CDfuse  = para[iaCDfuse, ipcruise1]
        CDi     = para[iaCDi, ipcruise1]
        CDwing  = para[iaCDwing, ipcruise1]
        CDhtail = para[iaCDhtail, ipcruise1]
        CDvtail = para[iaCDvtail, ipcruise1]
        CDnace  = para[iaCDnace, ipcruise1]

        CDfusefrac  = CDfuse /CD
        CDifrac     = CDi    /CD
        CDwingfrac  = CDwing /CD
        CDhtailfrac = CDhtail/CD
        CDvtailfrac = CDvtail/CD
        CDnacefrac  = CDnace /CD

        # Weight build-up
        Wempty  = parg[igWMTO] - parg[igWfuel] - parg[igWpay]
        Whpesys = parg[igWMTO] * parg[igfhpesys]
        Wlgnose = parg[igWMTO] * parg[igflgnose]
        Wlgmain = parg[igWMTO] * parg[igflgmain]
        Wtotadd = Whpesys + Wlgnose + Wlgmain
        
        Wpay  = parg[igWpay]
        Wfuel = parg[igWfuel]
        WMTO  = parg[igWMTO]

        Wwing  = parg[igWwing]
        Wfuse  = parg[igWfuse]
        Wvtail = parg[igWvtail]
        Whtail = parg[igWhtail]
        Wtesys = parg[igWtesys]
        Wftank = parg[igWftank]

        Wwingfrac = Wwing /WMTO
        Wfusefrac = Wfuse /WMTO
        Wvtailfrac = Wvtail/WMTO
        Whtailfrac = Whtail/WMTO
        Wtesysfrac = Wtesys/WMTO
        Wftankfrac = Wftank/WMTO
        Wtotaddfrac = Wtotadd/WMTO

        Wemptyfrac = Wempty/WMTO
        Wfuelfrac  = Wfuel /WMTO
        Wpayfrac   = Wpay  /WMTO

        a = ax[2]
        bar_width = 0.2
        # ax[1,1].bar("CL", CL)
        CDbars = []
        push!(CDbars, a.bar(0, CDifrac    , width = bar_width, bottom = CDfusefrac+CDwingfrac+CDhtailfrac+CDvtailfrac+CDnacefrac, label = "CDi"))
        push!(CDbars, a.bar(0, CDnacefrac , width = bar_width, bottom = CDfusefrac+CDwingfrac+CDhtailfrac+CDvtailfrac           , label = "CDnace"))
        push!(CDbars, a.bar(0, CDvtailfrac, width = bar_width, bottom = CDfusefrac+CDwingfrac+CDhtailfrac                       , label = "CDvtail"))
        push!(CDbars, a.bar(0, CDhtailfrac, width = bar_width, bottom = CDfusefrac+CDwingfrac                                   , label = "CDhtail"))
        push!(CDbars, a.bar(0, CDwingfrac , width = bar_width, bottom = CDfusefrac                                              , label = "CDwing"))
        push!(CDbars, a.bar(0, CDfusefrac , width = bar_width, label = "CDfuse"))
        
        CDlabels = ["CDi", "CDnace", "CDvtail", "CDhtail", "CDwing", "CDfuse"]

        label_bars(a, CDbars, CDlabels; val_multiplier = CD)
        # a.legend(loc = "upper center")
        # a.legend(bbox_to_anchor=(1.05, 1))
        a.set_xlim(-1,3.5)

        
        Wbar1 = a.bar(1.5, Wpayfrac  , bottom = Wemptyfrac + Wfuelfrac, width = bar_width, label = "Wpay")
        Wbar2 = a.bar(1.5, Wfuelfrac , bottom = Wemptyfrac, width = bar_width, label = "Wfuel")
        Wbar3 = a.bar(1.5, Wemptyfrac, width = bar_width, label = "Wempty")
        Wbars = [Wbar1, Wbar2, Wbar3]
        Wlabels = ["Wpay", "Wfuel", "Wempty"]
        label_bars(a, Wbars, Wlabels, val_multiplier = WMTO/9.81/1000)
        
        Webars = []
        push!(Webars, a.bar(3, Wtotaddfrac , bottom = Wfusefrac+Wwingfrac+Whtailfrac+Wvtailfrac+Wtesysfrac+Wftankfrac, width = bar_width, label = "Wadd"))
        push!(Webars, a.bar(3, Wftankfrac  , bottom = Wfusefrac+Wwingfrac+Whtailfrac+Wvtailfrac+Wtesysfrac, width = bar_width, label = "Wftank"))
        push!(Webars, a.bar(3, Wtesysfrac  , bottom = Wfusefrac+Wwingfrac+Whtailfrac+Wvtailfrac, width = bar_width, label = "Wtesys"))
        push!(Webars, a.bar(3, Wvtailfrac  , bottom = Wfusefrac+Wwingfrac+Whtailfrac, width = bar_width, label = "Wvtail"))
        push!(Webars, a.bar(3, Whtailfrac  , bottom = Wfusefrac+Wwingfrac, width = bar_width, label = "Whtail"))
        push!(Webars, a.bar(3, Wwingfrac   , bottom = Wfusefrac, width = bar_width, label = "Wwing"))
        push!(Webars, a.bar(3, Wfusefrac   , width = bar_width, label = "Wfuse"))
        
        Welabels = ["Wadd" "Wftank" "Wtesys" "Wvtail" "Whtail" "Wwing" "Wfuse"]
        label_bars(a, Webars, Welabels, val_multiplier = WMTO/9.81/1000)

        a.hlines(Wemptyfrac, 1.5+bar_width/2, 3-bar_width/2, lw=0.8, color = "k", ls = "--")
        a.grid()
        a.set_xticks([0, 1.5, 3])
        a.set_xticklabels(["CD","WMTO", "Wempty"])
        # ar.cla()
        # ar = a.twinx()
        # ar.bar(1.7, CDi     , width = 0.4, bottom = CDfuse +CDwing +CDhtail +CDvtail +CDnace , label = "CDi")
        # ar.bar(1.7, CDnace  , width = 0.4, bottom = CDfuse +CDwing +CDhtail +CDvtail            , label = "CDnace")
        # ar.bar(1.7, CDvtail , width = 0.4, bottom = CDfuse +CDwing +CDhtail                        , label = "CDvtail")
        # ar.bar(1.7, CDhtail , width = 0.4, bottom = CDfuse +CDwing                                    , label = "CDhtail")
        # ar.bar(1.7, CDwing  , width = 0.4, bottom = CDfuse                                               , label = "CDwing")
        # ar.bar(1.7, CDfuse  , width = 0.4, label = "CDfuse")
        # ar.grid()



        # Draw mission profile
        a = ax[1]
        h     = [para[iaalt,ipclimb1:ipcruisen]; 0.0]./ft_to_m./1000 # show in 1000s of ft.
        R     = [para[iaRange,ipclimb1:ipcruisen]; para[iaRange, ipdescentn]]./nmi_to_m
        deNOx = pare[iedeNOx, :]
        fracW = [para[iafracW, ipclimb1:ipcruisen]; para[iafracW, ipdescentn]]
        mdotf = pare[iemdotf, :]
        mdotH2O = pare[iemdotf, :].*9.0

        a.plot(R, h)
        a.set_ylim(0, 60.0)
        a.set_xlabel("Range [nmi]")
        a.set_ylabel("Altitude [kft]")

        # Draw stick figure to keep track
        stickfig(parg, pari, parm; ax = ax[3], label_fs = 12)
        plt.tight_layout()

        return ax

end

function label_bars(a, Bararray, labels; val_multiplier = 1)
    for (i,bar) in enumerate(Bararray)
        w, h = bar[1].get_width(), bar[1].get_height()
        x, y = bar[1].get_x(), bar[1].get_y()
        a.text(x+w, y+h/2, @sprintf("%7.3f", h*val_multiplier), ha = "left", va = "center", fontsize = 8)
        a.text(x-w/2, y+h/2, @sprintf("%7s", labels[i]), ha = "right", va = "center", fontsize = 8)
    end
end