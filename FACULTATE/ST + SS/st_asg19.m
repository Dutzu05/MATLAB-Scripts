clc; clear; close all;
syms s t

Y = -0.0417/(s+3) ...
    + (-0.0125 + 0.0875i)/(s+1-2i) ...
    + (-0.0125 - 0.0875i)/(s+1+2i) ...
    - 0.1/(s+2) ...
    + 0.1667/s;

y = ilaplace(Y, s, t);
y = simplify(y)

fplot(y, [0 10], 'LineWidth', 2);
grid on;
xlabel('t');
ylabel('y(t)');
title('Forced response using ilaplace');