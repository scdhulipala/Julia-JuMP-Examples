###################################################
# Surya
# NREL
# Simple Economic Dispatch Problem 
# with two generators using JuMP Package
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
const d = 1500;
const w_f = 200;
##################################################
# Function to solve Economic Dispatch Problem
##################################################
function solve_ed(g_max, g_min, c_g, c_w, d, w_f)
# JuMP Model
ed=Model(with_optimizer(Cbc.Optimizer))

    @variable(ed, 0 <= g[i=1:2]) # power output of generators

    @variable(ed, 0 <= w) # wind power injection

    # JuMP Objective Function

    @objective(ed,Min,sum(c_g[i] * g[i] for i=1:2)+ c_w * w)

# Define the constraint on the maximum and minimum power output of each generator

    for i in 1:2

        @constraint(ed,  g[i] <= g_max[i]) #maximum

        @constraint(ed,  g[i] >= g_min[i]) #minimum

    end

    # Define the constraint on the wind power injection

    @constraint(ed, w <= w_f)

    # Define the power balance constraint

    @constraint(ed, sum(g[i] for i=1:2) + w == d)

optimize!(ed)

return JuMP.value.(g), JuMP.value.(w), w_f- JuMP.value.(w), objective_value(ed)

end
##################################################
# Solve the economic dispatch problem
##################################################
(g_opt,w_opt,ws_opt,obj)=solve_ed(g_max, g_min, c_g, c_w, d, w_f);