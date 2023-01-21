% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%---------------------------
% Blade cantilever beam
%---------------------------
% clear all
clear all, close all
% add utils
Utils_path = "./../Utils"
addpath(genpath(Utils_path));
% add ONSAS_path
ONSAS_path = addONSAS()
addpath(genpath(ONSAS_path));
%
% General  problem parameters
%----------------------------
%
% S809 airfoil properties
%----------------------------
% add S809 folder
S809_folder = "./../S809airfoil/" ;
addpath(genpath(S809_folder))     ;
% extract properties
S809props = secMatAeroPropsS809() ;
% blade length 
l = 10 ;
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
elements(1).elemType                = 'node'                                                       ;
elements(2).elemType                = 'frame'                                                      ;
elements(2).elemCrossSecParams{1,1} = 'generic'                                                    ;
elements(2).elemCrossSecParams{2,1} = [S809props.A S809props.J S809props.Iyy S809props.Izz, ...
                                       S809props.Irho(1,1) S809props.Irho(2,2) S809props.Irho(3,3)];
elements(2).massMatType             = 'consistent'                                                 ;
numGaussPoints                      = 4                                                            ;
stinfessAeroMatrix                  = false                                                        ;
elements(2).elemTypeAero            = [0 S809props.dch 0 numGaussPoints stinfessAeroMatrix]        ;
elements(2).aeroCoefs               = {S809props.dragFunc; S809props.liftFunc; S809props.momFunc } ;
%
% boundaryConds
%----------------------------
boundaryConds(1).imposDispDofs = [1 2 3 4 5 6] ;
boundaryConds(1).imposDispVals = [0 0 0 0 0 0] ;
%
% initial Conditions
%----------------------------
initialConds = struct() ;
%
% analysisSettings
%----------------------------
analysisSettings.stopTolDeltau = 1e-12 ;
analysisSettings.stopTolForces = 5e-7  ;
analysisSettings.stopTolIts    = 1000  ;
%-------------------------------------
% Static 3D large case
% -------------------------------------
numElements3D = 10 ;
%
% mesh parameters
%----------------------------
mesh.nodesCoords = [(0:(numElements3D))'*l/numElements3D  zeros(numElements3D+1,2)] ;
mesh.conecCell = { } ;
mesh.conecCell{ 1, 1 } = [0 1 1 0  1] ;
for i=1:numElements3D
  conecElemMatrix(i,:)    = [1 2 0 0  i i+1] ;
  mesh.conecCell{ i+1,1 } = [1 2 0 0  i i+1] ;
end
%
% analysisSettings
%----------------------------
analysisSettings.methodName             = 'newtonRaphson'                          ;
analysisSettings.finalTime              =   30                                     ;%the final time must be chaned in windVel3DStatic
analysisSettings.deltaT                 =   1                                      ;
analysisSettings.fluidProps             = {fluid.rho; fluid.nu; 'windVel3DStatic'} ;
analysisSettings.booleanSelfWeight      = false                                    ;
analysisSettings.geometricNonLinearAero = true                                     ;
%
% otherParams
%----------------------------
otherParams.problemName = strcat('onsasExample_nonLinearCantileverBlade_staitc3D_pitch',...
                                 ' numElements= ', num2str(numElements3D)) ;
otherParams.plots_format = 'vtk' ;
% Variable to store root forces
%----------------------------
global globalReactionForces
globalReactionForces = zeros(6*analysisSettings.finalTime, 1) ;
% 
% node to compute raction forces 
global glboalNodeReactionForces
glboalNodeReactionForces = 1 ;
%
% Execute ONSAS considering the pitch moment
%----------------------------
[matUs3DStaticPitch, ~] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ;
% copy the global variable 
globalReactionForcesPitch = globalReactionForces ;
%
% Delete teh pitch moment
elements(2).aeroCoefs      = {'dragCoefS809'; 'liftCoefS809'; [] } ;
%
% otherParams
%----------------------------
otherParams.problemName = strcat('onsasExample_nonLinearCantileverBlade_staitc3D_no_pitch',...
                                 ' numElements= ', num2str(numElements3D)) ;

% Zero out globalReactionForces
globalReactionForces = zeros(6*analysisSettings.finalTime, 1) ;
% Execute ONSAS considering the pitch moment
%----------------------------
[matUs3DStaticNoPitch, ~] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ;
% copy the global variable 
globalReactionForcesNoPitch = globalReactionForces ;
%
% Export results
%----------------------------
matFolderPath = 'output/mat' ; 
mkdir(matFolderPath)
cd(matFolderPath)
save(strcat('onsasExample_nonLinearCantileverBlade_static_3D', '.mat'))
cd('./../../')
