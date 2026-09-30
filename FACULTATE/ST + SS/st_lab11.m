clear;
clc;
close all;

figure('Color','w');
hold on;
grid on;
box on;

%% Axes limits and ticks
xlim([-4 0.5]);
ylim([-3 3]);

xticks(-4:0.5:0.5);
yticks(-3:1:3);

xlabel('Parte reala de poli');
ylabel('Parte imaginara de poli');
title('Locul radacinilor');

%% Draw root locus branches

% Branch from -3 to -2, blue
plot([-3 -2], [0 0], 'b', 'LineWidth', 3);

% Branch from -1 to -2, green
plot([-1 -2], [0 0], 'g', 'LineWidth', 3);

% Vertical asymptote/branches through -2, red
plot([-2 -2], [-2.3 2.3], 'r', 'LineWidth', 2);

% Red arrow heads
plot(-2, 2.3, '^', 'Color', 'r', 'MarkerFaceColor', 'w', ...
     'MarkerSize', 8, 'LineWidth', 1.5);

plot(-2, -2.3, 'v', 'Color', 'r', 'MarkerFaceColor', 'w', ...
     'MarkerSize', 8, 'LineWidth', 1.5);

%% Open-loop poles
plot(-3, 0, 'rx', 'MarkerSize', 8, 'LineWidth', 2);
plot(-1, 0, 'rx', 'MarkerSize', 8, 'LineWidth', 2);

%% Breakaway point
plot(-2, 0, 'bo', 'MarkerSize', 5, 'MarkerFaceColor', 'b');

%% Text labels
text(-3.65, 1.2, 'ramura din -3', 'FontSize', 9);
text(-1.55, -0.65, 'ramura din -1', 'FontSize', 9);
text(-1.85, 0.45, 'k=1', 'FontSize', 8);

%% Arrows for labels
annotation('textarrow', [0.39 0.49], [0.63 0.53], ...
           'String', '', 'Color', 'k');

annotation('textarrow', [0.69 0.57], [0.43 0.49], ...
           'String', '', 'Color', 'k');

%% Make the plot visually similar
axis square;

set(gca, 'FontSize', 8);
set(gca, 'LineWidth', 1);

hold off;