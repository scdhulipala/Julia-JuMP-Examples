###################################################
# Surya
# NREL
# Simple Economic Dispatch Problem 
# with two generators using JuMP Package for two hours
###################################################
using JuMP
using Cbc
# Importing Packages
###################################################
# Defining the parameters of generators
# g_max and g_min - Minimum and Maximum dispatchable
# power of generators
# c_g and c_w - cost of generation
# d- demand and w_f - wind availability
###################################################
const g_max=[1000,1000];
const g_min=[0,300];
const c_g=[50,100];
const c_g0=[1000,0];
const c_w = 50;
const d = [1500, 1400];
const w_f = [200, 150];
##################################################
# Function to solve Economic Dispatch Problem 
##################################################
function solve_ed(g_max, g_min, c_g, c_w, d, w_f)
#JuMP Model
ed=Model(with_optimizer(Cbc.Optimizer))

    @variable(ed, 0 <= g[i=1:2,t=1:2]) # power output of generators for t=1,2

    @variable(ed, 0 <= w[t=1:2]) # wind power injection for t =1,2

    # JuMP Objective Function

    @objective(ed,Min,sum(sum(c_g[i] * g[i,t] for i=1:2)+c_w * w[t] for t=1:2))

# Define the constraint on the maximum and minimum power output of each generator for t=1,2

    for i in 1:2, t=1:2

        @constraint(ed,  g[i,t] <= g_max[i]) #maximum

        @constraint(ed,  g[i,t] >= g_min[i]) #minimum

    end

    
    for t in 1:2
        # Define the constraint on the wind power injection
        @constraint(ed, w[t] <= w_f[t])
        # Define the power balance constraint
        @constraint(ed, sum(g[i,t] for i=1:2) + w[t] == d[t])

    end

    
optimize!(ed)

return JuMP.value.(g), JuMP.value.(w), w_f- JuMP.value.(w), objective_value(ed)

end
##################################################
# Solve the economic dispatch problem
##################################################
(g_opt,w_opt,ws_opt,obj)=solve_ed(g_max, g_min, c_g, c_w, d, w_f);