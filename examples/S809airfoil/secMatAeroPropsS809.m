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
function [S809props] = secMatAeroPropsS809()
    % material scalar parameters
    Eeq = 14e9 ; Geq = 5.6e9 ; rhoeq = 1850 ; nueq= (Eeq / (2*Geq))  - 1 ;
    % geometrical scalar parameters (extracted from Faccio 2017 page 93)
    dch = 1 ; A = 206.25e-4 ; Iyy =  10096e-4 ; Izz = 176306e-4 ;  J = Iyy + Izz ; 
    %
    Irho = rhoeq * [ J 0   0    ;
                    0 Iyy 0     ;
                    0 0   Izz ] ;

    % material
    S809props.E    = Eeq   ;
    S809props.G    = Geq   ;
    S809props.rho  = rhoeq ;
    S809props.nu   = nueq  ;
    % cross-section
    S809props.dch  = dch   ;
    S809props.A    = A     ;
    S809props.Iyy  = Iyy   ;
    S809props.Izz  = Izz   ;
    S809props.J    = J     ;
    S809props.Irho = Irho  ;
    % aerodynamic props
    S809props.dragFunc = 'dragCoefS809'   ;
    S809props.liftFunc = 'liftCoefS809'   ;
    S809props.momFunc  = 'momentCoefS809' ;

end