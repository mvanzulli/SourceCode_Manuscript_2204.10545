% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%----------------------------------------------------- 
function [fluidProps] = fluidProps(fluid)

    switch fluid
        case "air"
            fluidProps.rho = 1.225;
            fluidProps.nu = 1.6e-5;
        case "water"
            fluidProps.rho = 1020;
            fluidProps.nu = 1.004e-6;
        case "oil"
            fluidProps.rho = 900;
            fluidProps.nu = 1.004e-6;
        case "gas"
            fluidProps.rho = 0.001225;
            fluidProps.nu = 1.5e-5;
        otherwise
            error("Fluid not available");
    end
    
end