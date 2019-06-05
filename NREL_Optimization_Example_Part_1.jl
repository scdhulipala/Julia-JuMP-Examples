###################################################
# Surya
# NREl Julia Lang Tutorial - Optimization Example
###################################################
# Importing Packages
###################################################
using JuMP
using Cbc
###################################################
# JuMP model with new syntax using Cbc Solver
example = Model(with_optimizer(Cbc.Optimizer))
###################################################
# Define problem parameters for product a & b
###################################################
MachineHours = Dict{Symbol, Int}()
MachineHours[:a] = 3
MachineHours[:b] = 4

ProductionCost = Dict{Symbol, Float64}()
ProductionCost[:a] = 3
ProductionCost[:b] = 2

SellingPrice = Dict{Symbol, Float64}()
SellingPrice[:a] = 6
SellingPrice[:b] = 5.4

TotalMachineHours = 20_000
@variable(example, Quantity[[:a, :b]] >= 0, Int)
###################################################
# Constraints & Objective Function
###################################################
# Define machine hours constraint
@constraint(
            example,
            Quantity[:a] * MachineHours[:a] +
                Quantity[:b] * MachineHours[:b] <= TotalMachineHours
           )
# Define profit-maximizing objective function
@objective(
           example, Max,
           -1 * ( Quantity[:a] * ProductionCost[:a] +
                    Quantity[:b] * ProductionCost[:b] ) +
           Quantity[:a] * SellingPrice[:a] +
               Quantity[:b] * SellingPrice[:b]
          )
###################################################
# Solve the model and display results
###################################################
optimize!(example)

# Report production quantities and total profit
@show JuMP.value(Quantity[:a])
@show JuMP.value(Quantity[:b])
@show objective_value(example)



