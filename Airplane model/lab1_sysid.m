u = [zeros(10, 1); 0.5*ones(1000, 1)];
[vel, alpha, t] = DCMRun.run(u, 'COM6', 'Ts', 1e-3, 'type', 'windows')
plot(t, vel);