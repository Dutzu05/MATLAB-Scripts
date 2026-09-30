%% verify_step03_aero.m -- Verification for Step 3 (Aerodynamics subsystem)
%
% Roadmap Section 13, check #2: "reproduce Tewari's worked numeric
% examples (4.1, 4.3, 4.4) exactly, using the same input numbers, to
% confirm our coefficient block is not just plausible but numerically
% correct against a textbook answer key."
%
% Part A tests aero_derivative_formulas.m -- the CLalpha/Cmalpha
%   semi-empirical buildup -- against Tewari's worked Example 4.1
%   (a completely different, 10,000 kg airliner-class aircraft; the
%   point is NOT to match our UAV, it's to prove the formulas
%   themselves are coded correctly, using a case with a published
%   correct answer).
% Part B sanity-checks aero_coeffs.m -- the full linear coefficient
%   buildup used by the actual Aerodynamics subsystem -- against our
%   own NOTUS surrogate parameters from init.m.

init;   % load NOTUS parameter set once, up front (init.m clears the
        % workspace -- must run before any of this script's own
        % bookkeeping variables are created, or they'd be wiped too)

fprintf('\n=== Step 3 Verification: Aerodynamics subsystem ===\n\n');
pass = true;
tol_pct = 0.5;   % percent tolerance for the textbook comparison

%% ---------------------------------------------------------------
%% Part A: reproduce Tewari Example 4.1 (Sec.4.3.1.2)
%% ---------------------------------------------------------------
fprintf('--- Part A: Tewari Example 4.1 (textbook answer key) ---\n\n');

% Given data (Example 4.1 statement, all inputs -- unrelated to NOTUS)
m_ex   = 10000;     % kg
S_ex   = 50;        % m^2
c_ex   = 3;         % m
St_ex  = 10;        % m^2
V_ex   = 500*1000/3600;   % m/s (500 km/h)
rho_ex = 1.225;      % kg/m^3, standard sea level
CLalpha_wf_ex = 0.1;  % per deg
CLalpha_t_ex  = 0.08; % per deg
eta_ex = 0.96;
deps_dalpha_ex = 0.4;
xbar_minus_xbarwf_ex = 0.1;    % CG 10% MAC aft of wing-fuselage a.c.
tail_arm_m_ex = 8.5;            % distance between wing and tail a.c., m

Vt_ex = (St_ex/S_ex) * (tail_arm_m_ex/c_ex);

% Trivial checks: dynamic pressure and equilibrium lift coefficient
qbar_ex = 0.5*rho_ex*V_ex^2;
CLe_ex  = (m_ex*9.81) / (qbar_ex*S_ex);

qbar_book = 11815.2;
CLe_book  = 0.166057;
Vt_book   = 0.566667;

fprintf('  qbar: computed = %.1f   book = %.1f   (%.3f%% diff)\n', ...
        qbar_ex, qbar_book, 100*abs(qbar_ex-qbar_book)/qbar_book);
fprintf('  CLe:  computed = %.6f   book = %.6f   (%.3f%% diff)\n', ...
        CLe_ex, CLe_book, 100*abs(CLe_ex-CLe_book)/CLe_book);
fprintf('  Vt:   computed = %.6f   book = %.6f   (%.3f%% diff)\n\n', ...
        Vt_ex, Vt_book, 100*abs(Vt_ex-Vt_book)/Vt_book);

% The real payload: CLalpha, static margin, Cmalpha via aero_derivative_formulas.m
[CLalpha_ex, Cmalpha_ex, sm_ex] = aero_derivative_formulas( ...
    CLalpha_wf_ex, CLalpha_t_ex, eta_ex, St_ex/S_ex, deps_dalpha_ex, ...
    xbar_minus_xbarwf_ex, Vt_ex);

CLalpha_book = 0.10922;     % per deg
sm_book      = 0.1391;      % fraction of MAC
Cmalpha_book = -0.01519;    % per deg

err_CLalpha = 100*abs(CLalpha_ex-CLalpha_book)/abs(CLalpha_book);
err_sm      = 100*abs(sm_ex-sm_book)/abs(sm_book);
err_Cmalpha = 100*abs(Cmalpha_ex-Cmalpha_book)/abs(Cmalpha_book);

fprintf('  CLalpha:       computed = %.5f /deg   book = %.5f /deg   (%.3f%% diff)\n', ...
        CLalpha_ex, CLalpha_book, err_CLalpha);
fprintf('  static margin: computed = %.4f        book = %.4f        (%.3f%% diff)\n', ...
        sm_ex, sm_book, err_sm);
fprintf('  Cmalpha:       computed = %.5f /deg   book = %.5f /deg   (%.3f%% diff)\n', ...
        Cmalpha_ex, Cmalpha_book, err_Cmalpha);

okA = (100*abs(qbar_ex-qbar_book)/qbar_book < tol_pct) && ...
      (100*abs(CLe_ex-CLe_book)/CLe_book < tol_pct) && ...
      (100*abs(Vt_ex-Vt_book)/Vt_book < tol_pct) && ...
      (err_CLalpha < tol_pct) && (err_sm < tol_pct) && (err_Cmalpha < tol_pct);

fprintf('\n  [%s] -- all values match the published example to within %.1f%%\n\n', ...
        ternary(okA,'PASS','FAIL'), tol_pct);
pass = pass && okA;

%% ---------------------------------------------------------------
%% Part B: sanity-check aero_coeffs.m against our NOTUS surrogate
%% ---------------------------------------------------------------
fprintf('--- Part B: aero_coeffs.m sanity check on NOTUS surrogate ---\n\n');

ac2.CLe_trim = W/(q0*S);   % trim lift coefficient (Step 1 result, recomputed here)
ac2.CLalpha = CLalpha; ac2.CD0 = CD0; ac2.K = K;
ac2.Cmalpha = Cmalpha; ac2.Cmq = Cmq; ac2.CLq = CLq;
ac2.CLdelta_e = CLdelta_e; ac2.Cmdelta_e = Cmdelta_e;
ac2.CYbeta = CYbeta; ac2.Clbeta = Clbeta; ac2.Cnbeta = Cnbeta;
ac2.Clp = Clp; ac2.Clr = Clr; ac2.Cnp = Cnp; ac2.Cnr = Cnr;
ac2.CYp = CYp; ac2.CYr = CYr;
ac2.Cldelta_a = Cldelta_a; ac2.Cndelta_a = Cndelta_a; ac2.Cndelta_r = Cndelta_r;
ac2.CYdelta_r = CYdelta_r; ac2.c = c; ac2.b = b;

% Test B1: exactly at trim (alpha=beta=p=q=r=0, all controls neutral) --
% CL must equal the Step-1 trim CL, and Cm must be exactly zero.
[CL0, CD0_out, ~, ~, Cm0_out, ~] = aero_coeffs(0,0,0,0,0, 0,0,0, U0, ac2);
fprintf('Test B1 (at trim): CL = %.4f (expect CLe_trim = %.4f), Cm = %.2e (expect 0)\n', ...
        CL0, ac2.CLe_trim, Cm0_out);
okB1 = abs(CL0-ac2.CLe_trim) < 1e-10 && abs(Cm0_out) < 1e-10;
fprintf('  [%s]\n\n', ternary(okB1,'PASS','FAIL'));

% Test B2: positive alpha perturbation must produce a NEGATIVE (restoring)
% pitching moment -- the numerical signature of static stability.
alpha2 = deg2rad(2);
[CL2, CD2, ~, ~, Cm2, ~] = aero_coeffs(alpha2,0,0,0,0, 0,0,0, U0, ac2);
fprintf('Test B2 (alpha = +2 deg): CL = %.4f, CD = %.4f, Cm = %.4f\n', CL2, CD2, Cm2);
okB2 = Cm2 < 0 && CL2 > CL0 && CD2 > CD0_out;
fprintf('  [%s] -- restoring moment, higher lift, higher (induced) drag, all as expected\n\n', ...
        ternary(okB2,'PASS','FAIL'));

pass = pass && okB1 && okB2;

fprintf('=== Overall Step 3 result: %s ===\n\n', ...
        ternary(pass,'PASS','FAIL -- fix flagged items before Step 4'));

function out = ternary(cond, a, b)
    if cond
        out = a;
    else
        out = b;
    end
end
