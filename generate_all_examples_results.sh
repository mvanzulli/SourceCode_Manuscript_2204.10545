# Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
#
# Development and implementation of a consistent co-rotational 
# formulation for aerodynamic nonlinear analysis of frame structures.
#
# Run all examples
#
for((i=3;i<=3;i++)); do cd examples/Example_${i} && nohup bash reproduce_Example_${i}.sh && cd .. & done
