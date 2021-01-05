"""
PMSM sizes the electric machine for the motor and generator 
    of the turbo electric powertrain

Inputs:
 - P      :   power [W]
 - N      :   Rotational speed [1/s] 
 - ratAsp :   Aspect ratiodRot/lRot 
 - σAg    :   Air-gap shear stress


Outputs:
 - Preq   : Required input power
 - η      : Overall efficiency P/Preq
 - W      : Weight of machine [N]
 - l      : Length of machine [m]
 - d      : Diameter of machine [m]


Originally based of code by W. Enders
Modified and updated by P. Prashanth 
"""
function PMSM(P::Float64, ratAsp::Float64, σAg::Float64, ratSplit::Float64, parte::Array{Float64, 1} )

    # Setup/ assumptions
        Vtip = 200 # [m/s] Rotor tip speed with retaining sleeve

        # Rotor dimensions (See Hendershot p89)
            # |T| = |F*r| = (π*D*L)*σ * D/2
            # P = Tω =  (π*D*L)*σ * D/2 *V/(D/2) 
            lRot = sqrt(P/(π*ratAsp*σAg*Vtip))
            dRot = lRot*ratAsp

            N = Vtip/(dRot*π)
   
    # Rotational speed
        ω = 2π*N    

    # Unpack paramters
        ratAg = parte[ite_ratAg]
        ratM  = parte[ite_ratM ]
        hRS   = parte[ite_hRS  ]
        ratSp = parte[ite_ratSp]
        ratSM = parte[ite_ratSM]
        ratSd = parte[ite_ratSd]
        ratW  = parte[ite_ratW ]
        Nshrt = parte[ite_Nshrt]

        p     = parte[ite_p]
        z     = parte[ite_z]
    # ------------------
    # Machine geometry
    # ------------------
        Q = P/ω
        Qmax = 1.5*Q

        rRot = dRot/2.0

        hAg = ratAg*dRot + hRS # Air-gap Thickness
        hM  = ratM*hAg

        # Electric frequency
            rRoti = dRot/2 - (hM + hRS) #inner radius of rotor
            f = p * N
            Ω = f * 2π
            Vtip >= (rRoti + 0.5*hM)*ω ? println("Vtip check passed") : println("Warning Vtip test not passed")
        
        # Calculate Slot geometry
            NS  = ratSp * p  # Number of slots
            hS  = ratSM * hM # Slot height
            hSd = ratSd * hS # Slot depression height
            wST = 2π/Ns * (rRoti + hM + hAg + hSd + 0.5*hS) # Slot pitch

            wT = wST * ratW # Tooth width
            wS = wST - wT

            κS  = wS/(rRoti + hAg - hRS + hSd + 0.5*hS) # Angular width of stator gaps see W. Enders thesis
            wSi = κS * (rRoti + hAg + hM + hSd)         # Arc length of inner part of stator

            δ = wS/wST

            # Stator back Iron height
                hSBI = rRot/ratSplit - (rRot + hAg + hRS + hSd + hS)

            # Slots/pole/phases
                m = NS/(2*p*z)
                NSz = NS/z

                NSfpc = floor(m*z)
                NSc   = NSfpc - Nshrt
                cSp   = NSc/NS

            # Winding lengths
                l_ax  =  π * cSp * (rRoti + hAg + hM + hSd + 0.5*hS) * δ/sqrt(1-δ^2)
                l_cir = 2π * cSp
                
                l_ewind = 2. * sqrt(l_ax^2 + (l_cir/2)^2)
            # Minimum magnet skew angle to prevent Cogging Torque
                κMs = 1/p * 180./π
            
        # Calc correction factors
            α = π * NSc/NSfpc
            kp = sin(α/2)

            γ  = 2π * p /NS
            kb = sin(m*γ/2)/(m*sin(γ/2))

            kw = kp*kb

            # Skew factor (Jagiela2013)
            κMs_rad = κMs * π/180.
            ks = sin(p*κMs_rad/2) / (p*κMs_rad/2)

            # Magentic gap factor
            rs = rRoti + hM + hAg
            r2 = rRoti + hM
            kg = ((rRoti^(p-1))/(rs^(2*p) - rRoti^(2*p))) * 
                 (  (p/(p+1))            * (r2^(p+1) - rRoti^(p+1)) + 
                    (p/(p-1)) * rs^(2*p) * (rRoti^(1-p) - r2^(1-p))  )
            
        # Calcualte back EMF
            Kc = 1/(1-(1/((wST/wS)*((5*hAg/wS)+1))));
            hAgEff = Kc*hAg        # Effective Air-gap
            Cphi = (p*κM)/180  # Flux concentration factor
            K1 = 0.95              # Leakage factor
            Kr = 1.05              # Reluctance factor
            murec = 1.05           # Recoil permeability

            PC  = hM/(hAgEff*Cphi);  # Permeance coefficient
            BAg = ((K1*Cphi)/(1+(Kr*murec/PC)))*Br;

        # Calculate magnetic flux and internal voltage
            κMrad = κM*(π/180);

            BC1 = (4/π)*BAg*kg*sin(p*κMrad/2);
            λ = 2*rs*lRot*NSz*kw*ks*BC1/p;

            ErmsD  = omega*λ/sqrt(2); # RMS back voltage
    
        # Calculation of inductance and total reactance
            # Air-gap inductance
                LAg = (z)*(2/π)*(mu0*NSz^2*kw^2*lRot*rs)/(p^2*(hAg+hM));

            # Slot leakage inductance
                Cperm = mu0*((1/3)*(hS/wSi) + hSd/wSi);
                Las = 2*p*lRot*Cperm*(4*(m-NShrt)+2*NShrt);
                Lam = 2*p*lRot*NShrt*Cperm;
                Ls = Las - Lam; # equ. for 3 phases only

            # End-turn inductance 
                areaS = wS*hS; # Slot area
                Le = 0.25*(mu0*wST*NSz^2)*log(wST*sqrt(π)/sqrt(2*areaS));
                #wST only true, if coils are placed in neighboring slots 


            # Total inductance and reactance per phase
                Ltot = LAg+Ls+Le;
                Xtot = omega*Ltot;


        ## ------------Calculation of machine dimensions and weights---------------
        #Armature
            #Total Armature length per phase (assuming two coils per slot)
                lArm=2*NSz*(lRot+lEt); 
            # Armature conductor area
                areaArm = 0.5*areaS*kpf;
            # Total mass of armature conductor #mass=pha*l*area*rho
                mArm = z*lArm*areaArm*rhoCon;
        
        
        #Iron /Stator Core
            # SBI inside radius
                rSBIi = rRoti+hM+hAg+hSd+hS;
            # SBI outside radius
                rSBIo = rSBIi + hSBI;
            # Core mass
                mSBI = pi*(rSBIo^2-rSBIi^2)*lRot*rhoIron; # SBI
                mTeeth = (NS*wT*hS+2*pi*(rRoti+hAg)*hSd-NS*hSd*wSd)*lRot*rhoIron; # Teeth
                mIron = mSBI + mTeeth;
        
        # Magnet mass
            mM = (p*kappaMrad)*((rRoti+hM)^2-rRoti^2)*lRot*rhoMag; 
        
        # Shaft mass (Hollow shaft)
            #tauMax=Qmax/Wt Wt=section modulus (Widerstandsmoment)
            #Wt=pi/16*(da^4-di^4)/da, (Dankert,Technische Mechanik, 2018)
            lShft  = 1.2*lRot; #Assumption to account for bearings, endcaps, etc.
            rShfto = 0.5*((16*Qmax)/(tauMax*pi*(1-ratShft^4)))^(1/3); #Outer shaft radius
            mShft  = (pi*rShfto^2*(1-ratShft^2))*lShft*rhoShft; #Mass of shaft
            tShft  = rShfto*(1-ratShft); #thickness of shaft, just for comparison
        
        # Service mass fraction
            # #kServ = 1.15; # Rucker2005
            # #kServ= 1.5;   # Yoon2016 (Tab.4) Excluding Ground Cylinder and Heat Sink
            # kServ= 1.7;    # Yoon2016 (Tab.4) Including Ground Cylinder and Heat Sink
        
        
        # Total mass
            mPMSM = kServ*(mIron+mShft+mM+mArm); 
        
        
        # Final machine dimensions
        lPMSM = lRot+2*lEtAx; #Total length
        dPMSM = 2*rSBIo; # Total diameter without housing
    
    # --------------------------
    # Machine performance
    # --------------------------
        ## Calculate design current and Armature resistance 
            #Armature RMS Current
                #IrmsD=POutD/(z*cos(psi)*ErmsD);
                IrmsD=1/(sqrt(2)*3)*Q/(kw*ks*NSz*BAg*(rRoti+hM)*lRot); #(Lipo2017)
        
            #Armature resistance per phase
                Rarm = lArm*(1+thetaCon*(Tarm-293.15))/(sigCon*areaArm); #Pyrhönen2008 
        
        ##Terminal Voltage
            VaD = sqrt(ErmsD^2-((Xtot+Rarm)*IrmsD*cos(psi))^2)-(Xtot+Rarm)*IrmsD*sin(psi);
        
        
        ## Loss Calculations
            #Copper losses
                PLcopD = z*IrmsD^2*Rarm; #Total Design Copper Losses
        
            #Iron losses
                Bt = (wT+wS)/wT*BAg; #Tooth Flux Density (eq. 8.77,Lipo2017IntroToACDesign)
                if Bt > BSat
                    println("ERROR: Bt > Saturation flux density BIronSat")
                    limitsPMSM[3]=1;
                end
        
                Bsbi = BAg*rRoti*pi/(2*p*kst*hSBI); #BackIron flux density(Hanselman eq 9.7)
                if Bsbi > BSat
                    println("ERROR: Bsbi > Saturation flux density BIronSat")
                    limitsPMSM[4]=1;
                end
            
            
                PLsbiD = mSBI*pb0*abs(Bsbi/Bb0)^epsb*abs(f/fb0)^epsf; # Design SBI Losses
                PLtD = mTeeth*pb0*abs(Bt/Bb0)^epsb*abs(f/fb0)^epsf; # Design Teeth Losses
                PLironD = PLsbiD + PLtD;# Total Design Core Losses
        
            #Windage loss
                Re = nD*2*pi*rRoti*hAg/nuAirD; #Reynold's number in air gap
                Cf= 0.0725*Re^(-0.2); #Friction coefficient
                PLwindD = Cf*pi*rhoAirD*(nD*2*pi)^3*rRoti^4*lRot; #Design Windage losses
        
        
        ## Design Efficiency and Current Density Calculation
            #Input power and efficiency
            PinD = POutD+PLironD+PLcopD+PLwindD;
            etaD= POutD/PinD;
        
        # Current density
            JarmD = IrmsD/areaArm;
            if JarmD > 3e7
                println("ERROR: JaD > 3e7 [A/m^2]")
                limitsPMSM[5]=1;
            end


end

function PMSM(P::Float64, N::Float64, parp)

    # λ = 

    # kw = 
    # ks =
    # NSz = 
    # BAg = 
    # rRot =
    # hM   = 
    # lRot =


    # Calculations
        ω = 2π*N
        Q = P/ω

        f = p * N
        Ω = 2π*f

        Erms = Ω * λ / sqrt(2)
        Irms = 1/(3*sqrt(2)) * Q / 
               (kw * ks * NSz * BAg * (rRot + hM)*lRot)

        Jarm = Irms/areaArm

        # Losses
            PLsbi = mSBI  * pb0 * abs(Bsbi/Bb0)^epsb * abs(f/fb0)^epsf
            PLt   = mTeeth* pb0 * abs(  Bt/Bb0)^epsb * abs(f/fb0)^epsf
            PLiron = PLsbi + PLt

            Re = ω*rRoti*hAg*ρair/μair
            Cf = 0.0725/Re^0.2
            PLwind = ρair * π * Cf * ω^3 * rRoti^4 * lRot

            PLcu = z * Irms^2 * Rarm

            PL = PLiron + PLwind + PLcu

        Preq = P + PL
        η    = P/Preq

    return Preq, η, PL
end