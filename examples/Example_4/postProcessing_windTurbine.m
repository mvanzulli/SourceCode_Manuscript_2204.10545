% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------
% Simplified wind turbine example
%-----------------------------------------------------
% clear variables
clear all, close all
% add path
ONSAS_PATH_ENV = getenv('ONSAS_PATH') ;
addpath(genpath(ONSAS_PATH_ENV))  ;
%----------------------------
% Plot parameters
% add utils
Utils_path = "./../Utils/"      ;
addpath(genpath(Utils_path)) ;
% load plot parameters
plotParams = plotParameters()   ;
lw = plotParams.lw ; ms = plotParams.ms ;
% span to plot figures
spanPlotTime = 1 ;
%---------------------------------------
% F2 dynamic case 
%----------------------------------------
% problem name according to onsasExample output name
problemName = 'onsasExample_windTurbine' ;
%
% Load export data from mat folder 
load(strcat('output/mat/',problemName, '.mat')) 
%-----------------------------------------------------
% plot Reference solution 
%-----------------------------------------------------
% Numerical Solution of current velcase
matUsRef = matUsCellConsistent{end, 1} ;
% numercial time vector is given by:
timeVec = linspace(0, analysisSettings.finalTime, size(matUsRef, 2)) ;
%
% nose rotation angle
% numercial rotation angle is:
dofZ      = 5 ;
dofY      = 3 ;
dofThetaX = 2 ;
thetaXnode1Numeric = -matUsRef(dofThetaX,:) ;
% tip blade dipslcaements
nodeBlade              =  numElementsBlade + 1            ;
dofZBlade              = (nodeBlade -1) * 6 + dofZ       ;
uZBlade                = -matUsRef(dofZBlade,:)           ;
dofYBlade              = (nodeBlade -1) * 6 + dofY       ;
uYBlade                = -matUsRef(dofYBlade,:)           ;
%
% build wind  angular velocity
thetaXAngularVelNumeric = [] ;
% consider only a span of angle nodes for compte the velocity
spanVel = 1;
thetaXAngularVelNumericVel = thetaXnode1Numeric(1:spanVel:end) ;
for indexTheta = 1 : length(thetaXAngularVelNumericVel)-1 - spanVel 
  thetaXAngularVelNumericIndex = (thetaXAngularVelNumericVel(indexTheta+spanVel) - thetaXAngularVelNumericVel(indexTheta)) / (spanVel*analysisSettings.deltaT) ;
  thetaXAngularVelNumeric = [ thetaXAngularVelNumeric thetaXAngularVelNumericIndex] ;
end
% time to plot velocity
timeVel=linspace(0, analysisSettings.finalTime,length(thetaXAngularVelNumeric)) ;

%------------------
% Rotation angle  
%------------------
fig1 = figure(1) ;
plot(timeVec(1:spanPlotTime:end), thetaXnode1Numeric(1:spanPlotTime:end), ...
    'color', plotParams.F2colors(1,:), 'linewidth', lw, 'linestyle', '-', 
    'markersize', plotParams.F2ms(1,:), 'marker', 'none')
% axis and legend
labx = xlabel('$t$ [s]') ;
laby = ylabel('$\theta_x$ node O [rad]') ;
legend('\theta_x', 'location', 'North') ; legend hide
% set properties
set(legend, 'linewidth', plotParams.axislw, 'location', 'northwest') ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
set(labx, 'FontSize', plotParams.ticsLabelsLegendFontSize) ; 
set(laby, 'FontSize', plotParams.ticsLabelsLegendFontSize) ;
set(gca,'YTick',0:3*pi:15*pi)
set(gca,'YTickLabel',{'0', '$3\pi$', '$6\pi$', '$9\pi$', '$12\pi$', '$15\pi$'})
% print figure
namefig1 = strcat(plotParams.printPathExample, 'thetaX') ;
grid on
print(fig1, namefig1, '-depslatex') ;
close(1)
%------------------
% Rotation velocity  
%------------------
fig2 = figure(2) ;
plot(timeVel(1:spanPlotTime:end), thetaXAngularVelNumeric(1:spanPlotTime:end), ...
      'color', plotParams.F2colors(2,:), 'linewidth', lw, 'linestyle', '-', ...
      'markersize', plotParams.F2ms(2,:), 'marker', 'none')
% axis and legend
labx = xlabel('$t$ [s]') ;
laby = ylabel('$\dot{\theta_x}$ node O [rad/s]') ;
legend('\dot{\theta_x}', 'location', 'North')
legend hide
% set properties
set(legend, 'linewidth', plotParams.axislw, 'location', 'northwest') ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
set(labx, 'FontSize', plotParams.ticsLabelsLegendFontSize) ; 
set(laby, 'FontSize', plotParams.ticsLabelsLegendFontSize) ;
set(gca,'YTick',0:pi/5:pi)
set(gca,'YTickLabel',{'0', '$\pi/5$', '$2\pi/5$', '$3\pi/5$', '$4\pi/5$','$\pi$'})
axis([0 analysisSettings.finalTime 0 pi])
% print figure
namefig2 = strcat(plotParams.printPathExample, 'thetadotX') ;
grid on
print(fig2, namefig2, '-depslatex') ;
close(2)
%------------------
% UY and Uz node A  
%------------------
fig3 = figure(3) ;
hold on
% uz node A
plot(timeVec(1:spanPlotTime:end), uZBlade(1:spanPlotTime:end), ...
    'color', plotParams.F2colors(1,:), 'linewidth', lw, 'linestyle', '-',...
    'markersize', plotParams.F2ms(1,:), 'marker', 'none')
% uy node A
plot(timeVec(1:spanPlotTime:end), uYBlade(1:spanPlotTime:end), ...
    'color', plotParams.F2colors(2,:), 'linewidth', lw, 'linestyle',...
    ':', 'markersize', plotParams.F2ms(2,:), 'marker', 'none')
% legend and label
legend('\text{$u_z$}', '\text{$u_y$}', 'location', 'North')
labx = xlabel('$t$ [s]');   
laby = ylabel(' $u_z$, $u_y$ (A) [m]') ;
% set properties
set(legend, 'linewidth', plotParams.axislw, 'location', 'northwest') ;
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
set(labx, 'FontSize', plotParams.ticsLabelsLegendFontSize); 
set(laby, 'FontSize', plotParams.ticsLabelsLegendFontSize) ;
axis ([0, analysisSettings.finalTime, -2 * l, 2 * l])
grid on
% print figure
namefig3 = strcat(plotParams.printPathExample, 'dispsA') ;
grid on
print(fig3, namefig3, '-depslatex') ;
close(3)
%----------------------------
% Export tex parameters
%----------------------------
% Extract relevant values and store it into printParamsTex
printParamsTex.L         = l                                     ;
printParamsTex.dch       = dch                                   ;
printParamsTex.Eeq       = materials.hyperElasParams(1) / 1e9    ; 
printParamsTex.Geq       = materials.hyperElasParams(1) / (2 * (1 + materials.hyperElasParams(2))) / 1e9 ;   
printParamsTex.rhoeq     = materials.density(1)                  ;
windVel                  = feval(analysisSettings.userWindVel, 0, analysisSettings.finalTime) ;
printParamsTex.va        = windVel(1)                            ;
printParamsTex.tolF      = analysisSettings.stopTolForces /1e-5  ;   
printParamsTex.tolU      = analysisSettings.stopTolDeltau /1e-10 ;   
printParamsTex.deltaT    = analysisSettings.deltaT               ;   
printParamsTex.finalTime = analysisSettings.finalTime            ;     
printParamsTex.elemBlade = numElementsBlade                      ; 
numberOfRevolutions      = thetaXnode1Numeric(end) / (2 * pi)    ;
printParamsTex.numRev    = sprintf("%5.0f", numberOfRevolutions) ; 

% run tex generator function
example_name = 'WindTurbine'                                     ;
texDataGenerator(printParamsTex, example_name, plotParams.printPathExample) ;