function [CL, CD, CY, Cl, Cm, Cn] = aero_coeffs( ...
    alpha, beta, p, q, r, delta_e, delta_a, delta_r, Uref, ac)
%AERO_COEFFS  Linear stability-derivative aerodynamic coefficient buildup.
%
% Source: Roadmap Section 7 ("linear derivative model" track), built
% from Way Sec.6.3.8 and Tewari Sec.4.3.
%
% IMPORTANT CONVENTION: alpha, beta, p, q, r, delta_e, delta_a, delta_r
% are all treated as PERTURBATIONS from the trimmed reference flight
% condition (Tewari's small-disturbance framework, Ch.4) -- NOT
% absolute geometric angles. This matters for two things:
%   1. CL's constant term is ac.CLe_trim (the nonzero trim lift
%      coefficient, e.g. from Step 1's CL_trim = W/(q0*S)).
%   2. Cm's constant term is EXACTLY ZERO, not ac.Cm0. At trim, moments
%      balance by definition (Tewari: "Cme = 0 for equilibrium",
%      Sec.4.3.1). init.m's Cm0 = 0.02 is the zero-alpha/zero-elevator
%      moment for an ABSOLUTE-angle formulation, which is a different
%      (and, for this perturbation model, unused) quantity -- it is
%      intentionally NOT added here. See Step 3 build-log note.
%
% Inputs:
%   alpha, beta       -- angle-of-attack / sideslip perturbation, rad
%   p, q, r           -- body rate perturbation, rad/s
%   delta_e/a/r       -- control surface deflection perturbation, rad
%   Uref              -- reference airspeed for rate non-dimensionalization, m/s
%   ac                -- struct with fields: CLe_trim, CLalpha, CD0, K,
%                        Cmalpha, Cmq, CLq, CLdelta_e, Cmdelta_e, CYbeta,
%                        Clbeta, Cnbeta, Clp, Clr, Cnp, Cnr, CYp, CYr,
%                        Cldelta_a, Cndelta_a, Cndelta_r, CYdelta_r, c, b
%
% Outputs: CL, CD, CY, Cl, Cm, Cn  (all dimensionless coefficients)

qhat = q * ac.c / (2*Uref);   % Tewari Eq.4.41
phat = p * ac.b / (2*Uref);
rhat = r * ac.b / (2*Uref);

CL = ac.CLe_trim + ac.CLalpha*alpha + ac.CLq*qhat + ac.CLdelta_e*delta_e;
CD = ac.CD0 + ac.K*CL^2;                                                    % Way Eq.4.33 drag polar

CY = ac.CYbeta*beta + ac.CYp*phat + ac.CYr*rhat + ac.CYdelta_r*delta_r;
Cl = ac.Clbeta*beta + ac.Clp*phat + ac.Clr*rhat + ac.Cldelta_a*delta_a;
    % NOTE: a Cldelta_r (roll-due-to-rudder) term is omitted -- init.m
    % does not define one, and it is typically small; add it if/when
    % real data is available.
Cm = ac.Cmalpha*alpha + ac.Cmq*qhat + ac.Cmdelta_e*delta_e;                 % Cme = 0 at trim, see note above
Cn = ac.Cnbeta*beta + ac.Cnp*phat + ac.Cnr*rhat + ac.Cndelta_a*delta_a + ac.Cndelta_r*delta_r;
end
