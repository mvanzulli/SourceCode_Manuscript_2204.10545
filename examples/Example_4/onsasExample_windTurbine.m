% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%---------------------------------
% Simplified wind turbine example
%---------------------------------
% clear all
clear all, close all
% add utils
Utils_path = "./../Utils"
addpath(genpath(Utils_path));
% add ONSAS_path
ONSAS_path = addONSAS()
addpath(genpath(ONSAS_path));
%
% S809 airfoil properties
%----------------------------
% add S809 folder
S809_folder = "./../S809airfoil/" ;
addpath(genpath(S809_folder))     ;
% extract properties
S809props = secMatAeroPropsS809() ;
% blade length 
l    = 10             ;
A    = S809props.A    ;
Iyy  = S809props.Iyy  ;
Izz  = S809props.Izz  ;
J    = S809props.J    ;
Irho = S809props.Irho ;
dch  = S809props.dch  ;
%
% fluid properties
%----------------------------
Utils_folder = "./../Utils/"   ;
addpath(genpath(Utils_folder)) ;
fluid = fluidProps("air")      ;
%
% materials
%----------------------------
materials.hyperElasModel  = '1DrotEngStrain'           ;
materials.hyperElasParams = [S809props.E S809props.nu] ;
materials.density         = S809props.rho              ;
%
% elements
%----------------------------
% nodes
elements(1).elemType = 'node'  ;
% first blade aligned with -z global axis
numGaussPoints         = 4     ;
computeAeroStiffMatrix = false ;
elements(2).elemType                = 'frame'                                         ;
elements(2).elemCrossSecParams{1,1} = 'generic'                                       ;
elements(2).elemCrossSecParams{2,1} = [A J Iyy Izz Irho(1,1) Irho(2,2) Irho(3,3)]     ;
elements(2).massMatType             = 'consistent'                                    ;
elements(2).elemTypeAero            = [0 0 dch numGaussPoints computeAeroStiffMatrix] ;
elements(2).aeroCoefs               = {S809props.dragFunc; S809props.liftFunc; S809props.momFunc} ;

% second blade in (z,-y) quarter 
elements(3).elemType                = 'frame'                                          ;
elements(3).elemCrossSecParams{1,1} = 'generic'                                        ;
elements(3).elemCrossSecParams{2,1} = [A J Iyy Izz Irho(1,1) Irho(2,2) Irho(3,3)]      ;
elements(3).massMatType             = 'consistent'                                     ;
elements(3).elemTypeAero            = [0 -dch 0 numGaussPoints computeAeroStiffMatrix] ;
elements(3).aeroCoefs               = {S809props.dragFunc; S809props.liftFunc; S809props.momFunc} ;

% third blade in (z,y) quarter 
elements(4).elemType                = 'frame'                                          ;
elements(4).elemCrossSecParams{1,1} = 'generic'                                        ;
elements(4).elemCrossSecParams{2,1} = [A J Iyy Izz Irho(1,1) Irho(2,2) Irho(3,3)]      ;
elements(4).massMatType             = 'consistent'                                     ;
elements(4).elemTypeAero            = [0 dch 0 numGaussPoints computeAeroStiffMatrix]  ;
elements(4).aeroCoefs               = {S809props.dragFunc; S809props.liftFunc; S809props.momFunc} ;

%
% boundaryConds
%----------------------------
% The elements are submitted to two different BC settings. The first BC corresponds to a free angle in x condition 
boundaryConds(1).imposDispDofs = [1 3 4 5 6] ;
boundaryConds(1).imposDispVals = [0 0 0 0 0] ;
%
% initial Conditions
%----------------------------
% homogeneous initial conditions are considered, then an empty struct is set:
initialConds = struct() ;
%
% analysisSettings
% -------------------------------------
analysisSettings.finalTime              =   30      ;
analysisSettings.deltaT                 =   0.01    ;
analysisSettings.methodName             = 'alphaHHT';
analysisSettings.stopTolIts             =   50      ;
analysisSettings.geometricNonLinearAero = true      ;
analysisSettings.booleanSelfWeight      = false     ;
analysisSettings.stopTolDeltau          = 1e-10     ;
analysisSettings.stopTolForces          = 1e-5      ;
analysisSettings.stopTolIts             = 1000      ;
analysisSettings.fluidProps             = {fluid.rho; fluid.nu; 'windVel'} ;

%
% otherParams
%----------------------------
otherParams.plotsFormat = '' ;
%------------------------------------
% Consistent mass matrix case
%------------------------------------
%
% Initialize cells to save mass matrix and computation times
matUsCellConsistent       = {};
massMatrixCellsConsistent = {};
executionTimesConsistent  = [];
%
% define the number of elements per blade
numElementsBlade = 30 ;
%
% mesh parameters
%----------------------------
[mesh.conecCell, conecMatrix, mesh.nodesCoords] = createPropellerMesh(numElementsBlade, l) ;
%
% add wind velocity into analysisSettings struct
%----------------------------
analysisSettings.userWindVel = 'windVel' ;
%
% otherParams
%----------------------------
otherParams.problemName = strcat('onsasExample_windTurbine') ;
%
% Execute ONSAS
% ----------------------------
% measure execution time 
tic
% run ONSAS
[matUs, ~] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
% save execution time
executionTimesConsistent = [executionTimesConsistent toc] ; 
% fill into matUsCell
matUsCellConsistent{1,1} = matUs;
% end
%----------------------------
% Export results
%----------------------------
matFolderPath = 'output/mat/' ; 
save(strcat(matFolderPath, 'onsasExample_windTurbine ', '.mat'))