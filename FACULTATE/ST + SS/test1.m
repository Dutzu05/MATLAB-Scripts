n = 0:10;

x1 = exp(-0.1*pi*n);
x2 = cos(pi*n);
z  = x1 .* x2;

stem(n, x1, 'b', 'DisplayName', 'x1[n]');
hold on;
stem(n, z, 'r', 'DisplayName', 'x1[n]*x2[n]');

xlabel('n');
legend;
grid on;