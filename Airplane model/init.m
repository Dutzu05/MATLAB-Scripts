%% init.m -- NOTUS 6-DOF Digital Twin: Master Parameter Script
%
% STATUS: SURROGATE BASELINE (Giant III class) -- Step 1 of the build
% roadmap (NOTUS_Digital_Twin_Roadmap.md, Section 15, item 1).
%
% Every numeric literal below is tagged with its provenance so the swap
% to your team's real airframe data is a mechanical find-and-replace,
% never a redesign:
%
%   [SOURCE: <doc>, <section>]  -- taken directly from a project source
%                                  document, not derived or guessed.
%   [ESTIMATE: <method>]        -- no source document gives this number;
%                                  computed with a standard semi-empirical
%                                  method (Tewari Sec.4.3.1) or a typical
%                                  literature value for this aircraft
%                                  class. Replace with real data (CAD,
%                                  AVL/XFLR5, wind tunnel, DATCOM) once
%                                  available -- see Roadmap Section 16.
%
% Run this script once at the start of any MATLAB/Simulink session; it
% populates the base workspace with everything downstream scripts and
% the eventual Simulink model need.

clear; clc;

%% ------------------------------------------------------------------
%% 1. Geometry
%% ------------------------------------------------------------------
b   = 2.2;                 % wingspan, m               [SOURCE: Sandoval et al., "Evaluating the longitudinal stability of...", Sec.3.1 -- "wingspan of 2.2 [m]"]
AR  = 6.0;                 % wing aspect ratio          [ESTIMATE: typical value for a trainer-derivative fixed-wing UAV of this class; consistent with the aspect-ratio ranges discussed in the MAK2 thesis, Sec.3]
S   = b^2 / AR;             % wing reference area, m^2   [ESTIMATE: derived, S = b^2/AR, Tewari Eq.4.24 definition]
c   = S / b;                % mean aerodynamic chord, m  [ESTIMATE: derived, c = S/b]

% Fuselage/box dimensions used only for the first-pass inertia estimate
% below (Section 2) -- NOT flight-relevant geometry.
l_fus = 1.4;                % effective fuselage length, m   [ESTIMATE: typical proportion for a 2.2 m span trainer-class airframe]
h_fus = 0.25;                % effective body depth, m       [ESTIMATE: typical small-UAV fuselage cross-section]

%% ------------------------------------------------------------------
%% 2. Mass properties
%% ------------------------------------------------------------------
m   = 11.5;                 % mass, kg                   [SOURCE: Sandoval et al., Sec.3.1 -- "weight of 11.5 [kg]"]
g0  = 9.80665;               % gravity, m/s^2             [SOURCE: Sandoval et al., Sec.4.2 -- "gravitational acceleration of 9.81 m/s^2" (full-precision standard value used here)]
W   = m * g0;                % weight, N

% Inertia tensor: NEITHER source paper publishes numeric Ixx/Iyy/Izz.
% Even Sandoval et al. state their own inertia values came from
% "an approximate discretization of the mass" in CAD (Sec.4.2) --
% i.e. no numeric value exists in the text to extract. Pending real
% CAD/swing-test data, we use a first-pass equivalent-rectangular-prism
% approximation (mass m distributed over a box of length l_fus, span b,
% depth h_fus) purely to get order-of-magnitude, correctly-ordered
% (Ixx < Iyy is NOT assumed; long-span/short-fuselage UAVs typically
% have Ixx > Iyy, which this method reproduces).
%   [ESTIMATE: uniform rectangular-prism inertia approximation]
Ixx = (1/12) * m * (h_fus^2 + b^2);      % roll inertia, kg*m^2
Iyy = (1/12) * m * (l_fus^2 + h_fus^2);   % pitch inertia, kg*m^2
Izz = (1/12) * m * (l_fus^2 + b^2);       % yaw inertia, kg*m^2
Ixz = 0;                     % product of inertia, kg*m^2 [ESTIMATE: Way notes Ixz is typically small for conventional (non-swept, symmetric, low/mid-wing) configurations -- zero is a reasonable first pass]

%% ------------------------------------------------------------------
%% 3. Reference / trim flight condition
%% ------------------------------------------------------------------
U0    = 21.6;                % trim airspeed, m/s         [SOURCE: Sandoval et al., Sec.3.1 -- "condition of straight and level flight with a speed of 21.6 [m/s]"]
h0    = 0;                     % trim altitude, m (sea level for this baseline check; competition ceiling is 200 ft AGL, handled in Environment subsystem later)
rho0  = 1.225;                % ISA sea-level density, kg/m^3   [SOURCE: Tewari, Automatic Control of Atmospheric and Space Vehicles, Exercise 4.13 density formula uses this as the sea-level reference]
mu0   = 1.789e-5;             % dynamic viscosity of air at ISA sea level, Pa*s [standard atmospheric property, used only for the Reynolds-number verification check]

q0    = 0.5 * rho0 * U0^2;    % dynamic pressure at trim, Pa
Re0   = rho0 * U0 * c / mu0;  % Reynolds number at trim (chord-based)

%% ------------------------------------------------------------------
%% 4. Longitudinal stability & control derivatives  [Tewari Sec.4.3.1]
%% ------------------------------------------------------------------
a0_airfoil = 2*pi;            % 2-D (thin-airfoil) lift-curve slope, per rad [ESTIMATE: classical thin-airfoil theory value, Tewari Sec.4.3.1]
e_osw      = 0.8;              % Oswald efficiency factor                    [ESTIMATE: typical value for a conventional, unswept, moderate-AR wing]

CLalpha = a0_airfoil / (1 + a0_airfoil/(pi*e_osw*AR));  % finite-wing lift-curve slope, per rad [ESTIMATE: Prandtl finite-wing correction of a0, Tewari Sec.4.3.1]
CD0     = 0.04;                % zero-lift drag coefficient   [ESTIMATE: typical value for a small fixed-gear/strut UAV airframe]
K       = 1/(pi*e_osw*AR);     % induced-drag factor           [ESTIMATE: K = 1/(pi*e*AR), Tewari Eq.4.33 drag polar]
Cm0     = 0.02;                % pitching moment at zero alpha [ESTIMATE: small positive value typical of a cambered-airfoil, positive-tail-incidence trim setup]
Cmalpha = -0.8;                 % per rad                       [ESTIMATE: typical stable value consistent with Sandoval et al. Sec.5.1's qualitative finding that the Giant III is "statically and dynamically stable"]
Cmq     = -10.0;                % per rad (nondim. by c/2U)     [ESTIMATE: typical pitch-damping magnitude for a conventional tail-aft small UAV, Tewari Sec.4.3.1 Cmq formula family]
CLq     = 4.0;                  % per rad (nondim. by c/2U)     [ESTIMATE: typical tail-lift-driven pitch-rate lift derivative]

CLdelta_e = 0.35;                % per rad  [ESTIMATE: typical elevator lift effectiveness]
Cmdelta_e = -0.90;                % per rad  [ESTIMATE: typical elevator pitching-moment effectiveness, Tewari Sec.4.3.3.1]

%% ------------------------------------------------------------------
%% 5. Lateral-directional stability & control derivatives [Tewari Sec.4.3, Sec.4.7]
%% ------------------------------------------------------------------
CYbeta = -0.30;    % per rad   [ESTIMATE: typical side-force-due-to-sideslip]
Clbeta = -0.10;    % per rad   [ESTIMATE: typical dihedral effect, moderate dihedral]
Cnbeta =  0.08;    % per rad   [ESTIMATE: typical weathercock (directional) stability, positive = stable]

Clp = -0.40;       % per rad (nondim. by b/2U)  [ESTIMATE: typical roll-damping magnitude]
Clr =  0.10;       % per rad (nondim. by b/2U)  [ESTIMATE: typical roll-due-to-yaw-rate]
Cnp = -0.05;       % per rad (nondim. by b/2U)  [ESTIMATE: typical yaw-due-to-roll-rate]
Cnr = -0.15;       % per rad (nondim. by b/2U)  [ESTIMATE: typical yaw-damping magnitude]
CYp =  0.0;        % per rad (nondim. by b/2U)  [ESTIMATE: usually negligible, set to zero as first pass]
CYr =  0.0;        % per rad (nondim. by b/2U)  [ESTIMATE: usually negligible, set to zero as first pass]

Cldelta_a =  0.15;   % per rad   [ESTIMATE: typical aileron roll effectiveness]
Cndelta_a = -0.01;   % per rad   [ESTIMATE: small adverse-yaw value]
Cndelta_r = -0.08;   % per rad   [ESTIMATE: typical rudder yaw effectiveness]
CYdelta_r =  0.15;   % per rad   [ESTIMATE: typical rudder side-force effectiveness]

%% ------------------------------------------------------------------
%% 6. Control-surface travel limits [Tewari Sec.4.7.2]
%% ------------------------------------------------------------------
delta_e_max = deg2rad(25);    % elevator travel limit, rad   [SOURCE: Tewari, Sec.4.7.2 -- +/-25 deg linear-range placeholder]
delta_a_max = deg2rad(25);    % aileron travel limit, rad    [SOURCE: Tewari, Sec.4.7.2]
delta_r_max = deg2rad(25);    % rudder travel limit, rad     [SOURCE: Tewari, Sec.4.7.2]
delta_rate_max = deg2rad(300); % max surface slew rate, rad/s [ESTIMATE: typical loaded hobby-servo slew rate for this control-surface size]

%% ------------------------------------------------------------------
%% 7. Actuator dynamics (2nd-order servo model) [Tewari Sec.4.3.3.1]
%% ------------------------------------------------------------------
omega_n_servo = 20;     % servo natural frequency, rad/s   [ESTIMATE: typical small hobby-servo bandwidth, to be tuned once linearized short-period mode is known, Tewari Eq.4.113]
zeta_servo    = 0.7;    % servo damping ratio               [ESTIMATE: typical critically-damped-ish servo design target]

%% ------------------------------------------------------------------
%% 8. Propulsion (electric -- competition rules Sec.4.1.9 mandate electric only)
%% ------------------------------------------------------------------
T_max      = 1.3 * W;    % max static thrust, N   [ESTIMATE: thrust-to-weight ratio ~1.3, typical for a manoeuvring small electric UAV; replace with motor/prop manufacturer curve, Roadmap Sec.8]
tau_motor  = 0.15;        % throttle/ESC+motor lag time constant, s  [ESTIMATE: electric powertrains respond far faster than the combustion-engine values in Tewari's worked examples, Sec.4.3.1.1]
battery_V_nom = 14.8;      % nominal battery voltage, V (4S LiPo)     [ESTIMATE: typical pack size for this aircraft class, competition rules Sec.4.1.9/4.2.1 mandate LiPo but not cell count]

%% ------------------------------------------------------------------
%% 9. Non-dimensionalizing helper constants (used throughout the
%%    Aerodynamics subsystem once built, Roadmap Section 7)
%% ------------------------------------------------------------------
qbar_hat = @(q_rate, Uref) q_rate * c / (2*Uref);   % nondimensional pitch rate, Tewari Eq.4.41
pbar_hat = @(p_rate, Uref) p_rate * b / (2*Uref);   % nondimensional roll rate
rbar_hat = @(r_rate, Uref) r_rate * b / (2*Uref);   % nondimensional yaw rate

%% ------------------------------------------------------------------
fprintf('init.m loaded: NOTUS surrogate (Giant III class) parameter set.\n');
fprintf('  m = %.2f kg | b = %.2f m | S = %.4f m^2 | c = %.4f m | AR = %.1f\n', m, b, S, c, AR);
fprintf('  Trim: U0 = %.1f m/s | q0 = %.1f Pa | Re0 = %.0f\n', U0, q0, Re0);