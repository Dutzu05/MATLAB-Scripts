clc; clear; close all;


n = -10:10;

u = @(n) double(n >= 0);

% original signal

x = (n/2) .* (u(n+4) - u(n-5))

xa = ((2-n) / 2) .* (u(2 - n + 4) - u(2 - n - 5));
xb = ((n+2)/2) .* (u(n+2+4) - u(n+2-5));
xc = ((-n)/2) .* (u(-n+4) - u(-n-5)) .* u(n) + x;
xd1 = ((n+2)/2) .* (u(n+2 + 4) - u(n+2 -5));
xd2 = ((-1-n)/2) .* (u(-1-n +4) - u(-1-n-5));
xd = xd1 + xd2;

%e) x[3n]*δ[n − 1]

xe = zeros(size(n));
xe(n == 1) = (3/2);

xf = ((n+1)/2) .* (u(n+1+4) - u(n+1 -5)) .* (u(n+3) - u(-n));
xg = x .* (u(n-4) - u(n-3));

figure;

subplot(4,2,1)
stem(n, x, 'filled'); title('x[n]'); grid on;

subplot(4,2,2)
stem(n, xa, 'filled'); title('x[2-n]'); grid on;

subplot(4,2,3)
stem(n, xb, 'filled'); title('x[n+2]'); grid on;

subplot(4,2,4)
stem(n, xc, 'filled'); title('x[-n]u[n] + x[n]'); grid on;

subplot(4,2,5)
stem(n, xd, 'filled'); title('x[n+2] + x[-1-n]'); grid on;

subplot(4,2,6)
stem(n, xe, 'filled'); title('x[3n]\delta[n-1]'); grid on;

subplot(4,2,7)
stem(n, xf, 'filled'); title('x[n+1](u[n+3]-u[-n])'); grid on;

subplot(4,2,8)
stem(n, xg, 'filled'); title('(u[n-4]-u[n-3])x[n]'); grid on;

