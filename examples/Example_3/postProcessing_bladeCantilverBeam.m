% Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
%
% Development and implementation of a consistent co-rotational 
% formulation for aerodynamic nonlinear analysis of frame structures.
%
%-----------------------------------------------------
% Blade cantilever beam
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
addpath(genpath(Utils_path));
% load plot parameters
plotParams = plotParameters()   ;
lw = plotParams.lw ; ms = plotParams.ms ;
%---------------------------------------
% Static 3D case 
%----------------------------------------
%
% Load export data from mat folder 
%
% problem name according to onsasExample output name
problemName = strcat('onsasExample_nonLinearCantileverBlade_static_3D') ;
% load .mat
mat_folder = "output/mat/" ;
load(strcat(mat_folder, problemName, '.mat'))
%
% Compute velocity angle
%
deltaT = 1 ;
timeVec = linspace(deltaT, analysisSettings.finalTime, size(matUs3DStaticPitch, 2) - 1) ;
angleAlpha = [] ; 
for t = timeVec
      windVelocity =  feval(analysisSettings.fluidProps{3}, l, t);
      angleAlpha = [angleAlpha, -atan2(windVelocity(3), windVelocity(2))];
end
alpha_to_plot = [0, pi/16, pi/8, 3*pi/16, pi/4] ;
% caracteristicDimension
dimCaracteristic = norm(elements(2).elemTypeAero(1:3)) ;
%------------------
% Static forces
%------------------
% Sepcific plot params
spanForces = 2 ;
% Fy force for different values of alpha
fig3 = figure(3) ;
hold on; grid on
% Fy vs alpha forces no pitch (F1)
plot (angleAlpha(1:spanForces:end), globalReactionForcesNoPitch(3:6:end)(1:spanForces:end), ...
      'color', plotParams.F1colors(1,:), 'linewidth', lw, 'linestyle', ':',...
      'markersize', plotParams.F1ms(1,:), 'marker', plotParams.F1markers(1,:))
% Fy vs alpha forces with pitch (F2)
plot (angleAlpha(1:spanForces:end), globalReactionForcesPitch(3:6:end)(1:spanForces:end), ...
      'color', plotParams.F2colors(1,:), 'linewidth', lw, 'linestyle', ':',...
      'markersize', plotParams.F2ms(1,:), 'marker', plotParams.F2markers(1,:))
% Fz vs alpha no pitch (F1)
plot (angleAlpha(1:spanForces:end), globalReactionForcesNoPitch(5:6:end)(1:spanForces:end), ...
      'color', plotParams.F1colors(2,:), 'linewidth', lw, 'linestyle', '-',...
      'markersize', plotParams.F1ms(2,:), 'marker', plotParams.F1markers(2,:))
% Fz vs alpha with pitch (F1)
plot (angleAlpha(1:spanForces:end), globalReactionForcesPitch(5:6:end)(1:spanForces:end), ...
      'color', plotParams.F2colors(2,:), 'linewidth', lw, 'linestyle', '-',...
      'markersize', plotParams.F2ms(2,:), 'marker', plotParams.F2markers(2,:))
% axis and legend
labx = xlabel('$\alpha$ [rad]');    laby=ylabel('$F_y$, $F_z$ node O [N]');
legend('F1 $F_y$', 'F2 $F_y$', 'F1 $F_z$', 'F2 $F_z$', 'linewidth' , plotParams.axislw , 'location', 'northwest') ;
axis([alpha_to_plot(1), alpha_to_plot(end)])
% set prpoerties
set(gca,'XTick',alpha_to_plot)
set(gca,'XTickLabel',{'$0$','$\pi/16$','$\pi/8$','$3\pi/16$','$\pi/4$'})
set(gca, 'linewidth', plotParams.axislw, 'fontsize', plotParams.ticsLabelsLegendFontSize) ;
set(labx, 'FontSize', plotParams.ticsLabelsLegendFontSize) ;
set(laby, 'FontSize', plotParams.ticsLabelsLegendFontSize) ;
% print figure
namefig3 = strcat(plotParams.printPathExample, 'BladeCantForcesStatic') ;
print(fig3, namefig3, '-depslatex') ;
close(3)
%------------------
% Static moments
%------------------
% Sepcific plot params
spanMoments = 2 ;
fig4 = figure(4) ;
hold on; grid on
% M_x vs alpha no pitch (F1)
plot (angleAlpha(1:spanMoments:end), globalReactionForcesNoPitch(2:6:end)(1:spanMoments:end), ...
      'color', plotParams.F1colors(1,:), 'linewidth', lw, 'linestyle', ':',...
      'markersize', plotParams.F1ms(1,:), 'marker', plotParams.F1markers(1,:))
% M_x vs alpha with pitch (F2)
plot (angleAlpha(1:spanMoments:end), globalReactionForcesPitch(2:6:end)(1:spanMoments:end), ...
      'color', plotParams.F2colors(1,:), 'linewidth', lw, 'linestyle', ':',...
      'markersize', plotParams.F2ms(1,:), 'marker', plotParams.F2markers(1,:))
% axis and legend
labx = xlabel('$\alpha$ [rad]');    laby=ylabel('$M_x$ node O [N.m]');
legend('F1', 'F2', 'linewidth' , plotParams.axislw, 'location', 'southwest') ;
% set prpoerties
set(gca,'XTick',alpha_to_plot)
set(gca,'XTickLabel',{'$0$','$\pi/16$','$\pi/8$','$3\pi/16$','$\pi/4$'}) 
set(gca, 'linewidth' , plotParams.axislw , 'fontsize', plotParams.ticsLabelsLegendFontSize)   ;
set(labx, 'FontSize', plotParams.ticsLabelsLegendFontSize) ;
set(laby, 'FontSize', plotParams.ticsLabelsLegendFontSize) ;
% print figure
namefig4 = strcat(plotParams.printPathExample, 'BladeCantMomentXStatic') ;
print(fig4, namefig4, '-depslatex') ;
close(4)
% M_y,M_z force for different values of alpha
fig5 = figure(5) ;
hold on; grid on
% M_y vs alpha no pitch (F1)
plot (angleAlpha(1:spanMoments:end), globalReactionForcesNoPitch(4:6:end)(1:spanMoments:end), ...
      'color', plotParams.F1colors(1,:), 'linewidth', lw, 'linestyle', '-',...
      'markersize', plotParams.F1ms(1,:), 'marker', plotParams.F1markers(1,:))
% M_y vs alpha pitch (F2)
plot (angleAlpha(1:spanMoments:end), globalReactionForcesPitch(4:6:end)(1:spanMoments:end), ...
      'color', plotParams.F2colors(1,:), 'linewidth', lw, 'linestyle', '-',...
      'markersize', plotParams.F2ms(1,:), 'marker', plotParams.F2markers(1,:))
% M_z vs alpha no pitch (F2)
plot (angleAlpha(1:spanMoments:end), globalReactionForcesNoPitch(6:6:end)(1:spanMoments:end), ...
      'color', plotParams.F1colors(2,:), 'linewidth', lw, 'linestyle', '-',...
      'markersize', plotParams.F1ms(2,:), 'marker', plotParams.F1markers(2,:))
% M_z vs alpha pitch (F2)
plot (angleAlpha(1:spanMoments:end), globalReactionForcesPitch(6:6:end)(1:spanMoments:end), ...
      'color', plotParams.F2colors(2,:), 'linewidth', lw, 'linestyle', '-',...
      'markersize', plotParams.F2ms(2,:), 'marker', plotParams.F2markers(2,:))
% axis and legend
labx = xlabel('$\alpha$ [rad]');    laby=ylabel('$M_z$, $M_y$ node O [N.m]');
legend('F1 $M_y$', 'F2 $M_y$', 'F1 $M_z$', 'F2 $M_z$', 'linewidth' , plotParams.axislw , 'location', 'northwest') ;
axis([alpha_to_plot(1), alpha_to_plot(end)])
% set prpoerties
set(gca,'XTick',alpha_to_plot)
set(gca,'XTickLabel',{'$0$','$\pi/16$','$\pi/8$','$3\pi/16$','$\pi/4$'})
set(gca, 'linewidth' , plotParams.axislw , 'fontsize', plotParams.ticsLabelsLegendFontSize)   ;
set(labx, 'FontSize', plotParams.ticsLabelsLegendFontSize) ;
set(laby, 'FontSize', plotParams.ticsLabelsLegendFontSize) ;
% print figure
namefig5 = strcat(plotParams.printPathExample, 'BladeCantMomentsYZStatic') ;
print(fig5, namefig5, '-depslatex') ;
close(5)
%----------------------------
% Export tex parameters
%----------------------------
% Extract relevant values and store it into printParamsTex
printParamsTex.L         = l                                         ;
printParamsTex.dch       = elements(2).elemTypeAero(2)               ;
printParamsTex.Eeq       = materials.hyperElasParams(1) / 1e9        ; 
Geq                      = materials.hyperElasParams(1) / (2 * (1 + materials.hyperElasParams(2))) ;
printParamsTex.Geq       = sprintf("%5.1f", Geq / 1e9)               ; 
printParamsTex.rho       = materials.density(1)                      ;
windVel                  = feval(analysisSettings.fluidProps{3}, 0,analysisSettings.finalTime) ; 
printParamsTex.vm        = norm(windVel)                             ;
printParamsTex.tolF      = analysisSettings.stopTolForces /1e-7      ;   
printParamsTex.tolU      = analysisSettings.stopTolDeltau /1e-12     ;   
printParamsTex.deltaT    = analysisSettings.deltaT                   ;   
printParamsTex.finalTime = analysisSettings.finalTime                ;     
printParamsTex.numElem   = numElements3D                             ;
printParamsTex.alphaEnd  = sprintf("%5.0f", rad2deg(angleAlpha(end))); 
torsionalMomentRatio     = globalReactionForcesPitch(2:6:end)(end) / globalReactionForcesNoPitch(2:6:end)(end) ; 
printParamsTex.torsionalMomentRatio = sprintf("%5.0f", torsionalMomentRatio)                                   ; 
printParamsTex.torsionalMomentFOne  = sprintf("%5.2f", globalReactionForcesNoPitch(2:6:end)(end))              ; 
printParamsTex.torsionalMomentFTwo  = sprintf("%5.0f", globalReactionForcesPitch(2:6:end)(end))                ; 
% run tex generator function
example_name = 'CantileverBlade'                                            ;
texDataGenerator(printParamsTex, example_name, plotParams.printPathExample) ;