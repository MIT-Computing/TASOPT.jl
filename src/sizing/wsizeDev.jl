using Printf
"""
    wsize(pari, parg, parm, para, pare,
        itermax, wrlx1, wrlx2, wrlx3,
        initwgt, initeng, iairf, Ldebug, printiter, saveODperf)

Main weight sizing function. Calls on various sub-functions to calculate weight of fuselage, wings, tails, etc.,
and iterates until the MTOW converges to within a specified tolerance.

CAUTION: This is dev version

!!! details "🔃 Inputs and Outputs"
    **Inputs:**
    - Array of flags that control design choices - fuel types, where to store fuel, etc.
    - Geometric and structural parameters - dimensions primarily
    - Aerodynamic parameters - CL, CD, KE dissipation, etc.
    - Mission-specific parameters - alt, mach, P, T etc.
    - Engine-specific parameters 

    **Outputs:**
    - No explicit outputs. Computed quantities are saved to `par` arrays of `aircraft` model.
"""

function wsize(pari, parg, parm, para, pare,
    itermax, wrlx1, wrlx2, wrlx3,
    initwgt, initeng, iairf, Ldebug, printiter, saveODperf)

    time_propsys = 0.0

    println("Passing")

    if pari[iiengmodel] == 0
        # Drela engine model
        println("Using Drela Engine model")
        use_NPSS = false
    else
        # NPSS
        use_NPSS = true
    end

    inite1 = 0

    if use_NPSS
        NPSS_PT = true
        NPSSsuccess = true
        wsize_fail = false
    else
        ichoke5 = zeros(iptotal)
        ichoke7 = zeros(iptotal)
        Tmrow = zeros(ncrowx)
        epsrow = zeros(ncrowx)
        epsrow_Tt3 = zeros(ncrowx)
        epsrow_Tt4 = zeros(ncrowx)
        epsrow_Trr = zeros(ncrowx)
    end

     # Weight convergence tolerance 
     tolerW = 1.0e-8

     errw = 1.0

    # Initialze some variables
    fsum = 0.0
    ifirst = true

    ifuel = pari[iifuel]
    ifwcen = pari[iifwcen]
    iwplan = pari[iiwplan]
    iengloc = pari[iiengloc]
    iengwgt = pari[iiengwgt]
    iBLIc = pari[iiBLIc]
    ifclose = pari[iifclose]
    iHTsize = pari[iiHTsize]
    iVTsize = pari[iiVTsize]
    ixwmove = pari[iixwmove]
    ifwing = pari[iifwing]

    # Unpack number of powertrain elements
    nfan = parpt[ipt_nfan]
    ngen = parpt[ipt_ngen]
    nTshaft = parpt[ipt_nTshaft]


    # Atmospheric conditions at sea-level
    TSL, pSL, ρSL, aSL, μSL = atmos(0.0)

    # Calculate fuselage B.L. development at start of cruise: ipcruise1
    time_fusebl = @elapsed fusebl!(pari, parg, para, ipcruise1)

    # Kinetic energy area at T.E. at start of cruise: ipcruise1
    KAfTE = para[iaKAfTE, ipcruise1]

    # Surface dissapation area at start of cruise: ipcruise1
    DAfsurf = para[iaDAfsurf, ipcruise1]

    # Wake dissipation area
    DAfwake = para[iaDAfwake, ipcruise1]

    # Momentum area at ∞
    PAfinf = para[iaPAfinf, ipcruise1]

    # Assume K.E., Disspation and momentum areas are const. for all mission points:
    para[iaKAfTE, :] .= KAfTE
    para[iaDAfsurf, :] .= DAfsurf
    para[iaDAfwake, :] .= DAfwake
    para[iaPAfinf, :] .= PAfinf

    # Unpack payload and range for design mission - this is the mission that the structures are sized for
    Rangetot = parm[imRange]

   #Typical payload := Passengers * Weight per passenger
   Wpay = parm[imWpay]

   # Max payload := Max. Pax * Wpax
   Wpaymax = parg[igWpaymax] 

    # if Wpay or Wpaymax is unset
    if (Wpaymax == 0)
        println("Max payload weight was not set, setting Wpaymax = Wpay")
        Wpaymax = parg[igWpaymax] = max(Wpay, Wpaymax)
    end

    # Store the design mission in the geometry array as well
    parg[igRange] = Rangetot
    parg[igWpay] = Wpay

    # Fixed weight and location of fixed weight
    Wfix = parg[igWfix] # Cockpit + pilots weight
    xfix = parg[igxfix] # Location of cockpit + pilots -> inline with pilot's eye


    # Weight fractions
    fapu = parg[igfapu]
    fpadd = parg[igfpadd]
    fseat = parg[igfseat]
    feadd = parg[igfeadd]
    fnace = parg[igfnace]
    fhadd = parg[igfhadd]
    fvadd = parg[igfvadd]
    fwadd = parg[igfflap] + parg[igfslat] +
            parg[igfaile] + parg[igflete] + parg[igfribs] + parg[igfspoi] + parg[igfwatt]


    fstring = parg[igfstring]
    fframe = parg[igfframe]
    ffadd = parg[igffadd]
        
    fpylon = parg[igfpylon]

    fhpesys = parg[igfhpesys]
    flgnose = parg[igflgnose]
    flgmain = parg[igflgmain]

    freserve = parg[igfreserve]

    # fuselage lift carryover loss, tip lift loss fractions

    fLo = parg[igfLo]
    fLt = parg[igfLt]

    # fuselage dimensions and coordinates
    Rfuse = parg[igRfuse]
    dRfuse = parg[igdRfuse]
    wfb = parg[igwfb]
    nfweb = parg[ignfweb]
    hfloor = parg[ighfloor]
    xnose = parg[igxnose]
    xend = parg[igxend]
    xshell1 = parg[igxshell1]
    xshell2 = parg[igxshell2]
    xconend = parg[igxconend]
    xwbox = parg[igxwbox]
    xhbox = parg[igxhbox]
    xvbox = parg[igxvbox]
    xapu = parg[igxapu]
    xeng = parg[igxeng]

    # calculate payload proportional weights from weight fractions
    Wapu = Wpaymax * fapu
    Wpadd = Wpaymax * fpadd
    Wseat = Wpaymax * fseat

    # window and insulation densities per length and per area
    Wpwindow = parg[igWpwindow]
    Wppinsul = parg[igWppinsul]
    Wppfloor = parg[igWppfloor]

    # fuselage-bending inertial relief factors
    rMh = parg[igrMh]
    rMv = parg[igrMv]

    # tail CL's at structural sizing cases
    CLhmax = parg[igCLhmax]
    CLvmax = parg[igCLvmax]

    # wing break, wing tip taper ratios
    λs = parg[iglambdas]
    λt = parg[iglambdat]

    # tail surface taper ratios (no inner panel, so λs=1)
    λhs = 1.0
    λh = parg[iglambdah]
    λvs = 1.0
    λv = parg[iglambdav]

    # tailcone taper ratio
    λc = parg[iglambdac]

    # wing geometry parameters
    sweep = parg[igsweep]
    wbox = parg[igwbox]
    hboxo = parg[ighboxo]
    hboxs = parg[ighboxs]
    rh = parg[igrh]
    AR = parg[igAR]
    bo = parg[igbo]
    ηs = parg[igetas]
    Xaxis = parg[igXaxis]

    # tail geometry parameters
    sweeph = parg[igsweeph]
    wboxh = parg[igwboxh]
    hboxh = parg[ighboxh]
    rhh = parg[igrhh]
    ARh = parg[igARh]
    boh = parg[igboh]

    sweepv = parg[igsweepv]
    wboxv = parg[igwboxv]
    hboxv = parg[ighboxv]
    rhv = parg[igrhv]
    ARv = parg[igARv]
    bov = parg[igbov]

    # number of vertical tails
    nvtail = parg[ignvtail]

    # strut vertical base height, h/c, strut shell t/h
    zs = parg[igzs]
    hstrut = parg[ighstrut]
    tohstrut = 0.05

    # assume no struts on tails
    zsh = 0.0
    zsv = 0.0

    # max g load factors for wing, fuselage
    Nlift = parg[igNlift]
    Nland = parg[igNland]

    # never-exceed dynamic pressure for sizing tail structure
    Vne = parg[igVne]
    qne = 0.5 * ρSL * Vne^2

    # wingbox stresses and densities [section 3.1.9 taspot.pdf [prash]] #reference
    σcap = parg[igsigcap] * parg[igsigfac]
    tauweb = parg[igtauweb] * parg[igsigfac]
    rhoweb = parg[igrhoweb]
    rhocap = parg[igrhocap]

    # fuselage stresses and densities
    σskin = parg[igsigskin] * parg[igsigfac]
    σbend = parg[igsigbend] * parg[igsigfac]
    rhoskin = parg[igrhoskin]
    rhobend = parg[igrhobend]

    # fuselage shell bending/skin modulus ratio
    rEshell = parg[igrEshell]

    # strut stress and density
    σstrut = parg[igsigstrut] * parg[igsigfac]
    rhostrut = parg[igrhostrut]


    # assume tail stresses and densities are same as wing's (keeps it simpler)
    σcaph = σcap
    tauwebh = tauweb
    rhowebh = rhoweb
    rhocaph = rhocap

    σcapv = σcap
    tauwebv = tauweb
    rhowebv = rhoweb
    rhocapv = rhocap

    # number of engines, y-position of outermost engine
    neng = parg[igneng]
    yeng = parg[igyeng]

    # fan hub/tip ratio
    HTRf = parg[igHTRf]

    # nacelle wetted area / fan area ratio
    rSnace = parg[igrSnace]

    # set cruise-altitude atmospheric conditions
    ip = ipcruise1
    altkm = para[iaalt, ip] / 1000.0
    T0, p0, ρ0, a0, μ0 = atmos(altkm)
    Mach = para[iaMach, ip]
    pare[iep0, ip] = p0
    pare[ieT0, ip] = T0
    pare[iea0, ip] = a0
    pare[ierho0, ip] = ρ0
    pare[iemu0, ip] = μ0
    pare[ieM0, ip] = Mach
    pare[ieu0, ip] = Mach * a0
    para[iaReunit, ip] = Mach * a0 * ρ0 / μ0

    # set takeoff-altitude atmospheric conditions
    ip = iprotate
    altkm = para[iaalt, ip] / 1000.0
    T0, p0, ρ0, a0, μ0 = atmos(altkm)
    Mach = 0.25
    pare[iep0, ip] = p0
    pare[ieT0, ip] = T0
    pare[iea0, ip] = a0
    pare[ierho0, ip] = ρ0
    pare[iemu0, ip] = μ0
    pare[ieM0, ip] = Mach
    pare[ieu0, ip] = Mach * a0
    para[iaReunit, ip] = Mach * a0 * ρ0 / μ0

    # Set atmos conditions for top of climb
    ip = ipclimbn
    altkm = para[iaalt, ipcruise1] / 1000.0
    T0, p0, ρ0, a0, μ0 = atmos(altkm)
    Mach = para[iaMach, ip]
    pare[iep0, ip] = p0
    pare[ieT0, ip] = T0
    pare[iea0, ip] = a0
    pare[ierho0, ip] = ρ0
    pare[iemu0, ip] = μ0
    pare[ieM0, ip] = Mach
    pare[ieu0, ip] = Mach * a0
    para[iaReunit, ip] = Mach * a0 * ρ0 / μ0

    # -------------------------------------------------------    
    ## Initial guess section [Section 3.2 of TASOPT docs]
    # -------------------------------------------------------

    
























     





end