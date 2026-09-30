%% verify_step02_eom.m -- Verification for Step 2 (6-DOF EOM, isolated)
%
% Roadmap Section 13, check #1: "trim a straight-and-level flight
% condition by hand/fsolve, confirm the six rate-of-change states are
% zero at trim; step-response sanity checks (e.g., a pure Iyy*qdot=M
% with a step M should integrate to the expected q(t))."
%
% Three closed-form checks, each with an exact analytical answer we can
% verify by hand, run against the numerical ode45 integration of
% eom_derivs.m:
%
%   Test A -- Straight-and-level equilibrium. If the total external
%             force exactly balances gravity and there is no moment,
%             every rate and angle must stay EXACTLY constant forever
%             (only position should change). This is the purest test
%             that the force/moment bookkeeping and axis conventions
%             are right.
%   Test B -- Pure pitch-moment step. With p=r=0 and Ixz=0, the pitch
%             moment equation collapses exactly to qdot = M/Iyy -- a
%             trivial constant-acceleration problem with a closed-form
%             solution, independent of every other coupling term in the
%             equations. If Simulink/ode45 doesn't reproduce this
%             exactly, the moment equation has a bug.
%   Test C -- Same idea for roll: pdot = L/Ixx when q=r=0, Ixz=0.

init;                                   % load parameter set
ac.m = m; ac.Ixx = Ixx; ac.Iyy = Iyy; ac.Izz = Izz; ac.Ixz = Ixz; ac.g0 = g0;

fprintf('\n=== Step 2 Verification: 6-DOF EOM subsystem (isolated) ===\n\n');
pass = true;
tol_state = 1e-6;
tol_step  = 1e-4;

%% Test A: straight-and-level trim equilibrium
W = m*g0;
FM_trimA = @(t,x) [0; 0; -W; 0; 0; 0];      % Fz=-W balances gravity at phi=theta=0
x0A = [U0;0;0; 0;0;0; 0;0;0; 0;0;0];
[tA, xA] = ode45(@(t,x) eom_derivs(t,x,FM_trimA,ac), [0 5], x0A);

dev = max(abs(xA(:,1:9) - x0A(1:9)'), [], 1);   % u..psi should not move at all
fprintf('Test A (straight-and-level equilibrium):\n');
fprintf('  max deviation over 5 s in [u v w p q r phi theta psi] = %.2e\n', max(dev));
if max(dev) < tol_state
    fprintf('  [PASS] -- aircraft holds trim exactly under balanced force/moment\n');
else
    fprintf('  [FAIL] -- state drifted from trim, check EOM implementation\n');
    pass = false;
end
fprintf('  xE(end) = %.3f m  (expected U0*t = %.3f m, straight-line flight)\n\n', ...
        xA(end,10), U0*tA(end));

%% Test B: pure pitch-moment step, qdot = M/Iyy closed form
M_step = 0.5;                                % N*m
FM_stepB = @(t,x) [0;0;0; 0;M_step;0];
x0B = zeros(12,1);
[tB, xB] = ode45(@(t,x) eom_derivs(t,x,FM_stepB,ac), [0 2], x0B);

q_num = xB(end,5);      theta_num = xB(end,8);
q_exact = (M_step/ac.Iyy)*tB(end);
theta_exact = (M_step/(2*ac.Iyy))*tB(end)^2;

fprintf('Test B (pure pitch-moment step, M = %.2f N*m):\n', M_step);
fprintf('  q(t_end):     numerical = %.5f   exact = %.5f  rad/s\n', q_num, q_exact);
fprintf('  theta(t_end): numerical = %.5f   exact = %.5f  rad\n', theta_num, theta_exact);
okB = abs(q_num-q_exact) < tol_step && abs(theta_num-theta_exact) < tol_step;
fprintf('  [%s]\n\n', ternary(okB,'PASS','FAIL'));
pass = pass && okB;

%% Test C: pure roll-moment step, pdot = L/Ixx closed form
L_step = 0.3;                                % N*m
FM_stepC = @(t,x) [0;0;0; L_step;0;0];
x0C = zeros(12,1);
[tC, xC] = ode45(@(t,x) eom_derivs(t,x,FM_stepC,ac), [0 2], x0C);

p_num = xC(end,4);      phi_num = xC(end,7);
p_exact = (L_step/ac.Ixx)*tC(end);
phi_exact = (L_step/(2*ac.Ixx))*tC(end)^2;

fprintf('Test C (pure roll-moment step, L = %.2f N*m):\n', L_step);
fprintf('  p(t_end):   numerical = %.5f   exact = %.5f  rad/s\n', p_num, p_exact);
fprintf('  phi(t_end): numerical = %.5f   exact = %.5f  rad\n', phi_num, phi_exact);
okC = abs(p_num-p_exact) < tol_step && abs(phi_num-phi_exact) < tol_step;
fprintf('  [%s]\n\n', ternary(okC,'PASS','FAIL'));
pass = pass && okC;

fprintf('=== Overall Step 2 result: %s ===\n\n', ...
        ternary(pass,'PASS','FAIL -- fix flagged items before Step 3'));

%% Plots -- visual cross-check, and useful reference traces for when you
%% reproduce the same three tests inside the Simulink model.
figure('Name','Step 2 Verification: EOM isolated tests');

subplot(2,2,1);
plot(tB, xB(:,5), 'b-', tB, (M_step/ac.Iyy)*tB, 'r--');
xlabel('t [s]'); ylabel('q [rad/s]'); legend('numerical','exact','Location','northwest');
title('Test B: pitch rate');

subplot(2,2,2);
plot(tB, xB(:,8), 'b-', tB, (M_step/(2*ac.Iyy))*tB.^2, 'r--');
xlabel('t [s]'); ylabel('\theta [rad]'); legend('numerical','exact','Location','northwest');
title('Test B: pitch angle');

subplot(2,2,3);
plot(tC, xC(:,4), 'b-', tC, (L_step/ac.Ixx)*tC, 'r--');
xlabel('t [s]'); ylabel('p [rad/s]'); legend('numerical','exact','Location','northwest');
title('Test C: roll rate');

subplot(2,2,4);
plot(tC, xC(:,7), 'b-', tC, (L_step/(2*ac.Ixx))*tC.^2, 'r--');
xlabel('t [s]'); ylabel('\phi [rad]'); legend('numerical','exact','Location','northwest');
title('Test C: roll angle');

function out = ternary(cond, a, b)
    if cond
        out = a;
    else
        out = b;
    end
end
