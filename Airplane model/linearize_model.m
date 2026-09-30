%% linearize_model.m -- numerical linearization at trim, mode extraction
%
% Roadmap Section 13 check 3: "linmod/linearize() at trim -> eigenvalues
% -> compare mode shapes/frequencies against the expected qualitative
% pattern." This uses a numerical (central-difference) Jacobian instead
% of Simulink's linmod/linearize -- mathematically identical, and it
% works whether or not you have built the Simulink EOM subsystem yet
% (Step 2 gave manual build instructions, not a guaranteed-built model).
% Once your Simulink model exists, running linmod() there and comparing
% the resulting A-matrix eigenvalues against this script's is a good
% independent cross-check.

run_trim;   % gets notus, alpha_trim, delta_e_trim, delta_t_trim, x0_trim

x9_trim = x0_trim(1:9);

n = 9;
A = zeros(n,n);
epsn = 1e-6;
for j = 1:n
    dx = zeros(n,1); dx(j) = epsn;
    A(:,j) = (deriv9(x9_trim+dx, delta_e_trim, delta_t_trim, notus) ...
             - deriv9(x9_trim-dx, delta_e_trim, delta_t_trim, notus)) / (2*epsn);
end

% State ordering: [u v w p q r phi theta psi]  (indices 1-9)
long_idx = [1 3 5 8];   % u, w, q, theta
lat_idx  = [2 4 6 7];   % v, p, r, phi

A_long = A(long_idx, long_idx);
A_lat  = A(lat_idx, lat_idx);

eig_long = eig(A_long);
eig_lat  = eig(A_lat);

fprintf('=== Longitudinal modes (u, w, q, theta) ===\n');
print_modes(eig_long);

fprintf('\n=== Lateral-directional modes (v, p, r, phi) ===\n');
print_modes(eig_lat);

function xd9 = deriv9(x9, delta_e_trim, delta_t_trim, notus)
    FM = total_forces_moments(x9, delta_e_trim, 0, 0, delta_t_trim, notus);
    xdot12 = eom_derivs(0, [x9;0;0;0], @(t,x) FM, notus.eom);
    xd9 = xdot12(1:9);
end

function print_modes(ev)
    for k = 1:length(ev)
        lam = ev(k);
        if abs(imag(lam)) > 1e-8
            wn = abs(lam);
            zeta = -real(lam)/wn;
            fprintf('  %+.4f %+.4fi   (wn=%.3f rad/s, zeta=%.4f, period=%.2f s)\n', ...
                real(lam), imag(lam), wn, zeta, 2*pi/abs(imag(lam)));
        else
            tau = -1/real(lam);
            fprintf('  %+.4f            (real root, time constant = %.2f s)\n', real(lam), tau);
        end
    end
end
