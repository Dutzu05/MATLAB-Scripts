clc; clear; close all;

t = 0:0.01:10;

y = 0.1667 ...
    - 0.1*exp(-2*t) ...
    - 0.0417*exp(-3*t) ...
    - 0.025*exp(-t).*cos(2*t) ...
    - 0.175*exp(-t).*sin(2*t);

figure;
plot(t, y, 'LineWidth', 2);
grid on;
xlabel('t');
ylabel('y(t)');
title('Forced response from given partial fraction expansion');