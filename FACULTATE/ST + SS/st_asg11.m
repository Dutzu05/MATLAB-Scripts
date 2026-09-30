clc; clear; close all;

s = tf('s');
H = (3 * s + 1)/(s + 0.5);

figure;
step(H);
grid on;
title('Step response for H(s) = (3s+1)/(s+0.5)');

t = 0:0.01:20;
y = 2 + exp(-0.5 * t);

figure;
plot(t, y, 'LineWidth', 2);
grid on;
xlabel('t');
ylabel('y(t)');
title('Analytical step response: y(t) = 2 + e^{-0.5t}');
