% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------
% Reconfiguration large displacements cylindrical cantilever beam example
%-----------------------------------------------------
function [conecCell nodesCoords ] = createMesh(numElements, l)
    %mdThe coordinates of the mesh nodes are given by the matrix:
    nodesCoords = [ (0:(numElements))' * l / numElements  zeros(numElements+1,2) ];
    %mdThe connectivity is introduced using the _conecCell_. Each entry of the cell contains a vector with the four indexes of the MEBI parameters, followed by the indexes of nodes that compose the element (node connectivity). For didactical purposes each element entry is commented. First the cell is initialized:
    conecCell = { } ;
    %md then the first welded node is defined with material (M) zero since nodes don't have material, the first element (E) type (the first entry of the `elements` struct), and (B) is the first entry of the the `boundaryConds` struct. For (I) no non-homogeneous initial condition is considered (then zero is used) and finally the node is assigned:
    conecCell{ 1, 1 } = [ 0 1 1 0  1] ;
    %md Next the frame elements MEBI parameters are set. The frame material is the first material of `materials` struct, then $1$ is assigned. The second entry of the `elements` struct correspond to the frame element employed, so $2$ is set. Finally no BC and no IC is required for this element, then $0$ is used.  Consecutive nodes build the element so then the `mesh.conecCell` is:
    for i=1:numElements,
        conecCell{ i+1,1 } = [ 1 2 0 0  i i+1 ] ;
    end
end