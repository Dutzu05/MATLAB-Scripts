clc; clear; close all;

s = tf('s');
H7 = 16/(s^2 + 2*s + 16);

% Step response from transfer function
figure;
step(H7);
grid on;
title('Step response for H(s) = 16/(s^2 + 2s + 16)');

% Analytical response
t = 0:0.01:10;
y7 = 1 - exp(-t).*cos(sqrt(15)*t) - (1/sqrt(15))*exp(-t).*sin(sqrt(15)*t);

figure;
plot(t, y7, 'LineWidth', 2);
grid on;
xlabel('t');
ylabel('y_7(t)');
title('Analytical response for case 7');