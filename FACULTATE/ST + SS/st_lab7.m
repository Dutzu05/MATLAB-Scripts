syms s;

t = 0:0.01:5;

num = [0 3 1];

denum = [0.2 1.6 3];

H = tf(num, denum); % Create transfer function
[y, t] = step(H);
y1 = 1/3 + 20/3 * exp(-3 * t) - 7 * exp(-5 * t);
plot (t, y1);
hold on;
plot (t, y); legend('y1', 'y');
