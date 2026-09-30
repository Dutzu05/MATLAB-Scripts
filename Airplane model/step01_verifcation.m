%% verify_step01_parameters.m -- Verification for Step 1 (init.m)
%
% Per the project's mandated Data -> Math -> Architecture -> Verification
% cycle (Roadmap Section 13, check #1 is EOM trim; this is the check
% that has to pass BEFORE the EOM even exists -- confirming the raw
% parameter set itself is physically self-consistent).
%
% What this checks:
%   1. Trim CL is a plausible cruise value (typically 0.3-0.8 for this
%      aircraft class).
%   2. The Reynolds number computed from OUR geometry estimate (S, c
%      derived from an assumed AR=6) reproduces Sandoval et al.'s
%      independently reported flight-test Reynolds number (~550,000,
%      Sec.3.1). This is a genuine external consistency check: b, m,
%      and U0 are directly sourced; c is estimated; if the resulting
%      Re lands close to the paper's own number, that is evidence the
%      AR assumption is reasonable, not just convenient.
%   3. Basic sign/magnitude sanity on the stability derivatives (static
%      stability requires Cmalpha < 0, Cnbeta > 0, etc.)

init;   % load the parameter set

fprintf('\n=== Step 1 Verification: parameter self-consistency ===\n\n');

pass = true;

%% Check 1: trim CL plausibility
CL_trim = W / (q0 * S);
fprintf('1) Trim CL = %.4f  ', CL_trim);
if CL_trim > 0.25 && CL_trim < 0.9
    fprintf('[PASS] -- plausible cruise CL for this aircraft class\n');
else
    fprintf('[FAIL] -- outside plausible cruise CL range (0.25-0.9)\n');
    pass = false;
end

%% Check 2: Reynolds number cross-check against Sandoval et al. Sec.3.1
Re_reported = 550000;   % [SOURCE: Sandoval et al., Sec.3.1 -- "The Reynolds number was about 550 000"]
Re_error_pct = 100 * abs(Re0 - Re_reported) / Re_reported;
fprintf('2) Re0 = %.0f vs. reported ~%.0f (%.1f%% difference)  ', Re0, Re_reported, Re_error_pct);
if Re_error_pct < 10
    fprintf('[PASS] -- geometry estimate (AR=%.1f) is consistent with flight-test Re\n', AR);
else
    fprintf('[FAIL] -- geometry estimate does not reproduce reported Re, revisit AR assumption\n');
    pass = false;
end

%% Check 3: static stability sign checks
fprintf('3) Static stability signs:\n');
checks = {
    'Cmalpha < 0 (longitudinal static stability)', Cmalpha < 0;
    'Cnbeta  > 0 (directional/weathercock stability)', Cnbeta > 0;
    'Clbeta  < 0 (dihedral effect, positive roll stability)', Clbeta < 0;
    'Cmq     < 0 (positive pitch damping)', Cmq < 0;
    'Clp     < 0 (positive roll damping)', Clp < 0;
    'Cnr     < 0 (positive yaw damping)', Cnr < 0;
};
for i = 1:size(checks,1)
    ok = checks{i,2};
    fprintf('   - %s: %s\n', checks{i,1}, ternary(ok, 'PASS', 'FAIL'));
    pass = pass && ok;
end

%% Check 4: weight and inertia sanity (all positive, Ixx/Iyy/Izz triangle-ish)
fprintf('4) Mass property sanity:  ');
mass_ok = (m > 0) && (Ixx > 0) && (Iyy > 0) && (Izz > 0) && (Izz > Ixx) && (Izz > Iyy);
if mass_ok
    fprintf('[PASS] -- Ixx=%.3f, Iyy=%.3f, Izz=%.3f kg*m^2, Izz is largest as expected\n', Ixx, Iyy, Izz);
else
    fprintf('[FAIL] -- inertia values not physically sensible\n');
    pass = false;
end

fprintf('\n=== Overall Step 1 result: %s ===\n\n', ternary(pass, 'PASS', 'FAIL -- fix flagged items before Step 2'));

function out = ternary(cond, a, b)
    if cond
        out = a;
    else
        out = b;
    end
end