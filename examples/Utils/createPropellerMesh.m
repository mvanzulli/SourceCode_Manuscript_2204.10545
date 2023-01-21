% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------
% Simple propeller example
%-----------------------------------------------------
% Creates the propeller mesh
function [conecCell conecMatrix nodesCoords] = createPropellerMesh(numElementsBlade, l)
  % mesh coordinates
  localAxialBladeCords    = (0:(numElementsBlade))'*l/ numElementsBlade                                                              ;  
  nodesLocalBladeZ        = [zeros(numElementsBlade + 1, 1), sin(pi) * localAxialBladeCords, +cos(pi) * localAxialBladeCords]        ;
  nodesLocalBlade120      = [zeros(numElementsBlade + 1, 1), sin(pi/3) * localAxialBladeCords , +cos(pi/3) * localAxialBladeCords]   ;
  nodesLocalBlade120(1,:) = [] ;
  nodesLocalBlade240      = [zeros(numElementsBlade + 1, 1), sin(4*pi/3) * localAxialBladeCords, -cos(4*pi/3) * localAxialBladeCords];
  nodesLocalBlade240(1,:) = [] ;
  nodesCoords = [nodesLocalBladeZ;  nodesLocalBlade120; nodesLocalBlade240]                                                          ;
  % mesh conecCell
  conecCell = {}  ;
  conecMatrix = []; 
  % nodes
  conecCell{1, 1} = [0 1 1 0  1] ;
  % elements
  for i=1:numElementsBlade
    conecCell{i+ 1, 1} = [1 2 0 0  i i+ 1] ;
    conecMatrix(i, :)  = [1 2 0 0  i i+ 1] ; 
    if i == 1 
      conecCell{i + numElementsBlade + 1 , 1}     = [1 3 0 0  1     numElementsBlade + 1 + i]   ;
      conecCell{i + 2 * numElementsBlade + 1, 1}  = [1 4 0 0  1   2 * numElementsBlade + 1 + i] ;
      conecMatrix(i + numElementsBlade, :)        = conecCell{i + numElementsBlade + 1 , 1}     ; 
      conecMatrix(i + 2 * numElementsBlade, :)    = conecCell{i + 2 * numElementsBlade + 1, 1}  ; 
    elseif i > 1
      conecCell{i + numElementsBlade + 1 , 1}     = [1 3 0 0    numElementsBlade + i   numElementsBlade + i + 1]      ;
      conecCell{i + 2 * numElementsBlade + 1 , 1} = [1 4 0 0  2 * numElementsBlade + i 2 * numElementsBlade + i + 1]  ;
      conecMatrix(i + numElementsBlade, :)        = conecCell{i + numElementsBlade + 1 , 1}                           ; 
      conecMatrix(i + 2 * numElementsBlade, :)    = conecCell{i + 2 * numElementsBlade + 1 , 1}                       ; 
    end
  end
end