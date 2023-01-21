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

function c_l = liftCoefS809(betaRel, Re)
  if abs(rad2deg( betaRel ) ) <= 8 
      c_l = 5.01338 * betaRel + 0.21667                                                 ;
  elseif 8 < rad2deg( betaRel ) && rad2deg( betaRel ) <= 20
      c_l = -6.83918 * betaRel ^ 2 + 5.01338 * betaRel + 0.33333                  ;
  elseif rad2deg( betaRel ) > 20 && rad2deg( betaRel ) <= 90
      c_l = -7.9491 * betaRel ^ 3 + 20.9865 * betaRel ^ 2 -16.2918 * betaRel + 4.7179   ;
  elseif -15 <=rad2deg( betaRel ) && rad2deg( betaRel ) < -8
      c_l = -44.5524 * betaRel ^ 2 + -15.4289 * betaRel + -1.7857                       ; 
  elseif -20 <rad2deg( betaRel ) && rad2deg( betaRel ) < -15
      c_l = -2.2918 * betaRel + -1.4000                                                 ;
  elseif -25 <rad2deg( betaRel ) && rad2deg( betaRel ) <= -20
      c_l = -1.14592 * betaRel -1.00000                                                 ;
  elseif rad2deg( betaRel ) > 90 
      c_l = 0.1 ;
  elseif rad2deg( betaRel ) <= -25
      c_l = -0.75 ;
  end
end

function computeLiftPolyFitCoefs()
    % Code to compute polyfit coeficients
    % Angle between -8 and 8
    liftPoints = [ -0.5 0.25 0.9]               ;
    anglePoints = deg2rad([-8 0 8 ])            ;
    p1 = polyfit(anglePoints, liftPoints, 1 )   ;
    % Angle between 8 and 20
    liftPoints2 = [ 0.9 1 1.25]                 ;
    anglePoints2 = deg2rad([8 10 20 ])          ;
    p2 = polyfit(anglePoints2, liftPoints2, 2)  ;
    % Angle between 20 and 90
    liftPoints3 = [ 1.25 0.8 1.2 0.1 ]          ;
    anglePoints3 = deg2rad([20 30 50 90 ])      ;
    p3 = polyfit(anglePoints3, liftPoints3, 3 ) ;
    % Angle between -8 and -15
    liftPoints4 = [ -0.5 -0.45 -0.8 ]           ;
    anglePoints4 = deg2rad([-8 -10 -15 ])       ;
    p4 = polyfit(anglePoints4, liftPoints4, 2 ) ;
    % Angle between -15 and -20
    liftPoints5 = [ -0.8 -0.6 ]                 ;
    anglePoints5 = deg2rad([-15 -20 ])          ;
    p5 = polyfit(anglePoints5, liftPoints5, 1 ) ;
    % Angle between -20 and -25
    liftPoints6 = [ -0.6 -0.5 ]                 ;
    anglePoints6 = deg2rad([-20 -25 ])          ;
    p6 = polyfit(anglePoints6, liftPoints6, 1 ) ;
end