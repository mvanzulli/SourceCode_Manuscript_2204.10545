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

function c_d = dragCoefS809(betaRel, Re)
  if rad2deg( betaRel ) > 20 && abs(rad2deg( betaRel ) <= 90)
      c_d = -1.9697 * betaRel ^ 2 + 5.5004 * betaRel -1.5800 ;
  elseif 8 < rad2deg( betaRel ) && rad2deg( betaRel ) <= 20
      c_d = 0.8207016 * betaRel ^ 2 + 0.0286479 * betaRel + -0.01 ;
  elseif abs(rad2deg( betaRel ) ) <= 8 
      c_d = 0.01 ;
  elseif -15 <=rad2deg( betaRel ) && rad2deg( betaRel ) < -8
      c_d = -0.736660 * betaRel + -0.092857 ;
  elseif -17.5 <=rad2deg( betaRel ) && rad2deg( betaRel ) < -15
      c_d = -4.5837 * betaRel - 1.1000 ;
  elseif -25 <=rad2deg( betaRel ) && rad2deg( betaRel ) < -17.5
      c_d = -0.763944 * betaRel + 0.066667 ;
  elseif rad2deg( betaRel ) > 90
      c_d = 0.5 ;
  elseif rad2deg( betaRel ) < -25
      c_d = 0.5 ;
  else
  end
end

function computeDragPolyFitCoefs()
    % Code to compute polyfit coeficients
    % Angle between 20 and 90
    dragPoints1 = [ .1 2.2 2.2 ]                ;
    anglePoints1 = deg2rad([20 70 90])          ;
    p1 = polyfit(anglePoints1, dragPoints1, 2 ) ;

    % Angle between 8 and 20
    dragPoints2 = [ .01 .02 .1 ]                ;
    anglePoints2 = deg2rad([8 10 20])           ;
    p2 = polyfit(anglePoints2, dragPoints2, 2 ) ;

    % Angle between -15 and -8
    dragPoints3 = [ .01 0.1 ]                  ;
    anglePoints3 = deg2rad([-8 -15])           ;
    p3 = polyfit(anglePoints3, dragPoints3, 1 );

    % Angle between -17.5 and -15
    dragPoints4 = [ 0.1 0.3 ]                  ;
    anglePoints4 = deg2rad([-15 -17.5])        ;
    p4 = polyfit(anglePoints4, dragPoints4, 1 );

    % Angle between -25 and -17.5
    dragPoints5 = [ 0.3 0.4]                   ;
    anglePoints5 = deg2rad([-17.5 -25])        ;
    p5 = polyfit(anglePoints5, dragPoints5, 1 );
end