n = -5:50;
% u[n]

u = double(n >= 0);

% g[n]

g = (1/2).^n .* double (n >= 1);

% plot u[n]

subplot(2, 1, 1)
stem(n, u, 'filled')
xlabel('n')
ylabel('u[n]')
title('Semnalul u[n]')
grid on

% plot g[n]

subplot(2, 1, 2)
stem(n, g, 'filled')
xlabel('n')
ylabel('g[n]')
title('Semnalul g[n]')
grid on