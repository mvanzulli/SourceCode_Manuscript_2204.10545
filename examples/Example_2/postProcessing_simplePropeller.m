% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------
% Simple propeller example
%-----------------------------------------------------
% clear variables
clear all, close all
%----------------------------
% Plot parameters
% add utils
Utils_path = "./../Utils/"    ;
addpath(genpath(Utils_path))  ;
% load plot parameters
plotParams = plotParameters() ;
lw = plotParams.lw ; ms = plotParams.ms ;
spanMarkersVecF2 = [60 ; 75]  ;
spanMarkersVecF1 = [90 ; 110] ;
%----------------------------
%
% problem name according to onsasExample output name
problemName = 'onsasExample_simplePropeller_rigid' ;
%
% Load export data from mat folder 
outputMatFolder = "output/mat/" ;
load(strcat(outputMatFolder, problemName, '.mat')) 
%------------------------------------
% Analytical vrw = vaw assumption case
%------------------------------------
% compute solution by the second cardinal, for the wind parameters loaded
rhoA = 1.225 ; c_l = feval('liftCoef', 0) ;
% Analytical solution
vwind = feval(analysisSettings.fluidProps{3}, 0, 0) ;
% lift load per unit of length: 
fl = 1 / 2 * c_l * rhoA * norm(vwind) ^ 2 * d ;
% the total moment induced in node 1 in x direction for is the sum for three blades: 
moment1x = 3 * fl * l * l / 2 ;
% then the angular moment is:
bladeMass = rho * l * pi * d ^2 /4   ; 
Jrho =  3 * 1/3 * bladeMass  * l ^ 2 ;
% the analytical solution is: 
thetaXnode1       = @(t)  moment1x / Jrho / 2 * t .^ 2  ;
thetaDotXnode1    = @(t)  moment1x / Jrho * t           ;
thetaDotDotXnode1 = @(t)  moment1x / Jrho               ;
% numerical time vector is given by:
timeVec = linspace(0, analysisSettings.finalTime, size(matUsCellRigidConsistent{1,1}, 2)) ;
% analytical rotation angle is:
thetaXnode1Analytic = thetaXnode1(timeVec) ;
%------------------------------------------------------
% Plot azimuth angle of the propeller (theta X node A )
%------------------------------------------------------
fig1 = figure(1) ;
hold on
% re plot analytical solution
plot(timeVec(1), thetaXnode1Analytic(1),...
    'color', plotParams.colourRef(1,:), 'linewidth', lw, 'linestyle', '-')
%------------------------------------------------------
% First plot of consistent and lumped rigid case for legend
%----------------------------------------------------------
%------------------------------------
% Rigid consistent mass matrix case
%------------------------------------
% counter for colors 
counterPlot = 1 ;
% numerical origin rotation angle is:
dofX = 2 ;
% elements cases to plot displacements
plotElemCases = [1 length(nelemCasesConsistentRigid)] ; 
%
% reference solution for consistent rigid case
%------------------------------------
% number of elements elements of reference sol:
nelemRef = nelemCasesConsistentRigid(end) ;
% matUs of reference sol:
matUsConsistentRigidRef  = matUsCellRigidConsistent{length(nelemCasesConsistentRigid), 1} ;
% for to plot different cases
for indexElem = 1:length(nelemCasesConsistentRigid)
  % select matUs:
  matUsConsistentRigidElem = matUsCellRigidConsistent{indexElem, 1} ;
  % numerical origin rotation angle is:
  thetaXnode1ConsistentRigidNumeric = -matUsConsistentRigidElem(dofX,:) ;
  % angle joint plot
  if find(indexElem == plotElemCases) > 0
    figure(1) ;
    plot(timeVec(1), thetaXnode1ConsistentRigidNumeric(1),...
        'color', plotParams.F2colors(counterPlot,:), 'linewidth', lw, 'linestyle', '-', 'markersize',...
        plotParams.F2ms(counterPlot), 'marker', plotParams.F2markers(counterPlot))
    counterPlot = counterPlot + 1 ;
  end
end
%------------------------------------
% Rigid lumped mass matrix case
%------------------------------------
% counter for colors 
counterPlot = 1 ;
% elements cases to plot lumped displacements
plotElemCases = [1 length(nelemCasesLumpedRigid)] ;
%
% for to plot different cases
for indexElem = 1:length(nelemCasesLumpedRigid)
  % select matUs:
  matUsLumpedRigidElem = matUsCellRigidLumped{indexElem, 1} ;
  % numerical origin rotation angle is:
  thetaXnode1LumpedRigidNumeric = -matUsLumpedRigidElem(dofX,:) ;
  % angle joint plot
  if find(indexElem == plotElemCases) > 0
    figure(1) ;
    plot(timeVec(1), thetaXnode1LumpedRigidNumeric(1),...
        'color', plotParams.F1colors(counterPlot,:), 'linewidth', lw, 'linestyle', '-',...
        'markersize', plotParams.F1ms(counterPlot,:), 'marker', plotParams.F1markers(counterPlot,:))
    % increment the counter
    counterPlot = counterPlot + 1 ;
  end
end
%-------------------------------------------------------
% Continue the plot of consistent and lumped rigid case
%-------------------------------------------------------
%------------------------------------
% Rigid consistent mass matrix case
%------------------------------------
% reset counter plot
counterPlot = 1 ;
% elements cases to plot displacements
plotElemCases = [1 length(nelemCasesConsistentRigid)] ;
%
% index time errors 
fracTimeError = .9 ; 
indexTimeError = round(analysisSettings.finalTime / analysisSettings.deltaT * fracTimeError) ;
% reference solution for consistent rigid case
%------------------------------------
% number of elements elements of reference sol:
nelemRef = nelemCasesConsistentRigid(end) ;
% matUs of reference sol:
matUsConsistentRigidRef  = matUsCellRigidConsistent{length(nelemCasesConsistentRigid), 1} ;
% numerical origin rotation angle is:
thetaXnode1RigidRef = -matUsConsistentRigidRef(dofX,:) ;
% for to plot different cases
for indexElem = 1:length(nelemCasesConsistentRigid)
  % select matUs:
  matUsConsistentRigidElem = matUsCellRigidConsistent{indexElem, 1} ;
  % numerical origin rotation angle is:
  thetaXnode1ConsistentRigidNumeric = -matUsConsistentRigidElem(dofX,:) ;
  % angle joint plot only the last
  if find(indexElem == plotElemCases) > 0
    figure(1) ;
    % continue line
    plot(timeVec, thetaXnode1ConsistentRigidNumeric,...
        'color', plotParams.F2colors(counterPlot,:), 'linewidth', lw, 'linestyle', '-')
    % markers
    plot(timeVec(1:spanMarkersVecF2(counterPlot):end), thetaXnode1ConsistentRigidNumeric(1:spanMarkersVecF2(counterPlot):end),...
        'color', plotParams.F2colors(counterPlot,:), 'linewidth', lw, 'linestyle', 'none', 'markersize',...
         plotParams.F2ms(counterPlot), 'marker', plotParams.F2markers(counterPlot))
    counterPlot = counterPlot + 1 ;
  end
end
%------------------------------------
% Rigid lumped mass matrix case
%------------------------------------
% reset counter plot
counterPlot = 1 ;
% elements cases to plot displacements
plotElemCases = [1 2] ;
% for to plot different cases
for indexElem = 1:length(nelemCasesLumpedRigid)
  % select matUs:
  matUsLumpedRigidElem = matUsCellRigidLumped{indexElem, 1} ;
  % numerical origin rotation angle is:
  thetaXnode1LumpedRigidNumeric = -matUsLumpedRigidElem(dofX,:) ;
  % angle joint plot only the last
  if find(indexElem == plotElemCases) > 0
    figure(1) ;
    % continue line
    plot(timeVec, thetaXnode1LumpedRigidNumeric,...
          'color', plotParams.F1colors(counterPlot,:), 'linewidth', lw, 'linestyle', '-')
    % markers
    plot(timeVec(1:spanMarkersVecF1(counterPlot):end), thetaXnode1LumpedRigidNumeric(1:spanMarkersVecF1(counterPlot):end),...
          'color', plotParams.F1colors(counterPlot,:), 'linewidth', lw, 'linestyle', 'none', 'markersize',...
           plotParams.F1ms(counterPlot), 'marker', plotParams.F1markers(counterPlot))
    counterPlot = counterPlot + 1 ;
  end
end
%
% Add labels to thetaX plot
figure(1)
grid on 
% re plot analytical solution
plot(timeVec, thetaXnode1Analytic,...
      'color', plotParams.colourRef(1,:), 'linewidth', lw, 'linestyle', '-')
% legend and axis
labx = xlabel('$t$ [s]');   laby = ylabel('$\theta_{x,\text{O}}$ [rad]') ;
legend('Analytic solution',...
      strcat('F2 (', num2str(nelemCasesConsistentRigid(1)), ' element)'            ),...
      strcat('F2 ref. (', num2str(nelemCasesConsistentRigid(end)), ' elements)'    ),...
      strcat('F1 (', num2str(nelemCasesLumpedRigid(plotElemCases(1))), ' element)' ),...
      strcat('F1 (', num2str(nelemCasesLumpedRigid(plotElemCases(2))), ' elements)'))
% plot properties
set(legend, 'linewidth', plotParams.axislw, 'location', 'northwest') ;
axis([0 analysisSettings.finalTime + 30 0 5*pi])
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
xTicVec = 0:50:450 ;
yTicVec = 0:pi:5*pi ;
yTicLabels = {'0', '$\pi$', '$2\pi$', '$3\pi$', '$4\pi$','$5\pi$'} ;
set(gca, 'XTick', xTicVec, 'YTick', yTicVec)
set(gca, 'YTickLabel', yTicLabels)
set(labx, 'FontSize', plotParams.labelAxisFontSize) ;
set(laby, 'FontSize', plotParams.labelAxisFontSize) ;
% print figure
namefig1 = strcat(plotParams.printPathExample, 'valPropRigidThetaXO') ;
print(fig1, namefig1, '-depslatex') ;
close(1)
%----------------------------
% Flexible case
%----------------------------
problemName = 'onsasExample_simplePropeller_flexible' ;
% load .mat
load(strcat(outputMatFolder, problemName, '.mat')) 
%----------------------------------------------------------
% First plot of consistent and lumped Flex case for legend
%----------------------------------------------------------
%------------------------------------
% Flex consistent mass matrix case
%------------------------------------
% plot elem cases
plotElemCases = [1 length(nelemCasesConsistentFlex)] ; 
%
% reference solution for consistent Flex case
%------------------------------------
% counter plot reset
counterPlot = 1 ;
% nume elements of reference sol:
nelemRef = nelemCasesConsistentFlex(end) ;
% for to plot different cases
for indexElem = 1:length(nelemCasesConsistentFlex)
  % select matUs:
  matUsConsistentFlexElem = matUsCellFlexConsistent{indexElem, 1} ;
  % numerical origin rotation angle is:
  thetaXnode1ConsistentFlexNumeric = -matUsConsistentFlexElem(dofX,:) ;
  % dof theta blade is 
  dofThetaBlade = nelemCasesConsistentFlex(indexElem)*6 + 6 ;
  % numerical blade angle computation
  thetaXnodeConsistentFlexBladeNumeric = -matUsConsistentFlexElem(dofThetaBlade,:) ;
  % angle joint and blade plot
  if find(indexElem == plotElemCases) > 0
    %theta X node O
    figure(1) ;
    hold on
    plot(timeVec(1), thetaXnode1ConsistentFlexNumeric(1),...
        'color', plotParams.F2colors(counterPlot,:), 'linewidth', lw, 'linestyle', '-', 'markersize',...
         plotParams.F2ms(counterPlot), 'marker', plotParams.F2markers(counterPlot))
    %theta X node A
    fig2 = figure(2) ;
    hold on
    plot(timeVec(1), thetaXnodeConsistentFlexBladeNumeric(1),...
        'color', plotParams.F2colors(counterPlot,:), 'linewidth', lw, 'linestyle', '-', 'markersize',...
         plotParams.F2ms(counterPlot), 'marker', plotParams.F2markers(counterPlot))
    counterPlot = counterPlot + 1 ;
  end
end
%-------------------------------------------------------
% Continue the plot of consistent and lumped Flex case
%-------------------------------------------------------
%------------------------------------
% Flex consistent formulation case
%------------------------------------
% reset counter plot
counterPlot = 1 ;
% elements cases to plot displacements
plotElemCases = [2 length(nelemCasesConsistentFlex)] ;
%
% reference solution for consistent Flex case
%------------------------------------
% nume elements of reference sol:
nelemRef = nelemCasesConsistentFlex(end) ;
% matUs of reference sol:
matUsConsistentFlexRef  = matUsCellFlexConsistent{length(nelemCasesConsistentFlex), 1} ;
% numerical origin rotation angle is:
thetaXnode1FlexRef = -matUsConsistentFlexRef(dofX,:) ;
% for to plot different cases
for indexElem = 1:length(nelemCasesConsistentFlex)
  % select matUs:
  matUsConsistentFlexElem = matUsCellFlexConsistent{indexElem, 1} ;
  % numerical origin rotation angle is:
  thetaXnode1ConsistentFlexNumeric = -matUsConsistentFlexElem(dofX,:) ;
  % dof theta blade is 
  dofThetaBlade = nelemCasesConsistentFlex(indexElem)*6 + 2 ;
  % numerical blade angle computation
  thetaXnodeLumpedFlexBladeNumeric = -matUsConsistentFlexElem(dofThetaBlade,:) ;
  % angle joint plot only the last
  if find(indexElem == plotElemCases) > 0
    % theta X node O
    figure(1) ;
    % continue line
    plot(timeVec, thetaXnode1ConsistentFlexNumeric,...
        'color', plotParams.F2colors(counterPlot,:), 'linewidth', lw, 'linestyle', '-')
    % markers
    plot(timeVec(1:spanMarkersVecF2(counterPlot):end), thetaXnode1ConsistentFlexNumeric(1:spanMarkersVecF2(counterPlot):end),...
        'color', plotParams.F2colors(counterPlot,:), 'linewidth', lw, 'linestyle', 'none', 'markersize',...
         plotParams.F2ms(counterPlot), 'marker', plotParams.F2markers(counterPlot))
    % theta X node A
    figure(2) ;
    % continue line
    plot(timeVec, thetaXnodeLumpedFlexBladeNumeric,...
        'color', plotParams.F2colors(counterPlot,:), 'linewidth', lw, 'linestyle', '-')
    % markers
    plot(timeVec(1:spanMarkersVecF2(counterPlot):end), thetaXnodeLumpedFlexBladeNumeric(1:spanMarkersVecF2(counterPlot):end),...
        'color', plotParams.F2colors(counterPlot,:), 'linewidth', lw, 'linestyle', 'none', 'markersize',...
         plotParams.F2ms(counterPlot), 'marker', plotParams.F2markers(counterPlot))
    counterPlot = counterPlot + 1 ;
  end
end
% Theta X node O flexible case
%------------------------------------
figure(1)
grid on
labx = xlabel('$t$ [s]');   laby = ylabel('$\theta_{x}$ [rad]') ;
legend(strcat('F2 (', num2str(nelemCasesConsistentFlex(1)), ' elements)'),...
      strcat('F2 (', num2str(nelemCasesConsistentFlex(end)), ' elements)'))
% legend and axis
set(legend, 'linewidth', plotParams.axislw, 'location', 'northwest') ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
set(labx, 'FontSize', plotParams.labelAxisFontSize) ;
set(laby, 'FontSize', plotParams.labelAxisFontSize) ;
set(gca,'XTick', xTicVec,'YTick', yTicVec)
set(gca,'YTickLabel', yTicLabels)
axis([0 analysisSettings.finalTime + 30 0 5*pi])
% print figure
namefig1 = strcat(plotParams.printPathExample, 'valPropFlexThetaXO') ;
print(fig1, namefig1, '-depslatex');
close(1)
% Theta X node A flexible case
%------------------------------------
fig2 = figure(2);
grid on 
labx = xlabel('$t$ [s]');   laby = ylabel('$\theta_{x,\text{A}}$ [rad]') ;
legend(strcat('F2 (', num2str(nelemCasesConsistentFlex(1)), ' elements)'),...
        strcat('F2 (', num2str(nelemCasesConsistentFlex(end)), ' elements)'))
% legend and axis
set(legend, 'linewidth', plotParams.axislw, 'location', 'northwest') ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
set(labx, 'FontSize', plotParams.labelAxisFontSize) ;
set(laby, 'FontSize', plotParams.labelAxisFontSize) ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
axis([0 analysisSettings.finalTime -pi/5 5*pi])
set(gca,'XTick', xTicVec, 'YTick', yTicVec)
set(gca,'YTickLabel', yTicLabels)
% print figure
namefig2 = strcat(plotParams.printPathExample, 'valPropFlexThetaXA') ;
print(fig2, namefig2, '-depslatex');
close(2)
%----------------------------
% Export tex parameters
%----------------------------
printParamsTex.L         = l                                     ;
printParamsTex.d         = d                                     ;
printParamsTex.Ef        = materials.hyperElasParams(1)  / 1e3   ; 
windVel                  = feval(analysisSettings.fluidProps{3}, 0, analysisSettings.finalTime) ;
printParamsTex.va        = windVel(1)                            ;
printParamsTex.Er        = materials.hyperElasParams(1)  / 10    ; 
printParamsTex.rho       = materials.density(1)                  ;
printParamsTex.tolF      = analysisSettings.stopTolForces /1e-6  ;   
printParamsTex.tolU      = analysisSettings.stopTolDeltau /1e-12 ;   
printParamsTex.deltaT    = analysisSettings.deltaT               ;   
printParamsTex.finalTime = analysisSettings.finalTime            ;     
% run tex generator function
example_name = 'SimplePropeller'                                             ;
texDataGenerator(printParamsTex, example_name, plotParams.printPathExample)  ;