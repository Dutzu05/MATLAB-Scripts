function res = trim_residual(unk, notus)
%TRIM_RESIDUAL  Residual [udot;wdot;qdot] for the level-flight trim solve.
% Broken out as its own function file (rather than a local function
% inside run_trim.m) specifically so other scripts -- e.g. Step 4's
% verification script -- can call it too; MATLAB local functions defined
% inside one script are not visible to a different script.
%
% unk = [alpha; delta_e; delta_t]

alpha = unk(1); delta_e = unk(2); delta_t = unk(3);
theta = alpha;   % level flight: flight path angle gamma = theta - alpha = 0
u = notus.U0*cos(alpha); w = notus.U0*sin(alpha);
x9 = [u;0;w; 0;0;0; 0;theta;0];
FM = total_forces_moments(x9, delta_e, 0, 0, delta_t, notus);
xdot = eom_derivs(0, [x9;0;0;0], @(t,x) FM, notus.eom);
res = [xdot(1); xdot(3); xdot(5)];   % udot, wdot, qdot
end
