n = 0:10;
x1 = exp(-0.1*pi*n);
x2 = cos(pi*n);

prod = x1 .* x2;

stem(n, x1, 'b', 'filled')
hold on
stem(n, prod, 'r', 'filled')

xlabel('n')
ylabel('Amplitude')
title('Semnale discrete')
grid on