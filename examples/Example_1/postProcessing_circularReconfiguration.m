% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-------------------------------------------------------------------------
% Reconfiguration large displacements cylindrical cantilever beam example
%-------------------------------------------------------------------------
% clear variables
clear all, close all
%----------------------------
% Plot parameters
% add utils
Utils_path = "./../Utils/"      ;
addpath(genpath(Utils_path));
% load plot parameters
plotParams = plotParameters()   ;
lw = plotParams.lw ; ms = plotParams.ms ;
%----------------------------
% Load static results form mat folder 
%
% load .mat
outputMatFolder = "output/mat/" ; 
load(strcat(outputMatFolder, 'onsasExample_reconfigurationBeam_static', ".mat"))
%----------------------------
% Load static results form mat folder 
%
% load FrederickGosselin cy vs cd in resudrag variable 
% and results of deformed configurations
load('./Gosselin2010_data.mat', 'def', 'resudrag')
%-------------------------------------
% Extract static case relevant results
%-------------------------------------
% extract with Tangent values (F3)
dragForcesTangentElemCase1              =  dragForcesTangent{1,1}                         ;
iterationsAtEachStepTangentElemCase1    =  iterationsAtEachStepTangent{1,1}               ;
execTimeTangentElemCase1                =  executionTimeTangent{1,1}                      ;
matUsTangentElemCase1                   =  matUsTangent{1,1}                              ;
xrefElemCase1                           =  linspace(0, l, size(matUsTangentElemCase1,1)/6);
dragForcesTangentElemCase2              =  dragForcesTangent{end,1}                       ;
iterationsAtEachStepTangentElemCase2    =  iterationsAtEachStepTangent{end,1}             ;
execTimeTangentElemCase2                =  executionTimeTangent{end,1}                    ;
matUsTangentElemCase2                   =  matUsTangent{end,1}                            ;
xrefElemCase2                           =  linspace(0, l, size(matUsTangentElemCase2,1)/6);
% extract without Tangent values (F1 or F2)
dragForcesNoTangentElemCase1            =  dragForcesNoTangent{1,1}                       ;
iterationsAtEachStepNoTangentElemCase1  =  iterationsAtEachStepNoTangent{1,1}             ;
execTimeNoTangentElemCase1              =  executionTimeNoTangent{1,1}                    ;
matUsNoTangentElemCase1                 =  matUsNoTangent{1,1}                            ;
dragForcesNoTangentElemCase2            =  dragForcesNoTangent{end,1}                     ;
iterationsAtEachStepNoTangentElemCase2  =  iterationsAtEachStepNoTangent{end,1}           ;
execTimeNoTangentElemCase2              =  executionTimeNoTangent{end,1}                  ;
matUsNoTangentElemCase2                 =  matUsNoTangent{end,1}                          ;
%---------------------------------------------------------------
% Plot of Cy* vs R for static tangent and no tangent case
%---------------------------------------------------------------
%
% Compute Cy*Cd for each R value
[l, d, Izz, E, nu, rhoS, rhoF, nuF, dragCoefFunction, NR, cycd_vec, ...
 fluid_vel_vec, tc, index_case_1, index_case_2] = loadParamtetersCirc();
C_d = feval(dragCoefFunction, 0 , 0) ;
% extract number of load steps
numLoadSteps = size(matUsTangentElemCase1, 2)  ;
timeVec      = linspace(0, NR, numLoadSteps)     ;
timeVec102   = linspace(0, NR, numLoadSteps)     ;
% initialize DragRef and Cy vectors
Cy    = zeros(numLoadSteps-1, 1) ;
FDRef = zeros(numLoadSteps-1, 1) ;
for i = 1 : length(nelemCasesStatic) 
    R  = zeros(numLoadSteps-1, 1) ;
    % compute Cy*Cd value ar each step
    for windVelStep = 1:numLoadSteps - 1
        % Compute dimensionless magnitudes 
        windVel            = feval('windVelCircStatic', 0, timeVec(windVelStep + 1)) ;
        normWindVel        = norm(windVel)                                           ;
        dirWindVel         = windVel / normWindVel                                    ;
        Cy(windVelStep)    = 1/2 * rhoF * normWindVel^2 * (l)^3 *d / (E*Izz)          ;
        FDRef(windVelStep) = 1/2 * rhoF * normWindVel^2 * C_d * d * l                 ;
    end
end
% compute R values for each case
RTangentElemCase1   = dragForcesTangentElemCase1 ./ FDRef ;
RTangentElemCase2   = dragForcesTangentElemCase2 ./ FDRef ;
RNoTangentElemCase1 = dragForcesNoTangentElemCase1 ./ FDRef(1:stepUntilConvergence) ;
RNoTangentElemCase2 = dragForcesNoTangentElemCase2 ./ FDRef(1:stepUntilConvergence) ;
%-------------------------------------
% Plot R vs CyCd
%-------------------------------------
fig1 = figure(1) ;
hold on; grid on
% with Tangent results
% element case 1 
loglog(C_d*Cy, RTangentElemCase1,...
        'color', plotParams.F3colors(1,:), 'linewidth', lw, 'linestyle', '-',...
        'markersize', plotParams.F3ms(1,:), 'marker', plotParams.F3markers(1,:)) ;
% element case 2 
loglog(C_d*Cy, RTangentElemCase2,...
        'color', plotParams.F3colors(2,:), 'linewidth', lw, 'linestyle', '-',...
        'markersize', plotParams.F3ms(2,:), 'marker', plotParams.F3markers(2,:)) ;
% with no Tangent results
% element case 1 
loglog(C_d*Cy(1:stepUntilConvergence), RNoTangentElemCase1,...
        'color', plotParams.F2colors(1,:), 'linewidth', lw, 'linestyle', '-',...
        'markersize', plotParams.F2ms(1,:), 'marker', plotParams.F2markers(1,:)) ;
% element case 2 
loglog(C_d*Cy(1:stepUntilConvergence), RNoTangentElemCase2,...
        'color', plotParams.F1colors(1,:), 'linewidth', lw, 'linestyle', '-',...
        'markersize', plotParams.F1ms(1,:), 'marker', plotParams.F1markers(1,:)) ;
% Gosselin results
loglog(resudrag(:,1), resudrag(:,2),...
        'color', plotParams.colourRef(1,:), 'linewidth', lw, 'linestyle', '-',...
        'marker', plotParams.markersRef(1,:)) ;
% legend and labels
legendTangentCase1 = strcat('F3 (', num2str(nelemCasesStatic(1)), ' elements)')           ;
legendTangentCase2 = strcat('F3 (', num2str(nelemCasesStatic(end)), ' elements)')         ;
legendNoTangentCase1 = strcat('F1 or F2 (', num2str(nelemCasesStatic(1)), ' elements)')   ;
legendNoTangentCase2 = strcat('F1 or F2 (', num2str(nelemCasesStatic(end)), ' elements)') ;
legend(legendTangentCase1, legendTangentCase2, legendNoTangentCase1, legendNoTangentCase2, 'Reference solution')
labx=xlabel(' $c_yc_d$ '); laby=ylabel('$R$');
% set figure properties
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
namefig1 = strcat(plotParams.printPathExample, 'ex1CyR') ;
print(fig1, namefig1, '-depslatex');
set(labx, 'FontSize' , plotParams.labelAxisFontSize); set(laby, 'FontSize', plotParams.labelAxisFontSize) ;
set(legend, 'linewidth', plotParams.axislw, 'location', 'southwest') ;
close(1)
% print figure
%-------------------------------------
% Plot deformed configurations
%-------------------------------------
% Specific plot parameters
markerSizeIters = 8              ;
markerSizeDef   = 8              ;
incrMarkSize    = 4              ;
markerElemCase1 = 1              ;
markerElemCase2 = 10             ;
NRtoPlotF3      = [2 4 5 6 8 10] ;
NRtoPlotF1F2    = [2 4]          ;
% Plot figure 
fig2 = figure(2) ;
hold on; grid on
% The reference coordinates are 
xref = mesh.nodesCoords(:,1) ;
% Plot matUs with tangent (F3) element case 1 
uy = matUsTangentElemCase1(3:6:end, 1) ;
ux = matUsTangentElemCase1(1:6:end, 1) ;
xdef = xrefElemCase1' + ux             ;
% Markers first plots
%-------------------------------------
plot(xdef(end), uy(end),...
    'color', plotParams.F3colors(1,:), 'linewidth', lw, 'linestyle', 'none',...
    'markersize', markerSizeDef, 'marker', plotParams.F3markers(1,:)) ;
% Plot matUs with tangent (F3) element case 2 
ux = matUsTangentElemCase2(1:6:end, 1) ;
uy = matUsTangentElemCase2(3:6:end, 1) ;
xdef = xrefElemCase2' + ux             ;
plot(xdef(1:markerElemCase2:end), uy(1:markerElemCase2:end),...
    'color', plotParams.F3colors(2,:), 'linewidth', lw, 'linestyle', 'none',...
    'markersize', markerSizeDef + incrMarkSize, 'marker', plotParams.F3markers(2,:)) ;
% Plot matUs with no tangent (F1 or F2) element case 1 
ux   = matUsNoTangentElemCase1(1:6:end, 1) ;
uy   = matUsNoTangentElemCase1(3:6:end, 1) ;
xdef = xrefElemCase1' + ux                 ;    
plot(xdef(1:markerElemCase1:end), uy(1:markerElemCase1:end),...
    'color', plotParams.F2colors(1,:), 'linewidth', lw, 'linestyle', 'none',...
    'markersize', markerSizeDef + incrMarkSize, 'marker', plotParams.F2markers(1,:)) ;
% Plot matUs with no tangent (F1 or F2) element case 2 
ux = matUsNoTangentElemCase2(1:6:end, 1) ;
uy = matUsNoTangentElemCase2(3:6:end, 1) ;
xdef = xrefElemCase2' + ux             ;
plot(xdef(1:markerElemCase2:end), uy(1:markerElemCase2:end),...
    'color', plotParams.F1colors(1,:), 'linewidth', lw, 'linestyle', 'none',...
    'markersize', markerSizeDef - 2, 'marker', plotParams.F1markers(1,:)) ;
% Gosselin results
for cycd_index = NRtoPlotF3
    plot(def(1,:,cycd_index), -def(2,:,cycd_index),...
        'color', plotParams.colourRef(1,:), 'linewidth', lw, 'linestyle', '-',...
        'markersize', markerSizeDef, 'marker', plotParams.markersRef(1,:))
end
% Markers plots
%-------------------------------------
%
% Plot matUs with tangent element case 1 
for cycd_index = NRtoPlotF3
    uy = matUsTangentElemCase1(3:6:end, cycd_index + 1);
    ux = matUsTangentElemCase1(1:6:end, cycd_index + 1);
    xdef = xrefElemCase1' + ux                         ;
    plot(xdef(1:markerElemCase1:end), uy(1:markerElemCase1:end),...
        'color', plotParams.F3colors(1,:), 'linewidth', lw, 'linestyle', 'none',...
        'markersize', markerSizeDef, 'marker', plotParams.F3markers(1,:)) ;
end
%
% Plot matUs with tangent element case 2 
for cycd_index = NRtoPlotF3
    ux = matUsTangentElemCase2(1:6:end, cycd_index + 1);
    uy = matUsTangentElemCase2(3:6:end, cycd_index + 1);
    xdef = xrefElemCase2' + ux                          ;
    plot(xdef(1:markerElemCase2:end), uy(1:markerElemCase2:end),...
        'color', plotParams.F3colors(2,:), 'linewidth', lw, 'linestyle', 'none',...
        'markersize', markerSizeDef + incrMarkSize, 'marker', plotParams.F3markers(2,:)) ;
end
% 
% Find the index with nan entry 
nan_index_elemCase1       = find(isnan(iterationsAtEachStepNoTangentElemCase1) == 1) ;  
nan_index_elemCase2       = find(isnan(iterationsAtEachStepNoTangentElemCase2) == 1) ;
first_nan_index_elemCase1 = min(nan_index_elemCase1) + 1                             ;
first_nan_index_elemCase2 = min(nan_index_elemCase2) + 1                             ;
%
% Plot matUs with no tangent element case 1
for cycd_index = NRtoPlotF1F2
    ux   = matUsNoTangentElemCase1(1:6:end, cycd_index + 1);
    uy   = matUsNoTangentElemCase1(3:6:end, cycd_index + 1);
    xdef = xrefElemCase1' + ux                              ;
    plot(xdef(1:markerElemCase1:end), uy(1:markerElemCase1:end),...
        'color', plotParams.F2colors(1,:), 'linewidth', lw, 'linestyle', 'none',...
        'markersize', markerSizeDef + incrMarkSize, 'marker', plotParams.F2markers(1,:)) ;
end
%
% Plot matUs with no tangent element case 2 
for cycd_index = NRtoPlotF1F2
    ux = matUsNoTangentElemCase2(1:6:end, cycd_index + 1);
    uy = matUsNoTangentElemCase2(3:6:end, cycd_index + 1);
    xdef = xrefElemCase2' + ux                            ;
    plot(xdef(1:markerElemCase2:end), uy(1:markerElemCase2:end),...
        'color', plotParams.F1colors(1,:), 'linewidth', lw, 'linestyle', 'none',...
        'markersize', markerSizeDef, 'marker', plotParams.F1markers(1,:)) ;
end
% Gosselin results
plot(def(1,:,1), -def(2,:,1),...
    'color', plotParams.colourRef(1,:), 'linewidth', lw, 'linestyle', '-',...
    'markersize', markerSizeDef, 'marker', plotParams.markersRef(1,:))
% legend and labels
legend(legendTangentCase1, legendTangentCase2, legendNoTangentCase1, legendNoTangentCase2, 'Reference solution')
labx = xlabel(' $x$ [m] ');    laby = ylabel('$y$ [m]');
% set figure properties
set(legend, 'linewidth', plotParams.axislw, 'location', 'northeast') ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
set(labx, 'FontSize', plotParams.labelAxisFontSize) ; 
set(laby, 'FontSize', plotParams.labelAxisFontSize) ;
axis([0, 1.4*l, 0, 1.2*l])
axis equal
% print figure
namefig2 = strcat(plotParams.printPathExample, 'ex1deformed') ;
print(fig2, namefig2, '-depslatex');
close(2)
%-------------------------------------
% Extract dynamic case relevant results
%-------------------------------------
%----------------------------
% Load dynamic results form mat folder 
%
% load .mat
load(strcat(outputMatFolder, "onsasExample_reconfigurationBeam_dynamic", ".mat"))
%----------------------------
% Specific plot parameters
markerSizeDynamic = 10 ;
% cy_cd index for each wind velocity case
cycd_index_case1 = length(cycd_vec) - 1 ; 
cycd_index_case2 = length(cycd_vec) - 3 ; 
cycd_index_cases = [cycd_index_case1 , cycd_index_case2] ;
%----------------------------------------------------------
% Fluid velocity case 1 uy A  (cycd_index_case1)
%----------------------------------------------------------
timeVec = linspace(0, analysisSettings.finalTime, size(matUs, 2));
windVelCase = 1 ;
indexNelemDynToPlot = [1,length(nelemCasesDynamic)] ;
% the wind velocity is
windVelLDVecCase1 = [];
windVelLDVecCase2 = [];
for currTime = timeVec
  % case 1
  windVelCase1 = feval('windVelCircDynamicCase1', 0, currTime) ;
  windVelLDVecCase1 = [windVelLDVecCase1 windVelCase1(2)] ;
  % case 2
  windVelCase2 = feval('windVelCircDynamicCase2', 0, currTime) ;
  windVelLDVecCase2 = [windVelLDVecCase2 windVelCase2(2)] ;
end
%--------------------------------
% Uy node A plot
%--------------------------------
% Markers first plot
%--------------------------------
% 
% Plot Gosselin Static solution
%--------------------------------
fig6 = figure(6) ;
hold on
plot(linspace(0, analysisSettings.finalTime, 1), -def(2,end,cycd_index_case1)*ones(1,1),...
    'color', plotParams.colourRef(1,:), 'linewidth', lw, 'linestyle', '-.',...
    'markersize', markerSizeDef, 'marker', plotParams.markersRef(1,:))
%
% Lumped matrix (F1) 
%--------------------------------
% plot for each element case 
counterPlot = 1 ;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynLumped{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof      = 6*(numNodes - 1) + 3            ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig6 ;
    % continuum line
    plot(timeVec(1), uyA(1), 'color', plotParams.F1colors(counterPlot,:),
      'linewidth', lw, 'linestyle', 'none',...
      'markersize', markerSizeDynamic + 3*(counterPlot -1), 'marker', plotParams.F1markers(counterPlot,:)) ;
    % add to the counter 
    counterPlot = counterPlot + 1 ;
end 
%
% Consistent no tangent matrix (F2)
%--------------------------------
% plot for each element case 
counterPlot = 1 ;
% plot for each element case 
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig6 ;
    % continuum line
    plot(timeVec(1), uyA(1), 'color', plotParams.F2colors(counterPlot,:),
      'linewidth', lw, 'linestyle', 'none',...
      'markersize', markerSizeDynamic + 3*(counterPlot -1), 'marker', plotParams.F2markers(counterPlot,:)) ;
    % add to the counter 
    counterPlot = counterPlot + 1 ;
end
%
% Consistent with tangent matrix (F3) 
%--------------------------------
% plot for each element case 
counterPlot = 1 ;
% plot for each element case 
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig6 ;
    % continuum line
    plot(timeVec(1), uyA(1), 'color', plotParams.F3colors(counterPlot,:),
      'linewidth', lw, 'linestyle', '-',...
      'markersize', markerSizeDynamic + 3*(elemCase -1), 'marker', plotParams.F3markers(counterPlot,:)) ;
    % add to the counter 
    counterPlot = counterPlot + 1 ;
end
%--------------------------------
% Continuum line plot
%--------------------------------
%
% Lumped matrix (F1) 
%--------------------------------
% plot for each element case 
counterPlot = 1;
for elemCase = indexNelemDynToPlot(end)
    % extract matUs
    matUsCase = matUsNoTangentDynLumped{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof      = 6*(numNodes - 1) + 3            ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig6 ;
    % continuum line
    plot(timeVec, uyA, 'color', plotParams.F1colors(counterPlot,:),
      'linewidth', lw, 'linestyle', 'none') ;
    counterPlot =  counterPlot + 1;
end
% Consistent no tangent matrix (F2)
%--------------------------------
% plot for each element case 
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig6 ;
    % continuum line
    plot(timeVec, uyA, 'color', plotParams.F2colors(1,:),
      'linewidth', lw, 'linestyle', 'none') ;
end
%
% Consistent with tangent matrix (F3) 
%--------------------------------
% plot for each element case 
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig6 ;
    % continuum line
    plot(timeVec, uyA, 'color', plotParams.F3colors(1,:),
      'linewidth', lw, 'linestyle', '-') ;
end
%--------------------------------
% Markers plot
%--------------------------------
% markers span
%
% Lumped matrix (F1) 
%--------------------------------
spanMarkersNoTangentDynLumped = [50, 50] ;
incerementMarkerSizeLumped = 4;
initMarkersLumped = 15;
% plot for each element case 
counterPlot = 1 ;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynLumped{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof      = 6*(numNodes - 1) + 3            ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig6 ;
    % continuum line
    plot(timeVec(initMarkersLumped:spanMarkersNoTangentDynLumped(elemCase):end),...
          uyA(initMarkersLumped:spanMarkersNoTangentDynLumped(elemCase):end),...
          'color', plotParams.F1colors(counterPlot,:),...
          'linewidth', lw, 'linestyle', 'none',...
          'markersize', markerSizeIters + incerementMarkerSizeLumped,...
          'marker', plotParams.F1markers(counterPlot,:)) ;
    % add to the counter 
    counterPlot = counterPlot + 1 ;
end
%
% Consistent no tangent matrix (F2)
%--------------------------------
spanMarkersNoTangentDynConsistent = spanMarkersNoTangentDynLumped ;
incerementMarkerSizeNoTangentConsistent = 4;
initMarkersNoTangentConsistent = 30;
% plot for each element case 
counterPlot = 1 ;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig6 ;
    % continuum line
    plot(timeVec(initMarkersNoTangentConsistent:spanMarkersNoTangentDynConsistent:end),...
       uyA(initMarkersNoTangentConsistent:spanMarkersNoTangentDynConsistent:end),...
      'color', plotParams.F2colors(counterPlot,:),
      'linewidth', lw, 'linestyle', 'none',...
      'markersize', markerSizeIters + incerementMarkerSizeNoTangentConsistent,...
      'marker', plotParams.F2markers(counterPlot,:)) ;
    % add to the counter 
    counterPlot = counterPlot + 1 ;      
end
%
% Consistent with tangent matrix (F3) 
%--------------------------------
incerementMarkerSizeTangentConsistent = 5;
initMarkersTangentConsistent = 50;
% markers span
spanMarkersTangentDynConsistent = spanMarkersNoTangentDynConsistent ;
% plot for each element case 
counterPlot = 1 ;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig6 ;
    % continuum line
    plot(timeVec(initMarkersTangentConsistent:spanMarkersNoTangentDynLumped:end),...
          uyA(initMarkersTangentConsistent:spanMarkersNoTangentDynLumped:end),...
          'color', plotParams.F3colors(counterPlot,:),...
          'linewidth', lw, 'linestyle', 'none',...
          'markersize', markerSizeIters + incerementMarkerSizeTangentConsistent,...
          'marker', plotParams.F3markers(counterPlot,:)) ;
    % add to the counter 
    counterPlot = counterPlot + 1 ;
end
% 
% Plot Gosselin Static solution
%--------------------------------
%
% Lumped case
legendLumpedCase1 = strcat('F1 (', num2str(nelemCasesDynamic(1)), ' elements)') ;
legendLumpedCase2 = strcat('F1 (', num2str(nelemCasesDynamic(end)), ' elements)') ;
%
% Consistent withot matrix case
legendConsistentNoMatrixCase1 = strcat('F2 (', num2str(nelemCasesDynamic(1)), ' elements)') ;
legendConsistentNoMatrixCase2 = strcat('F2 (', num2str(nelemCasesDynamic(end)), ' elements)') ;
% Consistent wtih stifness matrix case
legendConsistentMatrixCase1 = strcat('F3 (', num2str(nelemCasesDynamic(1)), ' elements)') ;
legendConsistentMatrixCase2 = strcat('F3 (', num2str(nelemCasesDynamic(end)), ' elements)') ;
%
% plot labels and legend 
fig6 ;
numPoints = 100 ; 
plot(linspace(0, analysisSettings.finalTime, numPoints), -def(2,end,cycd_index_case1)*ones(numPoints,1),...
    'color', plotParams.colourRef(1,:), 'linewidth', lw + 1, 'linestyle', '-.',...
    'markersize', markerSizeDef, 'marker', plotParams.markersRef(1,:))
% legends and labels 
legend('Reference solution',...
        legendLumpedCase1, legendLumpedCase2,...
        legendConsistentNoMatrixCase1, legendConsistentNoMatrixCase2,...
        legendConsistentMatrixCase1, legendConsistentMatrixCase2)
labx = xlabel(' $t$ [s] ');    laby = ylabel('$u_y$ node A [m]');
axis([0 analysisSettings.finalTime -0.1 1.1])
% set plot properties 
set(legend, 'linewidth', plotParams.axislw, 'location', 'southeast') ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
set(labx, 'FontSize', plotParams.labelAxisFontSize); set(laby, 'FontSize', plotParams.labelAxisFontSize) ;
namefig6 = strcat(plotParams.printPathExample, 'ex1UyAvsTimeWindVelCase1') ;
grid on 
print(fig6, namefig6, '-depslatex');
close(fig6)
%----------------------------------------------------------
% Fluid velocity case 2 uy A  (cycd_index_case2)
%----------------------------------------------------------
windVelCase = 2 ;
%--------------------------------
% Markers first plot
%--------------------------------
% 
% Plot Gosselin Static solution
%--------------------------------
fig7 = figure(7) ;
hold on
plot(linspace(0, analysisSettings.finalTime, 1), -def(2,end,cycd_index_case2)*ones(1,1),...
    'color', plotParams.colourRef(1,:), 'linewidth', lw, 'linestyle', '-.',...
    'markersize', markerSizeDef, 'marker', plotParams.markersRef(1,:))
%
% Lumped matrix (F1) 
%--------------------------------
% plot for each element case 
counterPlot = 1 ;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynLumped{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof      = 6*(numNodes - 1) + 3            ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig7 ;
    % continuum line
    plot(timeVec(1), uyA(1), 'color', plotParams.F1colors(counterPlot,:),
      'linewidth', lw, 'linestyle', 'none',...
      'markersize', markerSizeDynamic + 3*(counterPlot -1), 'marker', plotParams.F1markers(counterPlot,:)) ;
    % increase plot counter 
    counterPlot = counterPlot + 1 ;
end
%
% Consistent no tangent matrix (F2)
%--------------------------------
% plot for each element case 
counterPlot = 1;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig7 ;
    % continuum line
    plot(timeVec(1), uyA(1), 'color', plotParams.F2colors(counterPlot,:),
      'linewidth', lw, 'linestyle', 'none',...
      'markersize', markerSizeDynamic + 3*(counterPlot -1), 'marker', plotParams.F2markers(counterPlot,:)) ;
    % increase plot counter 
    counterPlot = counterPlot + 1 ;
end
%
% Consistent with tangent matrix (F3) 
%--------------------------------
% plot for each element case 
counterPlot = 1;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig7 ;
    % continuum line
    plot(timeVec(1), uyA(1), 'color', plotParams.F3colors(counterPlot,:),
      'linewidth', lw, 'linestyle', '-',...
      'markersize', markerSizeDynamic + 3*(counterPlot -1), 'marker', plotParams.F3markers(counterPlot,:)) ;
    % increase plot counter 
    counterPlot = counterPlot + 1 ;
end
%--------------------------------
% Continuum line plot
%--------------------------------
%
% Lumped matrix (F1) 
%--------------------------------
counterPlot = 1;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynLumped{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof      = 6*(numNodes - 1) + 3            ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig7 ;
    % continuum line
    plot(timeVec, uyA, 'color', plotParams.F1colors(counterPlot,:),
      'linewidth', lw, 'linestyle', 'none') ;
    % increase plot counter 
    counterPlot = counterPlot + 1 ;      
end
%
% Consistent no tangent matrix (F2)
%--------------------------------
% plot for each element case 
counterPlot = 1;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig7 ;
    % continuum line
    plot(timeVec, uyA, 'color', plotParams.F2colors(counterPlot,:),
      'linewidth', lw, 'linestyle', 'none') ;
    counterPlot = counterPlot + 1 ;      

end
%
% Consistent with tangent matrix (F3) 
%--------------------------------
% plot for each element case 
counterPlot = 1 ;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig7 ;
    % continuum line
    plot(timeVec, uyA, 'color', plotParams.F3colors(counterPlot,:),
      'linewidth', lw, 'linestyle', '-') ;
    counterPlot = counterPlot + 1 ; 
end
%--------------------------------
% Markers plot
%--------------------------------
% markers span
%
% Lumped matrix (F1) 
%--------------------------------
% plot for each element case 
counterPlot = 1;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynLumped{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof      = 6*(numNodes - 1) + 3            ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig7 ;
    % continuum line
    plot(timeVec(initMarkersLumped:spanMarkersNoTangentDynLumped:end),...
          uyA(initMarkersLumped:spanMarkersNoTangentDynLumped:end),...
          'color', plotParams.F1colors(counterPlot,:),...
          'linewidth', lw, 'linestyle', 'none',...
          'markersize', markerSizeIters + incerementMarkerSizeLumped*(counterPlot - 1),...
          'marker', plotParams.F1markers(counterPlot,:)) ;
    % plot for each element case 
    counterPlot = counterPlot + 1 ; 
end
%
% Consistent no tangent matrix (F2)
%--------------------------------
% plot for each element case 
counterPlot = 1;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsNoTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig7 ;
    % continuum line
    plot(timeVec(initMarkersNoTangentConsistent:spanMarkersNoTangentDynConsistent:end),...
       uyA(initMarkersNoTangentConsistent:spanMarkersNoTangentDynConsistent:end),...
      'color', plotParams.F2colors(counterPlot,:),
      'linewidth', lw, 'linestyle', 'none',...
      'markersize', markerSizeIters + incerementMarkerSizeNoTangentConsistent*(counterPlot -1),...
      'marker', plotParams.F2markers(counterPlot,:)) ;
    % plot for each element case 
    counterPlot = counterPlot + 1;      
end
%
% Consistent with tangent matrix (F3) 
%--------------------------------
% markers span
spanMarkersTangentDynConsistent = spanMarkersNoTangentDynConsistent ;
% plot for each element case 
counterPlot = 1;
for elemCase = indexNelemDynToPlot
    % extract matUs
    matUsCase = matUsTangentDynConsistent{elemCase, windVelCase} ;
    % node and dof to plot
    numNodes = nelemCasesDynamic(elemCase) + 1 ;
    dof = 6*(numNodes - 1) + 3 ;
    % uy tip node and time vector 
    uyA     = matUsCase(dof,:) ;
    timeVec = linspace(0, analysisSettings.finalTime, size(matUsCase, 2)) ; 
    % uy node A
    fig7 ;
    % continuum line
    plot(timeVec(initMarkersTangentConsistent:spanMarkersNoTangentDynLumped:end),...
          uyA(initMarkersTangentConsistent:spanMarkersNoTangentDynLumped:end),...
          'color', plotParams.F3colors(counterPlot,:),...
          'linewidth', lw, 'linestyle', 'none',...
          'markersize', markerSizeIters + incerementMarkerSizeTangentConsistent,...
          'marker', plotParams.F3markers(counterPlot,:)) ;
    % plot for each element case 
    counterPlot = counterPlot + 1;             
end
% 
% Plot Gosselin Static solution
%--------------------------------
%
% Lumped case
legendLumpedCase1 = strcat('F1 (', num2str(nelemCasesDynamic(1)), ' elements)') ;
legendLumpedCase2 = strcat('F1 (', num2str(nelemCasesDynamic(end)), ' elements)') ;
%
% Consistent withot matrix case
legendConsistentNoMatrixCase1 = strcat('F2 (', num2str(nelemCasesDynamic(1)), ' elements)') ;
legendConsistentNoMatrixCase2 = strcat('F2 (', num2str(nelemCasesDynamic(end)), ' elements)') ;
%
% plot labels and legend 
fig7 ;
numPoints = 100 ; 
plot(linspace(0, analysisSettings.finalTime, numPoints), -def(2,end,cycd_index_case2)*ones(numPoints,1),...
    'color', plotParams.colourRef(1,:), 'linewidth', lw + 1, 'linestyle', '-.',...
    'markersize', markerSizeDef, 'marker', plotParams.markersRef(1,:))
% add legends etc
legend('Reference solution',...
        legendLumpedCase1, legendLumpedCase2,...
        legendConsistentNoMatrixCase1, legendConsistentNoMatrixCase2,...
        legendConsistentMatrixCase1, legendConsistentMatrixCase2)
labx = xlabel(' $t$ [s] ');    laby = ylabel('$u_y$ node A [m]');
axis([0 analysisSettings.finalTime -0.1 1.1])
set(legend, 'linewidth', plotParams.axislw, 'location', 'southeast') ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
set(labx, 'FontSize', plotParams.labelAxisFontSize); set(laby, 'FontSize', plotParams.labelAxisFontSize) ;
namefig7 = strcat(plotParams.printPathExample, 'ex1UyAvsTimeWindVelCase2') ;
grid on 
print(fig7, namefig7, '-depslatex');
close(fig7)
%----------------------------
% Gauss integration points large displacements 3D case
%----------------------------
%
% Load export data from mat folder 
%
% load .mat
load(strcat(outputMatFolder, "onsasExample_reconfigurationBeam_gauss", ".mat"))
%
% reference solution for 3D guass analyisis
%------------------------------------
% index time errors 
fracTimeError = 1 ; 
indexTimeError = round(analysisSettings.finalTime / analysisSettings.deltaT * fracTimeError) ;
tc =  indexTimeError * analysisSettings.deltaT ;
% nume elements of reference sol:
nelemRef = numElementsCase ;
% matUs of reference sol:
matUsGaussRef = matUsGaussConsistent{end, 1} ;
% relative error
relativeErrorGaussConsistent = zeros(numGaussMax-1, 1);
%
% Compute relative error consistent case
%
% for to plot different cases
for indexGauss = 1:numGaussMax-1
  % select matUs:
  matUsGaussCase = matUsGaussConsistent{indexGauss, 1} ;
  % relative error of the case
  relativeErrorGaussConsistentCase = computeRelativeError(matUsGaussCase(:, indexTimeError),...
                                                 matUsGaussRef(:, indexTimeError),...
                                                 mesh.nodesCoords(end,1)) ;
  % fill into the vector
  relativeErrorGaussConsistent(indexGauss) = relativeErrorGaussConsistentCase ;
end
% Replece nul error for epsilin maq
relativeErrorGaussConsistent(find(relativeErrorGaussConsistent == 0)) = eps ;
%
% Compute relative error Lumped case
%
% for to plot different cases
for indexGauss = 1:numGaussMax-1
  % select matUs:
  matUsGaussCase = matUsGaussLumped{indexGauss, 1} ;
  % relative error of the case
  relativeErrorGaussLumpedCase = computeRelativeError(matUsGaussCase(:, indexTimeError),...
                                                 matUsGaussRef(:, indexTimeError),...
                                                 mesh.nodesCoords(end,1)) ;
  % fill into the vector
  relativeErrorGaussLumped(indexGauss) = relativeErrorGaussLumpedCase ;
end
% Replece nul error for epsilin maq
relativeErrorGaussLumped(find(relativeErrorGaussLumped == 0)) = eps ;
% 
% Plot Gauss analysisis
fig7 = figure(7) ;
hold on, grid on 
% plot F2 error
gaussVec = [1:(numGaussMax-1)] ;
semilogy(gaussVec , relativeErrorGaussConsistent,...
          'color', plotParams.F2colors(1,:), 'linewidth', lw, 'linestyle', '-',...
          'markersize', plotParams.F2ms(1,:) -4, 'marker', plotParams.F2markers(1,:))
% legend and labels
legend('F2') 
labx = xlabel('Number of Gauss points') ;   
laby = ylabel('Relative error $\delta u$') ;
% set plot properties
set(legend, 'linewidth', plotParams.axislw, 'location', 'southwest') ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize + 4) ;
set(gca,'XTick',gaussVec) 
set(labx, 'FontSize', plotParams.ticsLabelsLegendFontSize + 4); set(laby, 'FontSize', plotParams.ticsLabelsLegendFontSize + 4) ;
namefig7 = strcat(plotParams.printPathExample, 'ReonfigGauss') ;
print(fig7, namefig7, '-depslatex');
close(7)
%----------------------------
% Export tex parameters
%----------------------------
% Extract relevant values and store it into printParamsTex
printParamsTex.L               = l                                           ;
printParamsTex.d               = d * 1e2                                     ;
printParamsTex.E               = materials.hyperElasParams(1)   / 1e6        ; 
printParamsTex.rho             = materials.density(1)                        ;
printParamsTex.rhoFluid        = rhoF                                        ;
printParamsTex.cd              = feval(elements(2).aeroCoefs{1}, 0)        ;
printParamsTex.cycdCaseOne     = cycd_vec(index_case_1) / 1e4                ;
printParamsTex.cycdCaseTwo     = cycd_vec(index_case_2) / 1e2                ;
printParamsTex.fulidVelCaseOne = fluid_vel_vec(index_case_1)                 ;
printParamsTex.fulidVelCaseTwo = fluid_vel_vec(index_case_2)                 ;
printParamsTex.cycdCaseTwo     = cycd_vec(cycd_index_cases(2)) / 1e2         ;
printParamsTex.tolF            = analysisSettings.stopTolForces /1e-4        ;   
printParamsTex.tolU            = analysisSettings.stopTolDeltau /1e-10       ;   
printParamsTex.deltaT          = analysisSettings.deltaT                     ;   
printParamsTex.finalTime       = analysisSettings.finalTime                  ;     
printParamsTex.deltaT          = analysisSettings.deltaT                     ;   
printParamsTex.tc              = tc                                          ;
printParamsTex.vaOne           = sprintf("%5.3f",fluid_vel_vec(1))           ; 
printParamsTex.vaTwo           = sprintf("%5.3f",fluid_vel_vec(2))           ; 
printParamsTex.vaThree         = sprintf("%5.3f",fluid_vel_vec(3))           ; 
printParamsTex.vaFour          = sprintf("%5.3f",fluid_vel_vec(4))           ;
printParamsTex.vaFive          = sprintf("%5.3f",fluid_vel_vec(5))           ;
printParamsTex.vaSix           = sprintf("%5.3f",fluid_vel_vec(6))           ;
printParamsTex.vaSeven         = sprintf("%5.3f",fluid_vel_vec(7))           ;
printParamsTex.vaEight         = sprintf("%5.3f",fluid_vel_vec(8))           ;
printParamsTex.vaNine          = sprintf("%5.3f",fluid_vel_vec(9))           ;
printParamsTex.vaTen           = sprintf("%5.3f",fluid_vel_vec(10))          ;
execTimeRatio               = executionTimeTangent102{end,1} / executionTimeNoTangent{end,1} ;
printParamsTex.execTimeRatio   = sprintf("%5.0f",execTimeRatio)              ;
% run tex generator function
example_name = 'CircularReconfiguration'                                     ;
texDataGenerator(printParamsTex, example_name, plotParams.printPathExample)  ;
