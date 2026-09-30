%% verify_step04_trim_modes.m -- Verification for Step 4
%
% Roadmap Section 13, check 3: trim + linearized eigenvalue extraction,
% compared against the *qualitative* pattern reported for the Giant III
% (Sandoval et al. Sec.5.3: short period settles in ~1 s, phugoid takes
% minutes) and MAK2 (thesis: "heavily damped SPPO... lightly damped
% phugoid... unstable in spiral mode").

fprintf('\n=== Step 4 Verification: trim + linearized modes ===\n\n');
pass = true;

%% Part A: trim solution sanity
linearize_model;   % runs run_trim.m internally, then linearizes -- this
                    % single call produces everything Part A and B need

fprintf('\n--- Part A: trim solution sanity ---\n');
res_check = trim_residual([alpha_trim; delta_e_trim; delta_t_trim], notus);
fprintf('  residual [udot wdot qdot] at reported trim = [%.2e %.2e %.2e]\n', res_check);
okA1 = max(abs(res_check)) < 1e-6;

okA2 = abs(rad2deg(alpha_trim)) < 10;                 % plausible trim AoA
okA3 = delta_t_trim > 0 && delta_t_trim < 1;           % throttle in a sensible range
okA4 = abs(delta_e_trim) < notus.limits.delta_e_max;   % within control surface limit (init.m, Step 1)

fprintf('  alpha_trim = %.3f deg (plausible if |.|<10 deg): %s\n', rad2deg(alpha_trim), ternary(okA2,'PASS','FAIL'));
fprintf('  delta_t_trim = %.1f%% throttle (plausible if in 0-100%%): %s\n', 100*delta_t_trim, ternary(okA3,'PASS','FAIL'));
fprintf('  delta_e_trim = %.3f deg (within +/-%.0f deg limit): %s\n', rad2deg(delta_e_trim), rad2deg(notus.limits.delta_e_max), ternary(okA4,'PASS','FAIL'));
okA = okA1 && okA2 && okA3 && okA4;
fprintf('  Trim residual near zero: %s\n', ternary(okA1,'PASS','FAIL'));
pass = pass && okA;

%% Part B: qualitative mode classification
fprintf('\n--- Part B: qualitative mode signature check ---\n');

% eig_long has two complex-conjugate pairs: short period (fast, high
% |imag|) and phugoid (slow, low |imag|). Sort by |imag| descending.
[~, order] = sort(abs(imag(eig_long)), 'descend');
sp = eig_long(order(1));     % short period (one of the pair; conjugate has same |.|)
ph = eig_long(order(3));     % phugoid

zeta_sp = -real(sp)/abs(sp);
zeta_ph = -real(ph)/abs(ph);
period_sp = 2*pi/abs(imag(sp));
period_ph = 2*pi/abs(imag(ph));

fprintf('  Short period: zeta=%.3f, period=%.2f s\n', zeta_sp, period_sp);
fprintf('  Phugoid:      zeta=%.3f, period=%.2f s\n', zeta_ph, period_ph);

okB1 = zeta_sp > 0.3 && period_sp < 5;        % "heavily damped, fast" (Sandoval: ~1s to settle)
okB2 = zeta_ph < 0.3 && period_ph > period_sp; % "lightly damped, slow" (Sandoval/MAK2: tens of seconds+)
fprintf('  Short period heavily damped & fast (Sandoval Sec.5.3 signature): %s\n', ternary(okB1,'PASS','FAIL'));
fprintf('  Phugoid lightly damped & slow (Sandoval/MAK2 signature): %s\n', ternary(okB2,'PASS','FAIL'));

% Lateral-directional: expect one fast real root (roll subsidence), one
% lightly-damped complex pair (Dutch roll), one slow real root (spiral,
% sign not asserted -- MAK2 found it unstable, and the roadmap already
% flags that spiral instability is common and not a modelling bug).
real_roots = real(eig_lat(abs(imag(eig_lat)) < 1e-8));   % strip negligible numerical imaginary residue
complex_roots = eig_lat(abs(imag(eig_lat)) >= 1e-8);
fprintf('  Real roots (roll subsidence + spiral): ');
fprintf('%.4f  ', real_roots); fprintf('\n');
fprintf('  Complex pair (Dutch roll): %.4f %+.4fi\n', real(complex_roots(1)), imag(complex_roots(1)));

okB3 = numel(real_roots) == 2 && numel(complex_roots) == 2;
fprintf('  Mode count matches expected lateral-directional structure (2 real + 1 complex pair): %s\n', ...
        ternary(okB3,'PASS','FAIL'));
if numel(real_roots) == 2
    [~, ix] = min(abs(real_roots));   % spiral = the slower (smaller |real part|) of the two real roots
    spiral_root = real_roots(ix);
    if spiral_root < 0
        spiral_desc = sprintf('stable, time constant %.1f s', 1/abs(spiral_root));
    else
        spiral_desc = sprintf('unstable, time to double ~%.1f s', log(2)/spiral_root);
    end
    fprintf('  Spiral mode: %s (either sign is plausible for this class, per Roadmap Sec.13)\n', spiral_desc);
end

pass = pass && okB1 && okB2 && okB3;

fprintf('\n=== Overall Step 4 result: %s ===\n\n', ...
        ternary(pass,'PASS','FAIL -- fix flagged items before Step 5'));

function out = ternary(cond, a, b)
    if cond
        out = a;
    else
        out = b;
    end
end
