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

function c_m = momentCoefS809(betaRel, Re)
  if -20 <= rad2deg( betaRel ) && rad2deg( betaRel ) <= -14 
      c_m = -0.9072 * betaRel + -0.2317 ;
  elseif -14 < rad2deg( betaRel ) && rad2deg( betaRel ) <= 15
      c_m = -0.019757 * betaRel -0.014828;
  elseif 15 <rad2deg( betaRel ) && rad2deg( betaRel ) < 40
      c_m = -0.7105 * betaRel  + 0.1660 ;
  elseif rad2deg( betaRel ) >= 20
      c_m = -0.33 ;
  elseif rad2deg( betaRel ) < -13
      c_m = 0.085 ;
  end
end

function computeMomentCoefs()
    % Code to compute polyfit coeficients
    momentPoints = [ 0.085 -0.01 ]              ;
    anglePoints = deg2rad([-20 -14  ])          ;
    p1 = polyfit(anglePoints, momentPoints, 1 ) ;

    momentPoints2 = [ momentPoints(2) -0.02 ]    ;
    anglePoints2 = deg2rad([-14 15 ]) ;
    p2 = polyfit(anglePoints2, momentPoints2, 1) ;

    momentPoints3 = [ momentPoints2(2) -0.33 ]    ;
    anglePoints3 = deg2rad([15 40 ]) ;
    p3 = polyfit(anglePoints3, momentPoints3, 1 ) ;
end