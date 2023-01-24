% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------
% Blade cantilever beam
%-----------------------------------------------------
function windVel = windVel3DStatic(x,t)
  finalTime = 30 ;
  vwindMax  = 30 ;
  thetaMin =  0  ;
  thetaMax  = 40 ;
  deltaT = 1 ;
  thetaVel  = deg2rad((t - deltaT) / finalTime * (thetaMax - thetaMin ) + thetaMin) ;
  windy =  vwindMax * cos( thetaVel ) ;
  windz = - vwindMax * sin( thetaVel ) ;
  windVel = [ 0 windy windz ]' ; %Must be a column vector
end