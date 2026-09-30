syms s;

t = 0:0.01:5;

num = [18 18];        % 18(s+1)
denum = conv([1 2], [1 7]);  % (s+2)(s+7)

H = tf(num, denum);

[y, t] = step(H);
y1 = 9/7 + (9/5)*exp(-2*t) - (108/35)*exp(-7*t);

plot(t, y);
hold on;
plot (t, y1);
legend('y1', 'y');


