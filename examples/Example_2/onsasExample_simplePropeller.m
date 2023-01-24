% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%--------------------------
% Simple propeller example
%--------------------------
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
% material scalar parameters
Er = 210e9 ;  nu = 0.3 ; rho = 6000 ; G = Er / (2 * (1+nu)) ;
% geometrical scalar parameters
l = 3 ; d = 0.1;  A = pi * d^2 / 4 ;
% fluid properties 
air = fluidProps("air")
%
% materials
%----------------------------
% Since the example contains only one material and co-rotational strain element so then `materials` struct is 
materials.hyperElasModel  = '1DrotEngStrain' ;
materials.hyperElasParams = [Er nu]          ;
materials.density         = rho              ;
%
% elements
%----------------------------
% nodes
elements(1).elemType = 'node'  ;
% aero parameters
numGaussPoints  = 4            ;
% first blade aligned with -z global axis
elements(2).elemType                = 'frame'                                   ;
elements(2).elemCrossSecParams{1,1} = 'circle'                                  ;
elements(2).elemCrossSecParams{2,1} = d                                         ;
elements(2).massMatType             = 'consistent'                              ;
stiffnesAeroMatrix                  = false                                     ;
elements(2).elemTypeAero            = [0 0 d numGaussPoints stiffnesAeroMatrix] ;
elements(2).userLiftCoef            = 'liftCoef'                                ;
elements(2).aeroCoefs               = {[] ; 'liftCoef'; []}                     ;

% second blade in (z,-y) quarter 
elements(3).elemType                = 'frame'                                   ;
elements(3).elemCrossSecParams{1,1} = 'circle'                                  ;
elements(3).elemCrossSecParams{2,1} = d                                         ;
elements(3).massMatType             = 'consistent'                              ;
elements(3).elemTypeAero            = [0 d 0 numGaussPoints stiffnesAeroMatrix] ;
elements(3).aeroCoefs               = {[] ; 'liftCoef'; []}                     ;
% third blade in (z,y) quarter 
elements(4).elemType                = 'frame' ;
elements(4).elemCrossSecParams{1,1} = 'circle'                                  ;
elements(4).elemCrossSecParams{2,1} = d                                         ;
elements(4).massMatType             = 'consistent'                              ;
elements(4).elemTypeAero            = [0 d 0 numGaussPoints stiffnesAeroMatrix] ;
elements(4).aeroCoefs               = {[] ; 'liftCoef'; []}                     ;
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
analysisSettings.finalTime              = 450                          ;
analysisSettings.deltaT                 = 1                            ;
analysisSettings.methodName             = 'alphaHHT'                   ;
analysisSettings.stopTolIts             =   50                         ;
analysisSettings.geometricNonLinearAero = true                         ;
analysisSettings.booleanSelfWeight      = false                        ;
analysisSettings.stopTolDeltau          = 1e-12                        ;
analysisSettings.stopTolForces          = 1e-6                         ;
analysisSettings.stopTolIts             = 15                           ;
analysisSettings.fluidProps             = {air.rho; air.nu; 'windVel'} ;

%------------------------------------
% Rigid consistent mass matrix case
%------------------------------------
%
% Initialize cells to save mass matrix and computation times
matUsCellRigidConsistent       = {} ;
massMatrixCellsRigidConsistent = {} ;
executionTimesRigidConsistent  = [] ;
%
% run consistent case for different number of elements
nelemCasesConsistentRigid = [1 20] ;
for elemCase = 1 : length(nelemCasesConsistentRigid)
  % select element case
  numElementsBlade = nelemCasesConsistentRigid(elemCase) ;
  % number of elements consistent case
  %
  % mesh parameters
  %----------------------------
  [mesh.conecCell, conecMatrix, mesh.nodesCoords] = createPropellerMesh(numElementsBlade, l) ;
  %
  % add wind velocity into analysisSettings struct
  %----------------------------
  %plot first and last for a deformed figure
  if elemCase == 1 || elemCase == 2 || elemCase == length(nelemCasesConsistentRigid)
      otherParams.plots_format = 'vtk' ;
  else
      otherParams.plots_format = '' ;
  end
  otherParams.problemName = strcat('onsasExample_simplePropeller_rigid_consistent=',...
                                    num2str(strcmp('consistent',elements(2).massMatType)),...
                                    '_elemxBlade= ',  num2str(numElementsBlade)) ;
  %
  % Execute ONSAS
  % ----------------------------
  % measure execution time 
  tic
  % run ONSAS
  [matUs, ~] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
  % save execution time
  executionTimesRigidConsistent = [executionTimesRigidConsistent toc] ; 
  % fill into matUsCell
  matUsCellRigidConsistent{elemCase,1} = matUs;
end
%------------------------------------
% Rigid lumped mass matrix case
%------------------------------------
%
% Initialize cells to save mass matrix and computation times
matUsCellRigidLumped       = {} ;
massMatrixCellsRigidLumped = {} ;
executionTimesRigidLumped  = [] ;
%
%
% elements
%----------------------------
elements(2).massMatType = 'lumped' ;
elements(3).massMatType = 'lumped' ;
elements(4).massMatType = 'lumped' ;
% run lumpmed case for different number of elements
nelemCasesLumpedRigid = [1 5]  ;
for elemCase = 1 : length(nelemCasesLumpedRigid)
  % select element case
  numElementsBlade = nelemCasesLumpedRigid(elemCase) ;
  %----------------------------
  % otherParams
  %----------------------------
  %plot first and last for a deformed figure
  if elemCase == 1 || elemCase == 2 || elemCase == length(nelemCasesLumpedRigid)
      otherParams.plots_format = 'vtk' ;
  else
      otherParams.plots_format = '' ;
  end
  otherParams.problemName = strcat('onsasExample_simplePropeller_rigid_consistent=',...
                                    num2str(strcmp(elements(2).massMatType,'consistent')),...
                                    '_elemxBlade= ', num2str(numElementsBlade)) ;
  %
  % mesh parameters
  %----------------------------
  [mesh.conecCell, conecMatrix, mesh.nodesCoords] = createPropellerMesh(numElementsBlade, l) ;
  %
  % Execute ONSAS
  % ----------------------------
  % measure execution time 
  tic
  % run ONSAS
  [matUs, ~] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
  % save execution time
  executionTimesRigidLumped = [executionTimesRigidLumped toc] ; 
  % fill into matUsCell
  matUsCellRigidLumped{elemCase,1} = matUs;
end
%
% Export Rigid results
%----------------------------
mkdir('output/mat') ;
matFolderPath = 'output/mat/' ; 
save(strcat(matFolderPath, 'onsasExample_simplePropeller_rigid', '.mat'))
%
%----------------------------
% Flexible lumped case
%----------------------------
%
% Initialize cells to save mass matrix and computation times
matUsCellFlexLumped       = {} ;
massMatrixCellsFlexLumped = {} ;
executionTimesFlexLumped  = [] ;
%
% materials
%----------------------------
% Reduce the elasticity linear modulus
Ef = 2100 ;
materials.hyperElasParams = [Ef nu] ;
%
% analysisSettings
% -------------------------------------
deltaTLumpedFlex = 1 ;
analysisSettings.deltaT = deltaTLumpedFlex  ;
%
% run consistent case for different number of elements
nelemCasesLumpedFlex = [5 20] ;
for elemCase = 1 : length(nelemCasesLumpedFlex)
  % select element case
  numElementsBlade = nelemCasesLumpedFlex(elemCase) ;
  % number of elements Lumped case
  %
  % mesh parameters
  %----------------------------
  [mesh.conecCell, conecMatrix, mesh.nodesCoords] = createPropellerMesh(numElementsBlade, l) ;
  %
  % otherParams
  %----------------------------
  otherParams.problemName = strcat('onsasExample_simplePropeller_flex_consistent=',...
                                    num2str(strcmp(elements(2).massMatType,'consistent')),...
                                    '_elemxBlade= ',  num2str(numElementsBlade)) ;
  %plot first and last for a deformed figure
  if elemCase == 1 || elemCase == 2 || elemCase == length(nelemCasesLumpedRigid)
      otherParams.plots_format = 'vtk' ;
  else
      otherParams.plots_format = '' ;
  end  %
  % Execute ONSAS
  % ----------------------------
  % measure execution time 
  tic
  % run ONSAS
  [matUs, ~] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
  % save execution time
  executionTimesFlexLumped = [executionTimesFlexLumped toc] ; 
  % fill into matUsCell
  matUsCellFlexLumped{elemCase,1} = matUs ;
end
%----------------------------
% Flexible consistent case
%----------------------------
%
% Initialize cells to save mass matrix and computation times
matUsCellFlexConsistent       = {} ;
massMatrixCellsFlexConsistent = {} ;
executionTimesFlexConsistent  = [] ;
%
% elements
%----------------------------
elements(2).massMatType = 'consistent' ;
elements(3).massMatType = 'consistent' ;
elements(4).massMatType = 'consistent' ;
%
% run consistent case for different number of elements
nelemCasesConsistentFlex = [5 8 10 20] ;
for elemCase = 1 : length(nelemCasesConsistentFlex)
  % select element case
  numElementsBlade = nelemCasesConsistentFlex(elemCase) ;
  % number of elements Lumped case
  %
  % mesh parameters
  %----------------------------
  [mesh.conecCell, conecMatrix, mesh.nodesCoords] = createPropellerMesh(numElementsBlade, l) ;
  %
  % otherParams
  %----------------------------
  otherParams.problemName = strcat('onsasExample_simplePropeller_flex_consistent=',...
                                    num2str(strcmp(elements(2).massMatType,'consistent')),...
                                    '_elemxBlade= ',  num2str(numElementsBlade)) ;
  if elemCase == 1 || elemCase == 2 || elemCase == length(nelemCasesConsistentFlex)
      otherParams.plots_format = 'vtk' ;
  else
      otherParams.plots_format = '' ;
  end  %
  % Execute ONSAS
  % ----------------------------
  % measure execution time 
  tic
  % run ONSAS
  [matUs, ~] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
  % save execution time
  executionTimesFlexConsistent = [executionTimesFlexConsistent toc] ; 
  % fill into matUsCell
  matUsCellFlexConsistent{elemCase,1} = matUs ;
  %----------------------------
  % otherParams
  %----------------------------
  %plot first and last for a deformed figure
  if elemCase == 1 || elemCase == length(nelemCasesLumpedRigid)
      otherParams.plots_format = 'vtk' ;
  else
      otherParams.plots_format = '' ;
  end  
end
% Export results
%----------------------------
mkdir('output/mat')          ;
matFolderPath = 'output/mat/' ; 
save(strcat(matFolderPath, 'onsasExample_simplePropeller_flexible', '.mat'))
% Measurer total execution time
%----------------------------
elapsedtimeMinutes  = toc / 60 ;