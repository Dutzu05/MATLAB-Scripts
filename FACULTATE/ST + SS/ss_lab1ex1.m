t = -10:0.01:10;

x1 = zeros(size(t));

x1(t>=0 & t<=4) = -t(t>=0 & t<=4) + 2;
x1(t>=-4 & t<0) = -t(t>=-4 & t<0) - 2;

subplot (2, 2, 1)
plot(t, x1);
title('Piecewise Function x1');
xlabel('Time (t)');
ylabel('x1(t)');
grid on;

subplot (2,2, 2);
plot (t, interp1(t, x1, t-1, 'linear', 0))
title('x1(t-1');

n = -10:10;
x2 = zeros(size(n));
x2(n >= 0 & n <= 4) = -n(n >= 0 & n <= 4) + 1;
x2(n >= -4 & n < 0) = -n(n >= -4 & n < 0) - 1;

subplot(2, 2, 3)
stem(n, x2, "filled")
title('x2')

subplot(2, 2, 4);
stem(n, interp2(n, x2, n-1, 'nearest', 0), 'filled');
title('x2(n-1)');
xlabel('n');
ylabel('x2(n-1)');

subplot(2,2,5)
stem(n, interp1(n, x2, n+1, 'nearest', 0), 'filled')
title('x2[n+1]')

subplot(2,2,6)
stem(n, x2(ismember(n,2*n)), 'filled')
title('x2[2n]')

grid on;