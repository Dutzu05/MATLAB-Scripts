clc; clear; close all;

s = tf('s');
H = (3*s)/(s+2);

figure;
step(H);
grid on;
title('Step response for H(s) = 3s/(s+2)');

% Analytical solution
t = 0:0.01:10;
y = 3*exp(-2*t);

figure;
plot(t, y, 'LineWidth', 2);
grid on;
xlabel('t');
ylabel('y(t)');
title('Analytical step response: y(t) = 3e^{-2t}');