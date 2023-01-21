# Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
#
# Development and implementation of a consistent co-rotational 
# formulation for aerodynamic nonlinear analysis of frame structures.
#
# Run all examples
#
for((i=1;i<=4;i++)); do cd Example_${i} && nohup bash run_Example_${i}.sh && cd .. & done