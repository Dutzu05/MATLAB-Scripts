clc; clear; close all;
s = tf('s');

%% 3)
H3 = (3*s + 1)/(s + 0.5);
t3 = 0:0.01:20;
y3 = 2 + exp(-0.5*t3);

figure;
step(H3);
grid on;
title('Step response - Case 3');

figure;
plot(t3, y3, 'LineWidth', 2);
grid on;
xlabel('t'); ylabel('y_3(t)');
title('Analytical response - y_3(t) = 2 + e^{-0.5t}');

%% 4)
H4 = 20/((s+5)*(s+3));
t4 = 0:0.01:10;
y4 = 4/3 + 2*exp(-5*t4) - (10/3)*exp(-3*t4);

figure;
step(H4);
grid on;
title('Step response - Case 4');

figure;
plot(t4, y4, 'LineWidth', 2);
grid on;
xlabel('t'); ylabel('y_4(t)');
title('Analytical response - y_4(t) = 4/3 + 2e^{-5t} - (10/3)e^{-3t}');

%% 5)
H5 = (3*s)/(s+2);
t5 = 0:0.01:10;
y5 = 3*exp(-2*t5);

figure;
step(H5);
grid on;
title('Step response - Case 5');

figure;
plot(t5, y5, 'LineWidth', 2);
grid on;
xlabel('t'); ylabel('y_5(t)');
title('Analytical response - y_5(t) = 3e^{-2t}');

%% 6)
H6 = 21/(s*(s+7));
t6 = 0:0.01:5;
y6 = -3/7 + 3*t6 + (3/7)*exp(-7*t6);

figure;
step(H6);
grid on;
title('Step response - Case 6');

figure;
plot(t6, y6, 'LineWidth', 2);
grid on;
xlabel('t'); ylabel('y_6(t)');
title('Analytical response - y_6(t) = -3/7 + 3t + (3/7)e^{-7t}');

%%7)
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