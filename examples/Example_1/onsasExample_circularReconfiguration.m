% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and open-source implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------
% Circular reconfiguration example
%-----------------------------------------------------
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
[l, d, Izz, E, nu, rhoS, rhoF, nuF, dragCoefFunction, NR,...
 cycd_vec, fluid_vel_vec, t_c, index_case_1, index_case_2] = loadParamtetersCirc();
%
% materials
%----------------------------
materials.hyperElasModel  = '1DrotEngStrain' ;
materials.hyperElasParams = [E nu]           ;
materials.density         = rhoS             ;
%
% elements
%----------------------------
elements(1).elemType                = 'node'   ;
elements(2).elemType                = 'frame'  ;
elements(2).elemCrossSecParams{1,1} = 'circle' ;
elements(2).elemCrossSecParams{2,1} = [d]      ;
numGaussPoints = 4 ;
elements(2).aeroCoefs = {dragCoefFunction; []; []} ;
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
% analysisSettings Static
%----------------------------
analysisSettings.fluidProps             = {rhoF; nuF; 'windVelCircStatic'} ;
analysisSettings.geometricNonLinearAero = true                             ;
analysisSettings.deltaT                 = 1                                ; % needs to be 1
stepUntilConvergence                    = 4                                ; % step until no tangent case converges  
analysisSettings.finalTime              = stepUntilConvergence             ;
analysisSettings.methodName             = 'newtonRaphson'                  ;
analysisSettings.stopTolDeltau          =  0                               ;
analysisSettings.stopTolForces          =  1e-8                            ;
analysisSettings.stopTolIts             =  30                              ;
%
% otherParams
%----------------------------
otherParams.problemName  = 'staticReconfigurationCircle' ;
otherParams.plots_format = ''                            ; 
%----------------------------
% Static case 
%----------------------------
%
% run case for different number of elements
nelemCasesStatic = [2:2:20] ;
% 
% node to compute raction forces 
global glboalNodeReactionForces
glboalNodeReactionForces = 1 ;
%
% With stiff tangent matrix until cycd = 10^5 (F3)
%---------------------------------------
%
% elements
%----------------------------
aeroStiffMatrix                 = true ;
elements(2).elemTypeAero        = [0 d 0 numGaussPoints aeroStiffMatrix] ;
dragForcesTangent102            = {};
matUsTangent102                 = {};
executionTimeTangent102         = {};
iterationsAtEachStepTangent102  = {};
%
% Declare a global variable to store drag 
%
% drag dof
dofY = 3 ;
%
% run case for different number of elements
for elemCase = 1:length(nelemCasesStatic)
  % declare a global variable to store drag force  
  global globalReactionForces
  globalReactionForces = zeros(6 * analysisSettings.finalTime, 1) ;
  % declare a global variable to store number of iterations  
  global globalNIter
  globalNIter = zeros(analysisSettings.finalTime + 1, 1) ;
  % select element case
  numElementsCase = nelemCasesStatic(elemCase) ;
  %
  % mesh parameters
  %----------------------------
  [mesh.conecCell, mesh.nodesCoords] = createMesh(numElementsCase, l) ;
  %
  % otherParams
  %----------------------------
  otherParams.problemName = strcat('onsasExample_reconfigStatic_aeroStiff=',...
                                    num2str(elements(2).elemTypeAero(5)) ,...
                                    '_numElem= ',  num2str(numElementsCase)) ;                                 
  %
  % Execute ONSAS
  % ----------------------------
  % measure execution time 
  tic
  % run ONSAS
  [matUs] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
  % save execution time
  execTime = toc ;
  executionTimeTangent102{elemCase,1} = execTime ; 
  % fill into matUsCell
  matUsTangent102{elemCase,1} = matUs;
  % fill into FDrag cell and clean it
  dragForcesTangent102{elemCase,1}           = globalReactionForces(dofY:6:end) ; %
  iterationsAtEachStepTangent102{elemCase,1} = globalNIter(3:end) ;
  % clear global variables
  clear globalReactionForces, globalNIter ;
end 
%
% Without stiff tangent matrix case (F1 or F2)
%----------------------------
aeroStiffMatrix = false ;
%
% elements
%----------------------------
elements(2).elemTypeAero   = [0 d 0 numGaussPoints aeroStiffMatrix] ;
% Initialize cells to save mass matrix and matUS 
dragForcesNoTangent            = {};
matUsNoTangent                 = {};
executionTimeNoTangent         = {};
iterationsAtEachStepNoTangent  = {};
%
% run case for different number of elements
for elemCase = 1:length(nelemCasesStatic)
  % declare a global variable to store drag force  
  global globalReactionForces
  globalReactionForces = zeros(6 * analysisSettings.finalTime, 1) ;
  dragForces = zeros(analysisSettings.finalTime, 1) ;
  % declare a global variable to store number of iterations  
  global globalNIter ;
  globalNIter = zeros(analysisSettings.finalTime + 1, 1) ;
  % select element case
  numElementsCase = nelemCasesStatic(elemCase) ;
  %
  % mesh parameters
  %----------------------------
  [mesh.conecCell, mesh.nodesCoords] = createMesh(numElementsCase, l) ;
  %
  % otherParams
  %----------------------------
  otherParams.problemName = strcat('onsasExample_reconfigStatic_aeroStiff=',...
                                    num2str(elements(2).elemTypeAero(5)) ,...
                                    '_numElem= ',  num2str(numElementsCase)) ;
                                    %
  %
  % Execute ONSAS
  % ----------------------------
  % measure execution time 
  tic
  % run ONSAS
  [matUs] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
  % save execution time
  execTime = toc ;
  executionTimeNoTangent{elemCase, 1} = execTime ; 
  % fill into matUsCell
  matUsNoTangent{elemCase,1} = matUs;
  % store drag forces
  dragForces = globalReactionForces(dofY:6:end) ;
  % add a Nan in iterations with no convergence 
  dragForces(globalNIter(3:end) == analysisSettings.stopTolIts) = nan ; 
  globalNIter(globalNIter(3:end) == analysisSettings.stopTolIts) = nan ;
  % fill into FDrag cell and clean it
  dragForcesNoTangent{elemCase,1}           = dragForces;
  iterationsAtEachStepNoTangent{elemCase,1} = globalNIter(3:end);
  % clear global variables
  clear globalReactionForces, globalNIter ;
end
%
% Select a new final time cycd = 10^5 (F3)
%--------------------------------------
analysisSettings.finalTime = 10 ;
%
% with stiff tangent matrix case 
%----------------------------
aeroStiffMatrix = true ;
%
% elements
%----------------------------
elements(2).elemTypeAero     = [0 d 0 numGaussPoints aeroStiffMatrix] ;
% Initialize cells to save mass matrix and matUS 
dragForcesTangent            = {};
matUsTangent                 = {};
executionTimeTangent         = {};
iterationsAtEachStepTangent  = {};
%
% run case for different number of elements
for elemCase = 1:length(nelemCasesStatic)
  % declare a global variable to store drag force  
  global globalReactionForces
  globalReactionForces = zeros(6 * analysisSettings.finalTime, 1) ;
  dragForces = zeros(analysisSettings.finalTime, 1) ;
  % declare a global variable to store number of iterations  
  global globalNIter ;
  globalNIter = zeros(analysisSettings.finalTime + 1, 1) ;
  % select element case
  numElementsCase = nelemCasesStatic(elemCase) ;
  %
  % mesh parameters
  %----------------------------
  [mesh.conecCell, mesh.nodesCoords] = createMesh(numElementsCase, l) ;
  %
  %
  % otherParams
  %----------------------------
  otherParams.problemName = strcat('onsasExample_reconfigStatic_aeroStiff=',...
                                    num2str(elements(2).elemTypeAero(5)) ,...
                                    '_numElem= ',  num2str(numElementsCase)) ;
                                    %
  %
  % Execute ONSAS
  % ----------------------------
  % measure execution time 
  tic
  % run ONSAS
  [matUs] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
  % save execution time
  execTime = toc ;
  executionTimeTangent{elemCase, 1} = execTime ; 
  % fill into matUsCell
  matUsTangent{elemCase,1} = matUs;
  % store drag forces
  dragForces = globalReactionForces(dofY:6:end) ;
  % add a Nan in iterations with no convergence 
  dragForces(globalNIter(3:end) == analysisSettings.stopTolIts) = nan ; 
  globalNIter(globalNIter(3:end) == analysisSettings.stopTolIts) = nan ;
  % fill into FDrag cell and clean it
  dragForcesTangent{elemCase,1}           = dragForces;
  iterationsAtEachStepTangent{elemCase,1} = globalNIter(3:end);
  % clear global variables
  clear globalReactionForces, globalNIter ;
end
%
% Export results
%----------------------------
matFolderPath = './output/mat' ; 
mkdir(matFolderPath)
cd(matFolderPath)
save(strcat('onsasExample_reconfigurationBeam_static', '.mat'))
cd('./../../')
%-----------------------------------------------
% Dynamic case changing the number of elements 
%------------------------------------------------
%
% cycd for this case is 
CyCdDynamicNelemAnalysis = cycd_vec(end - 2) ;
%
% run case for different number of elements
nelemCasesDynamic = [4 20] ; 
%
% run for different cy* numbers 
windVelCases = ['windVelCircDynamicCase1'; 'windVelCircDynamicCase2'] ; 
%
% analysisSettings
% -------------------------------------
analysisSettings.finalTime     =   13                                       ;
analysisSettings.deltaT        =   0.05                                     ;
numTimeSteps  = round(analysisSettings.finalTime / analysisSettings.deltaT) ;
analysisSettings.methodName    = 'newmark'                                  ;
analysisSettings.stopTolDeltau =   1e-10                                    ;
analysisSettings.stopTolForces =   1e-4                                     ;
analysisSettings.stopTolIts    =   15                                       ;
%-----------------------------------------
% Without stiff tangent matrix case lumped (F1)
%----------------------------------------
aeroStiffMatrix = false ;
%
% elements
%----------------------------
% the lumped mass matrix is considered for this case
elements(2).massMatType  = 'lumped'                               ;
elements(2).elemTypeAero = [0 d 0 numGaussPoints aeroStiffMatrix] ;
% Initialize cells to save results 
matUsNoTangentDynLumped                = {};
%
%run for different wind vel cases
for windVelCase = 1:size(windVelCases, 1)
  %
  % analysisSettings Dynamic
  %----------------------------
  analysisSettings.fluidProps = {rhoF; nuF; windVelCases(windVelCase,:)} ;
  % change the number of elements
  for elemCase = 1: length(nelemCasesDynamic)
    % select element case
    numElementsCase = nelemCasesDynamic(elemCase) ;
    %
    % mesh parameters
    %----------------------------
    [mesh.conecCell, mesh.nodesCoords] = createMesh(numElementsCase, l) ;
    %
    %
    % otherParams
    %----------------------------
    otherParams.problemName = strcat('onsasExample_reconfigDynamic_aeroStiff=',...
                                      num2str(elements(2).elemTypeAero(5)) ,...
                                      '_numElem= ',  num2str(numElementsCase),...
                                      '_consistent=',...
                                      num2str(strcmp(elements(2).massMatType, 'consistent')),...
                                     '_windVelCase=', num2str(windVelCase)) ;
    %
    % Execute ONSAS
    % ----------------------------
    % measure execution time 
    tic
    % run ONSAS
    [matUs] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
    % save execution time
    % fill into matUsCell
    matUsNoTangentDynLumped{elemCase, windVelCase} = matUs;
  end % end for elemCase

end % end for wind vel case
%-------------------------------------------------
% Withot stiff tangent matrix case consistent (F2)
%--------------------------------------------------
aeroStiffMatrix    = false ;
%
% elements
%----------------------------
% the consistent mass matrix is considered for this  case
elements(2).massMatType  = 'consistent'                           ;
elements(2).elemTypeAero = [0 d 0 numGaussPoints aeroStiffMatrix] ;
% Initialize cells to save results
matUsNoTangentDynConsistent = {} ;
%
%run for different wind vel cases
for windVelCase = 1:size(windVelCases, 1)
  %
  % analysisSettings Dynamic
  %----------------------------
  analysisSettings.fluidProps = {rhoF; nuF; windVelCases(windVelCase,:)} ;
  % change the number of elements
  for elemCase = 1:length(nelemCasesDynamic)
    % select element case
    numElementsCase = nelemCasesDynamic(elemCase) ;
    %
    % mesh parameters
    %----------------------------
    [mesh.conecCell, mesh.nodesCoords] = createMesh(numElementsCase, l) ;
    %
    %
    % otherParams
    %----------------------------
    otherParams.problemName = strcat('onsasExample_reconfigDynamic_aeroStiff=',...
                                      num2str(elements(2).elemTypeAero(5)) ,...
                                      '_numElem= ',  num2str(numElementsCase),...
                                      '_consistent=',...
                                      num2str(strcmp(elements(2).massMatType, 'consistent')),...
                                    '_windVelCase=', num2str(windVelCase)) ;
    %
    % Execute ONSAS
    % ----------------------------
    % measure execution time 
    tic
    % run ONSAS
    [matUs] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
    % fill into matUsCell
    matUsNoTangentDynConsistent{elemCase, windVelCase} = matUs;
  end % end for elemCase

end % end for wind vel case
%------------------------------------------
% With stiff tangent matrix case consistent (F3)
%------------------------------------------
%
aeroStiffMatrix = true ;
%
% elements
%----------------------------
% the consistent mass matrix is considered for this case
elements(2).massMatType  = 'consistent'                           ;
elements(2).elemTypeAero = [0 d 0 numGaussPoints aeroStiffMatrix] ;
% Initialize cells to save mass matrix and matUS 
matUsTangentDynConsistent = {};
%
%run for different wind vel cases
for windVelCase = 1:size(windVelCases, 1)
  %
  % analysisSettings Dynamic
  %----------------------------
  analysisSettings.fluidProps = {rhoF; nuF; windVelCases(windVelCase,:)} ;
  % change the number of elements
  for elemCase = 1:length(nelemCasesDynamic)
    % select element case
    numElementsCase = nelemCasesDynamic(elemCase) ;
    %
    % mesh parameters
    %----------------------------
    [mesh.conecCell, mesh.nodesCoords] = createMesh(numElementsCase, l) ;
    %
    %
    % otherParams
    %----------------------------
    otherParams.problemName = strcat('onsasExample_reconfigDynamic_aeroStiff=',...
                                      num2str(elements(2).elemTypeAero(5)) ,...
                                      '_numElem= ',  num2str(numElementsCase),...
                                      '_consistent=',...
                                      num2str(strcmp(elements(2).massMatType, 'consistent')),...
                                    '_windVelCase=', num2str(windVelCase)) ;
    %
    % Execute ONSAS
    % ----------------------------
    % measure execution time 
    tic
    % run ONSAS
    [matUs] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ; 
    % fill into matUsCell
    matUsTangentDynConsistent{elemCase, windVelCase} = matUs;
  end % end for elemCase

end % end for wind vel case
%
% Export results
%----------------------------
matFolderPath = './output/mat' ; 
mkdir(matFolderPath)
cd(matFolderPath)
save(strcat('onsasExample_reconfigurationBeam_dynamic', '.mat'))
cd('./../../')
%---------------------------------------------
% Gauss integration points analysis with (F2)
% --------------------------------------------
% select final time
analysisSettings.finalTime = 7 ;
% select the number of elements
numElementsCase = 10 ;
% mesh parameters
%----------------------------
[mesh.conecCell, mesh.nodesCoords] = createMesh(numElementsCase, l) ;
%
stinfessAeroMatrix = false ;
%
% the consistent mass matrix is considered for this case
elements(2).massMatType  = 'consistent'                           ;
elements(2).elemTypeAero = [0 d 0 numGaussPoints aeroStiffMatrix] ;
%
% Select case with cycd 10^4
windVelCase = windVelCases(1,:) ; 
%
% analysisSettings Dynamic
%----------------------------
analysisSettings.fluidProps = {rhoF; nuF; windVelCase} ;
% maximum number of Gauss points for the most refined
numGaussMax = 10 ;
% sotre matUs
matUsGaussConsistent = {} ;
% execution time to fill
executionTimesConsistent = [] ;
% run for cases
numElementsGaussCases = [1:numGaussMax] ;
for gaussCase = numElementsGaussCases
  %
  % elements
  %----------------------------
  % fill the number of gauss points
  elements(2).elemTypeAero   = [0 d 0 gaussCase stinfessAeroMatrix] ;
  %
  % otherParams
  %----------------------------
  otherParams.problemName = strcat('onsasExample_reconfigDynamic_',...
                                    ' numElements= ', num2str(numElementsCase),...
                                     '_GaussPoints= ', num2str(gaussCase)) ;
  %
  % Execute ONSAS
  %----------------------------
  tic
  [matUs3DDynamicGaussCase, ~] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ;
  executionTimesConsistent = [executionTimesConsistent, toc] ;
  % save into Gauss case
  matUsGaussConsistent{gaussCase,1} = matUs3DDynamicGaussCase ; 
end
%---------------------------------------------
% Gauss integration points analysis with (F1)
% --------------------------------------------
% sotre matUs
matUsGaussLumped = {} ;
% execution time to fill
executionTimesLumped = [] ;
%
elements(2).massMatType  = 'lumped' ;
%
for gaussCase = numElementsGaussCases
  %
  % elements
  %----------------------------
  % fill the number of gauss points
  elements(2).elemTypeAero   = [0 d 0 gaussCase stinfessAeroMatrix] ;
  %
  % otherParams
  %----------------------------
  otherParams.problemName = strcat('onsasExample_reconfigDynamic_',...
                                    ' numElements= ', num2str(numElementsCase), '_GaussPoints= ',...
                                    num2str(gaussCase)) ;
  %
  % Execute ONSAS
  %----------------------------
  tic
  [matUs3DDynamicGaussCase, ~] = ONSAS(materials, elements, boundaryConds, initialConds, mesh, analysisSettings, otherParams) ;
  executionTimesLumped = [executionTimesLumped, toc] ;
  % save into Gauss case
  matUsGaussLumped{gaussCase,1} = matUs3DDynamicGaussCase ; 
end
%
% Export results
%----------------------------
matFolderPath = './output/mat' ; 
mkdir(matFolderPath)
cd(matFolderPath)
save(strcat('onsasExample_reconfigurationBeam_gauss', '.mat'))
cd('./../../')
