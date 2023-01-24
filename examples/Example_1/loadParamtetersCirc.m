
% #md Reconfiguration problem validation (Drag reduction of flexible plates by reconfiguration, Gosselin, etAl 2010)
%----------------------------
function [l, d, Izz, E, nu, rhoS, rhoF, nuF, dragCoefFunction, NR, ...
     cycd_vec, fluid_vel_vec, tc, index_case_1, index_case_2 ] = loadParamtetersCirc()
    % values extracted from https://github.com/lm2-poly/Reconfiguration-Beam/blob/master/reconfiguration.m
    NR      =10;  %NUMBER OF CYCD POINTS
    cycdmin =-2 ;  %SMALLEST VALUE OF CYCD = 10^cymin
    cycdmax =5  ;  %LARGEST VALUE OF CYCD = 10^cymax with cy = rho * L^3 * U^2 / 16 EI 
    cycdvec_indexes   = linspace(cycdmin, cycdmax, NR) ;
    % Geometric params
    l  = 1                ;
    d  = l/100            ;
    Izz = pi * d ^ 4 / 64 ;  
    % Material params
    E = 30e6 ;  nu = 0.3 ; rhoS = 7000 ; B = E*Izz;
    % Fluid properties
    Utils_path = "./../Utils"        ;
    addpath( genpath( Utils_path ) ) ;
    waterProps = fluidProps("water") ;
    dragCoefFunction = 'dragCircular';
    rhoF = waterProps.rho ; nuF = waterProps.nu ; c_d = feval(dragCoefFunction, 0, 0) ;
    % fill fluid velocity vector for each cy 
    fluid_vel_vec = [] ;
    cycd_vec = [] ;
    for cy_index = cycdvec_indexes
        cycd = 10^cy_index          ;   
        cycd_vec = [cycd_vec, cycd]   ;
        fluid_vel_vec =[fluid_vel_vec, sqrt(cycd * 2 * B / (c_d * l^3 * d * rhoF))];
    end

    % time where the fluid velocity becomes constant
    tc = 7 ; 
    % indexes of the vector fluid vec that are executed in dynamic analysis
    index_case_1 = length(fluid_vel_vec) - 1 ; 
    index_case_2 = length(fluid_vel_vec) - 3 ;

end