close all; clear all; clc;
h = tf (7, [3 1 10]);
k = 7/10;
wn = sqrt (10/3);
df = 1/3/2/wn;
step(h);
hold on;

%% overshoot 
sigma = k*exp(-pi*df/sqrt(1-df^2)) 
 
%% peak value 
ymax = k*(1 + exp(-pi*df/sqrt(1-df^2))) 
 
%% time to first peak 
tmax = pi/wn/sqrt(1 - df^2) 
 
%% plot point at peak 
plot(tmax, ymax, '.b', 'MarkerSize', 20);shg 
 
%% vertical line through peak 
plot([tmax tmax], [0 ymax], '--');shg 
 
%% highlight steady-state value 
plot([0 tmax], [ymax ymax], '--');shg 
 
%% text formula for peak value 
s='$y_{max}=k(1+e^\frac{-\pi\xi}{\sqrt{1-\xi^2}})$' 
text(tmax+0.5, ymax, s, 'Interpreter', 'Latex', 'FontSize', 40);shg 
 
%% text formula for peak time 
s='$t_{max}=\frac{\pi}{\omega_n\sqrt{1-\xi^2}} $' 
text(tmax, 0.1, s, 'Interpreter', 'Latex', 'FontSize', 40); 
 
%% settling time 
ts = 4/df/wn; 
 
%% text formula for settling time 
s='$t_s=\frac{4}{\xi\omega_n}$'; 
text(ts, 0.1, s, 'Interpreter', 'Latex', 'FontSize', 40, 'FontWeight', 'bold') 
 
plot(ts, k, '.b', 'MarkerSize', 20); 
plot([ts ts], [0 k], '--'); 
 
%% steady state position error 
s = '$\epsilon_{ss}= |1 - y_{ss}|$'; 
text(ts, k + 0.15, s, 'Interpreter', 'Latex', 'FontSize', 40, 'FontWeight', 'bold') 
 
t = 1:0.1:50; 
hold on 
plot(t, ones(length(t), 1), '--') % unit step signal 
text(15, 1.05, 'unit step signal', 'FontSize', 20, 'FontWeight', 'bold') 
hold on