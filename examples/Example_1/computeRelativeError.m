% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-------------------------------------------------------------------------
% Reconfiguration large displacements cylindrical cantilever beam example
%-------------------------------------------------------------------------
function relativeError = computeRelativeError(vecUCase, vecURef, L)
  % Define the deltau vector for each node
  deltaUVec = zeros(length(vecURef)/2,1) ;
  % Define the uref vector for each node
  uRefVec = zeros(length(vecURef)/2,1) ;
  % build xref vec
  xref = linspace( 0, L, length(vecURef) ) ;    
  % element reference length
  lelemRef = xref(2) - xref(1) ;
  % initilize the index of xref
  xrefIndex = 1 ;
  % Integrate the error formula
  for x = xref;
    % Compute the value of Ucase interpol
    uInterpolCase = interpolU(x, vecUCase, L ) ;
    % Compute the value of Uref interpol
    uInterpolRef = interpolU(x, vecURef, L ) ; 
    % Fill the value into deltaU
    if norm(uInterpolRef) == 0 && norm(uInterpolCase) == 0
      deltaUVec(xrefIndex) = 0 ;
      uRefVec(xrefIndex) = 0 ;
    else
      deltaUVec(xrefIndex) = norm( uInterpolCase - uInterpolRef )   ;
      uRefVec(xrefIndex) = norm( uInterpolRef )   ;
    end
    % Increase the index
    xrefIndex = xrefIndex + 1 ;
  end
  % Compute the integral of delta u vec
  interDeltaU = 0 ;
  for elem = 1: length(deltaUVec) - 1
    interDeltaU = interDeltaU + ( deltaUVec( elem + 1 ) + deltaUVec( elem ) ) / 2 *lelemRef  ;
  end
   % Compute the integral of uref vec
  interUref = 0 ;
  for elem = 1: length(deltaUVec) - 1
    interUref = interUref + ( uRefVec( elem + 1 ) + uRefVec( elem ) ) / 2 *lelemRef  ;
  end

  % Final normalization for the size of the mesh
  relativeError = interDeltaU / interUref ;
  %----------------------------------------------------------------------
  % Function that computes the interpolation displacements inside the mesh
  function uInterpol = interpolU(x, vecU, L )
    % fix border case
    if x == L
      uInterpol = vecU(end-1:end) ;
    elseif 0 <= x && x <= L  
      % create vector of nodesCoords
      xVec = linspace( 0, L, length(vecU)/2 ) ;
      deltaX = xVec(2) - xVec(1)       ;     
      % find the closer lower value of x
      indexXm1 = floor(x / deltaX) + 1 ;
      Xm1 = xVec(indexXm1)             ;
      dofsXm1 = (indexXm1 - 1) * 2 + 1 : (indexXm1 - 1) * 2 + 2  ;
      uXm1 = vecU(dofsXm1)             ;

      % find the closer upper value of x
      indexXp1 = indexXm1 + 1 ;
      Xp1 = xVec(indexXp1)    ; 
      dofsXp1 = (indexXp1 - 1) * 2 + 1 : (indexXp1 - 1) * 2 + 2  ;
      uXp1 = vecU(dofsXp1)   ;
      %
      uInterpol = ( uXp1 * (x - Xm1) + uXm1 * (Xp1 - x) )  /  deltaX ;
    else
      error('x is out of bounds')
    end
  end  
end