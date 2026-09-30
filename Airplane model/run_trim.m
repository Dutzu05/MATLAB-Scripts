%% run_trim.m -- find the straight-and-level trim condition
%
% Roadmap Section 15 item 4 / Section 13 check 3 (trim half). Solves for
% the three unknowns that make level flight at U0 an equilibrium:
%   alpha    -- trim angle of attack
%   delta_e  -- trim elevator deflection
%   delta_t  -- trim throttle setting
% by driving udot, wdot, qdot to zero via fsolve, with v=p=q=r=phi=0
% (symmetric, wings-level, steady flight) and theta=alpha (zero flight
% path angle -- level, not climbing or descending).
%
% This is a genuine trim solve, not a hand-specified force like Step 2 --
% it is the first time the Aerodynamics + Propulsion subsystems actually
% talk to the EOM.

notus = build_ac_struct();

trim_fun = @(unk) trim_residual(unk, notus);

unk0 = [0.02; 0.0; 0.2];   % initial guess: alpha=0.02 rad, delta_e=0, throttle=20%
opts = optimoptions('fsolve','Display','off','FunctionTolerance',1e-12);
[unk_sol, resnorm, exitflag] = fsolve(trim_fun, unk0, opts);

alpha_trim = unk_sol(1);
delta_e_trim = unk_sol(2);
delta_t_trim = unk_sol(3);

fprintf('\n=== Trim solution (level flight at U0 = %.1f m/s) ===\n', notus.U0);
fprintf('  alpha_trim   = %.5f rad (%.3f deg)\n', alpha_trim, rad2deg(alpha_trim));
fprintf('  delta_e_trim = %.5f rad (%.3f deg)\n', delta_e_trim, rad2deg(delta_e_trim));
fprintf('  delta_t_trim = %.4f (%.1f%% throttle)\n', delta_t_trim, 100*delta_t_trim);
fprintf('  fsolve exitflag = %d (1 = converged), residual norm = %.3e\n\n', exitflag, resnorm);

theta_trim = alpha_trim;   % level flight: flight path angle gamma = theta - alpha = 0
u_trim = notus.U0*cos(alpha_trim);
w_trim = notus.U0*sin(alpha_trim);
x0_trim = [u_trim; 0; w_trim; 0; 0; 0; 0; theta_trim; 0; 0; 0; 0];   % full 12-state trim vector
