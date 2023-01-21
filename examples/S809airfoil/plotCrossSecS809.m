% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------
% S809 airfoil profile
%-----------------------------------------------------
function [] = plotCrossSecS809()

    % close all figures
    close all
    % Print path
    printPathExample = [ '../../../tex/' ] ;
    % line parameters:
    lw = 3 ; ms = 1e-2 ; spanPlotTime = 1 ;
    % labels parameters:
    axislw = 2 ; axisFontSize = 20 ; legendFontSize = 15 ; curveFontSize = 15 ;  
    % Read cross sec coords
    [x y] = S809coords() ;
    % plot cross section
    fig1 = figure(1) ;
    plot(x, y, 'color', 'black', 'linewidth', lw, 'linestyle', '-', 'markersize', ms, 'marker', 'none' )
    grid on 
    labx = xlabel('$x/d_c$ ');   laby = ylabel('$y/d_c$')                                  ;
    set(gca, 'linewidth', axislw, 'fontsize', curveFontSize )                              ;
    set(labx, 'FontSize', axisFontSize); set(laby, 'FontSize', axisFontSize)               ;
    axis([0, 1, -.5, .5])
    namefig1 = strcat(printPathExample, 'S809crossSec')                                    ;
    delete (findobj ("tag", "legend"))
    print(fig1, namefig1, '-depslatex');
    close(1)

end