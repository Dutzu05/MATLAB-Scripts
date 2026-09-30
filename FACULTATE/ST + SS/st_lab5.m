clear all 
R=1e3;C=1e-6;L=4; 
A=[-1/R/C -1/C;1/L 0];B=[1/R/C;0];C=[1 0];D=0; 
eig(A)% the eigen values 
syms s 
fm=inv(s*eye(2)-A)% fundamental matrix 
tm=ilaplace(fm)% transition matrix 
collect(simplify(tm),'t')

