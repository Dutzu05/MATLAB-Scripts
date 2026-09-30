function FM = total_forces_moments(x9, delta_e, delta_a, delta_r, delta_t, notus)
%TOTAL_FORCES_MOMENTS  Aerodynamics + Propulsion combined, body-axis.
%
% This is the function that plugs into eom_derivs.m's FM_fun argument
% once the isolated EOM (Step 2) needs real forces instead of hand-typed
% test constants. It reads the current 9 rigid-body states (u,v,w,p,q,r,
% phi,theta,psi -- position states xE,yE,h aren't needed since nothing
% here depends on position), computes angle of attack and sideslip,
% calls aero_coeffs.m (Step 3) for the six aerodynamic coefficients,
% resolves lift/drag from wind axes into body axes, adds the propulsion
% subsystem's thrust, and returns the same [Fx;Fy;Fz;L;M;N] format
% eom_derivs.m expects. Gravity is NOT included (eom_derivs.m adds it).
%
% Wind-to-body force resolution (beta=0 case) is the standard rotation
% by angle of attack: Fx = L*sin(alpha) - D*cos(alpha),
% Fz = -L*cos(alpha) - D*sin(alpha). For small alpha this reduces to
% Tewari's linearized Cx = -CD + CL*alpha, Cz = -CL - CD*alpha
% (Eq.4.27) -- used here in its exact trigonometric form since the EOM
% itself is nonlinear and there is no reason to re-linearize this part.
%
% Inputs:
%   x9      -- [u;v;w;p;q;r;phi;theta;psi], 9x1 (first 9 states of eom_derivs.m's x)
%   delta_e/a/r -- control surface deflections, rad (perturbation from trim)
%   delta_t -- throttle command, 0-1
%   notus   -- struct from build_ac_struct.m
%
% Output:
%   FM -- [Fx;Fy;Fz;L;M;N], 6x1, body-axis N and N*m

u = x9(1); v = x9(2); w = x9(3);
p = x9(4); q = x9(5); r = x9(6);

V = sqrt(u^2 + v^2 + w^2);
alpha = atan2(w, u);
beta  = asin(max(-1, min(1, v/V)));

[CL, CD, CY, Cl, Cm, Cn] = aero_coeffs(alpha, beta, p, q, r, ...
    delta_e, delta_a, delta_r, V, notus.aero);

qbar = 0.5*notus.rho*V^2;
L = qbar*notus.S*CL;
D = qbar*notus.S*CD;
Yf = qbar*notus.S*CY;

Fx_aero = L*sin(alpha) - D*cos(alpha);
Fz_aero = -L*cos(alpha) - D*sin(alpha);
Fy_aero = Yf;

T = local_prop_thrust(delta_t, V, notus.prop);

Fx = Fx_aero + T;    % thrust line assumed aligned with body x-axis (epsT=0)
Fy = Fy_aero;
Fz = Fz_aero;

Lm = qbar*notus.S*notus.b*Cl;
Mm = qbar*notus.S*notus.c*Cm;
Nm = qbar*notus.S*notus.b*Cn;

FM = [Fx; Fy; Fz; Lm; Mm; Nm];
end

function T = local_prop_thrust(delta_t, V, prop)
%LOCAL_PROP_THRUST  Placeholder electric-propulsion static thrust curve.
% Roadmap Section 8: "simple momentum-theory + propeller-efficiency
% estimate as placeholder." This is a linear thrust-lapse model: thrust
% falls off linearly with airspeed from Tmax (static, V=0) to zero at
% Vmax_thrust (roughly the fixed-pitch propeller's pitch speed).
% [ESTIMATE -- replace with motor/prop manufacturer thrust curve, or a
% proper momentum-theory/blade-element model, once hardware is chosen.]
T = delta_t * prop.Tmax * (1 - V/prop.Vmax_thrust);
T = max(T, 0);   % a fixed-pitch prop can't produce negative static thrust in this simple model
end
