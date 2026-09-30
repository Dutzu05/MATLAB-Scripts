% generate discrete sinusoidal signal

N = 65; % period
As = 1; % amplitude
M = 256; % total number of samples
n = 0:M-1; % discrete time index

xp = As * sin(2 * pi * n / N);

% add white noise

A = 0.3;
x = xp+ A * rand(size(n));

[r, lags] = my_autocorr(x);

figure;

subplot(2,1,1);
stem(n, x, 'filled');
grid on;
title('Noisy signal x[n]');
xlabel('n');
ylabel('x[n]');

subplot(2,1,2);
stem(lags, r, 'filled');
grid on;
title('Autocorrelation of x[n]');
xlabel('Lag');
ylabel('\phi_x[n]');
