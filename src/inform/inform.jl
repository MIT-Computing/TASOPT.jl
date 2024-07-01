using Printf

function print_table(pari)
    # Define the indices for the variables
    iifuel, iifwcen, iiwplan, iiengloc, iiengwgt, iiBLIc, iifclose, iiHTsize, iiVTsize, iixwmove, iifwing = 1:11

    # Assign the values from the pari array
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

    # Print the variables in a tabular manner
    println("-------------------------------------------------")
    @printf("%-40s %-10s\n", "Variable", "Value")
    println("-------------------------------------------------")
    @printf("%-40s %-10d\n", "Fuel type (Jet A)", ifuel == 24 ? 1 : 0)
    @printf("%-40s %-10s\n", "Fuel stored in center tanks", ifwcen == 0 ? "NO" : "YES")
    @printf("%-40s %-10s\n", "Cantilevered wing", iwplan == 1 ? "YES" : "NO")
    @printf("%-40s %-10s\n", "Engine mounted on wing", iengloc == 1 ? "YES" : "NO")
    @printf("%-40s %-10s\n", "Engine weight model", iengwgt == 1 ? "Basic" : "Advanced")
    @printf("%-40s %-10s\n", "Engine core in clean flow", iBLIc == 0 ? "YES" : "NO")

    if ifclose == 0
        @printf("%-40s %-10s\n", "CAUTION: Fuselage tapers to a point!", "")
        @printf("%-40s %-10s\n", "Recommend setting ifclose to 1 (tapers to edge)", "")
    else
        @printf("%-40s %-10s\n", "Fuselage tapers to edge", "YES")
    end

    @printf("%-40s %-10s\n", "Horizontal tail sizing method", iHTsize == 1 ? "Tail volume coefficient" : "Max. forward C.G")
    @printf("%-40s %-10s\n", "Vertical tail sizing method", iVTsize == 1 ? "Tail volume coefficient" : "Max. engine-out conditions")

    @printf("%-40s %-10s\n", "Wing position fixed", ixwmove == 0 ? "YES" : "NO")
    if ixwmove == 1
        @printf("%-40s %-10s\n", "Wing move criteria", "Get CLh=\"CLhspec\" in cruise")
    else
        @printf("%-40s %-10s\n", "Wing move criteria", "Get min static margin")
    end

    @printf("%-40s %-10s\n", "Store fuel in wing", ifwing == 1 ? "YES" : "NO")

    println("-------------------------------------------------")
end
