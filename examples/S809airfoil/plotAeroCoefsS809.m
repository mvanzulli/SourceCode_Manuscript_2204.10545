% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------
% S809 airfoil profile
%-----------------------------------------------------
% NREL’s S809 Airfoil (s809-nr).http://airfoiltools.com/airfoil/details?
% airfoil=s809-nr, 2017. Accesse: 2017-07-12. 
% Mark Drela. Xfoil: An analysis and design system for low reynolds number airfoils.
% In Low Reynolds number aerodynamics, pages 1–12. Springer, 1989.
%-----------------------------------------------------

function [] = plotAeroCoefsS809()
    close all
    
    % Plot params
    lwAxis = 4 ; lwCurve = 1 ; ms = 4 ;
    axisFontSize = 15 ; curveFontSize = 12;  legendFontSize = 10; axisValueFontSize = 15; 
    
    % Vecs to plot
    betaRelVec = linspace(-20,40,100);
    betaRelRad = deg2rad(betaRelVec);
    
    S809props = secMatAeroPropsS809() ;

    % Compute aero coefs vectors
    y1 = zeros(length(betaRelVec),1) ;
    y2 = zeros(length(betaRelVec),1) ;
    y3 = zeros(length(betaRelVec),1) ;

    

    % Compute aero coeficients
    for betaIndex = 1:length(betaRelVec)
      y1(betaIndex) = feval(S809props.dragFunc, betaRelRad(betaIndex))  ;
      y2(betaIndex) = feval(S809props.liftFunc, betaRelRad(betaIndex))  ;
      y3(betaIndex) = feval(S809props.momFunc, betaRelRad(betaIndex))   ;
    end  

    % initilize figure
    fig = clf ;
    % plot cd
    labx1 = subplot(3,1,1);
    plot(betaRelVec, y1,'Color','k','linestyle','-','LineWidth', lwCurve) ;
    grid on
    xlabel_string = '$ \beta ~ [^{\circ}] $'                              ;
    labx1 = xlabel(xlabel_string); laby1 = ylabel("$c_d$")                ;
    set(labx1, 'FontSize', axisFontSize, 'Color', 'k')                    ;
    set(laby1, 'FontSize', axisFontSize, 'Color', 'k')                    ;
    
    % plot c_l
    subplot(3,1,2);
    plot(betaRelVec, y2,'Color','k','linestyle','-','LineWidth', lwCurve)
    grid on
    labx2 = xlabel(xlabel_string); laby2 = ylabel("$c_l$")                ;
    set(labx2, 'FontSize', axisFontSize, 'Color', 'k')                    ;
    set(laby2, 'FontSize', axisFontSize, 'Color', 'k')                    ;

    % plot c_m
    subplot(3,1,3);
    plot(betaRelVec, y3,'Color','k','linestyle','-','LineWidth', lwCurve)
    grid on
    labx3 = xlabel(xlabel_string); laby3 = ylabel("$c_m$")                ;
    set(labx3, 'FontSize', axisFontSize, 'Color', 'k')                    ;
    set(laby3, 'FontSize', axisFontSize, 'Color', 'k')                    ;

    % print figure
    printPathExample = [ '../../../tex/' ]                                ;
    namefig = strcat(printPathExample, 'dragLiftMomentS809')              ;
    print( fig, namefig, '-depslatex' )                                   ;

    close(1)

end