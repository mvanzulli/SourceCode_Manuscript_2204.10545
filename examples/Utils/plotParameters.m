% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------

function plotParams = plotParameters()

    % Line parameters:
    plotParams.lw = 2 ; plotParams.ms = 12 ;
    % labels parameters:
    plotParams.axislw = 1 ; 
    plotParams.labelAxisFontSize = 20 ;
    plotParams.ticsLabelsLegendFontSize = 18 ;   

    % Colours to plot
    red               = '#D95319'                                   ;
    plotParams.red    = sscanf(red(2:end),'%2x%2x%2x',[1 3])/255    ;
    cyan              = '#4DBEEE'                                   ;
    plotParams.cyan   = sscanf(cyan(2:end),'%2x%2x%2x',[1 3])/255   ;
    violet            = '#420074'                                   ;
    plotParams.violet = sscanf(violet(2:end),'%2x%2x%2x',[1 3])/255 ;
    blue              = '#4073FF'                                   ;
    plotParams.blue   = sscanf(blue(2:end),'%2x%2x%2x',[1 3])/255   ;
    yellow            = '#FFC000'                                   ;
    plotParams.yellow = sscanf(yellow(2:end),'%2x%2x%2x',[1 3])/255 ;
    green             = '#77AC30'                                   ;
    plotParams.green  = sscanf(green(2:end),'%2x%2x%2x',[1 3])/255  ;
    
    % Static large displacements case
    % Analaytic solutions
    plotParams.colourRef = ['k']    ;
    plotParams.markersRef= ['none'] ;
    % Formulation considering aero stiffness (F3)
    plotParams.F3ms      = [plotParams.ms + 3; plotParams.ms] ;
    plotParams.F3markers = ['x'; 'o'] ;
    plotParams.F3colors  = [red; red] ;
    % Formulation neglecting aero stiffness and consitent mass matrix (F2)
    plotParams.F2ms      = [plotParams.ms + 3; plotParams.ms] ;
    plotParams.F2markers = ['s'; '+']       ;
    plotParams.F2colors  = [violet; yellow] ;
    % Formulation neglecting aero stiffness and lumped mass matrix (F1)
    plotParams.F1ms      = [plotParams.ms - 2; plotParams.ms] ;
    plotParams.F1markers = ['*'; '^']       ;
    plotParams.F1colors  = [cyan; green] ;

    % Folder to plot figures
    plotParams.printPathExample = [ '../../numerical_results/' ] ;
    mkdir(plotParams.printPathExample)
end