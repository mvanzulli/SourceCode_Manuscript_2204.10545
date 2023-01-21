# Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
#
# Development and implementation of a consistent co-rotational 
# formulation for aerodynamic nonlinear analysis of frame structures.
#
# Plot all examples results
#
for((i=1;i<=4;i++)); do cd Example_${i} && nohup bash post_process_Example_${i}.sh && cd .. & done
#
# Plot S809 aero coefs and cross section
cd S809airfoil && chmod +x plot_S809.sh && ./plot_S809.sh && cd .. 