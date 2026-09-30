function notus = build_ac_struct()
%BUILD_AC_STRUCT  Assemble every init.m parameter into one struct.
%
% Every Step 4+ script needs the same ~25 parameters from init.m,
% repackaged into the sub-structs aero_coeffs.m and total_forces_moments.m
% expect (ac.aero, ac.eom, ac.prop). Rather than re-typing that assembly
% in every script (Step 3 did this inline, which was already getting
% repetitive), this is the one place it happens.
%
% Note: init.m runs inside THIS function's workspace, so its `clear` at
% the top only clears local variables here -- it cannot touch your base
% workspace or any other script's variables.

init;   % populates this function's local workspace with every init.m variable

notus.eom.m = m; notus.eom.Ixx = Ixx; notus.eom.Iyy = Iyy;
notus.eom.Izz = Izz; notus.eom.Ixz = Ixz; notus.eom.g0 = g0;

notus.aero.CLe_trim = W/(q0*S);   % Step 1 trim lift coefficient
notus.aero.CLalpha = CLalpha; notus.aero.CD0 = CD0; notus.aero.K = K;
notus.aero.Cmalpha = Cmalpha; notus.aero.Cmq = Cmq; notus.aero.CLq = CLq;
notus.aero.CLdelta_e = CLdelta_e; notus.aero.Cmdelta_e = Cmdelta_e;
notus.aero.CYbeta = CYbeta; notus.aero.Clbeta = Clbeta; notus.aero.Cnbeta = Cnbeta;
notus.aero.Clp = Clp; notus.aero.Clr = Clr; notus.aero.Cnp = Cnp; notus.aero.Cnr = Cnr;
notus.aero.CYp = CYp; notus.aero.CYr = CYr;
notus.aero.Cldelta_a = Cldelta_a; notus.aero.Cndelta_a = Cndelta_a;
notus.aero.Cndelta_r = Cndelta_r; notus.aero.CYdelta_r = CYdelta_r;
notus.aero.c = c; notus.aero.b = b;

% Propulsion: T_max already in init.m (Step 1). Vmax_thrust (the
% airspeed at which available thrust from a fixed-pitch prop goes to
% zero -- roughly the prop's pitch speed) was NOT in init.m; added here
% as a Step 4 placeholder, [ESTIMATE: typical fixed-pitch-prop thrust
% lapse for a cruise-optimized small UAV propeller, ~2.5x cruise speed].
notus.prop.Tmax = T_max;
notus.prop.Vmax_thrust = 2.5*U0;
notus.prop.tau_motor = tau_motor;

notus.S = S; notus.b = b; notus.c = c; notus.rho = rho0; notus.U0 = U0;

notus.limits.delta_e_max = delta_e_max;
notus.limits.delta_a_max = delta_a_max;
notus.limits.delta_r_max = delta_r_max;
notus.limits.delta_rate_max = delta_rate_max;
end
