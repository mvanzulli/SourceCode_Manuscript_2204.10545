% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%----------------------------------------------------- 
% This file downloads (if it is not already done) and add ONSAS to the path
function [ONSAS_path] = addONSAS()

    % ONSAS path relative to the examples folder
    ONSAS_path = "./../../ONSAS" ;

    % Check if ONSAS has not been downloadad
    if ~exist(ONSAS_path, "dir")
        system("./../../download_ONSAS.sh") ;
    end

end