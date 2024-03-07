# This is an example file to load an aircraft model/ input file and 
# size an aircraft using TASOPT. 

# 1) Load TASOPT
using TASOPT
# you can optionally define
# const tas = TASOPT 
# to use as a shorthand

# 2) Include input file for desired aircraft/
#  load default model
#example_ac = load_default_model() # simply a synonym to read_aircraft_model()
# Alternatively you can load your desired input file 
#example_ac = read_aircraft_model("../src/IO/input.toml") # MODIFY <path> appropriately

example_ac = read_aircraft_model("../Models/Airbus/A319-200/Design/A319_input.toml") # MODIFY <path> appropriately
# 3) Size aircraft
time_wsize = @elapsed size_aircraft!(example_ac)
println("Time to size aircraft = $time_wsize s")
