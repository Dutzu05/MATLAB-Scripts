clc; clear; close all;

s = tf('s');
H = 20/((s+5)*(s+3));

figure;
step(H);
grid on;
title('Step response for H(s) = 20/((s+5)(s+3))');

% Analytical solution
t = 0:0.01:10;
y = 4/3 + 2*exp(-5*t) - (10/3)*exp(-3*t);

figure;
plot(t, y, 'LineWidth', 2);
grid on;
xlabel('t');
ylabel('y(t)');
title('Analytical step response: y(t) = 4/3 + 2e^{-5t} - (10/3)e^{-3t}');