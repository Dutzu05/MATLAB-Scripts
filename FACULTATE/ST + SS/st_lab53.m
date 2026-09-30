R=3; C=1/9; L=9/2; 
A=[-1/R/C -1/C; 1/L 0];

eig(A)

t = linspace(0,3,1000);

tm11 = -exp(-2*t).*(exp(t) - 2);
tm12 = -9*exp(-2*t).*(exp(t) - 1);
tm21 = (2*exp(-2*t).*(exp(t) - 1))/9;
tm22 = 2*exp(-t) - exp(-2*t); % FIXED

x01=0.001; 
x02=0.01;

x1 = tm11*x01 + tm12*x02;
x2 = tm21*x01 + tm22*x02;

plot(x1,x2,'r','LineWidth',2);
hold on

[x1g,x2g] = meshgrid(-0.025:0.0045:0.0025, 0.0015:0.0015:0.011);

x1d = A(1,1)*x1g + A(1,2)*x2g;
x2d = A(2,1)*x1g + A(2,2)*x2g;

quiver(x1g,x2g,x1d,x2d,'b');

grid on