function xdot = eom_derivs(t, x, FM_fun, ac)
%EOM_DERIVS  6-DOF nonlinear rigid-body equations of motion, body axes.
%
% This is the "engine room" of the digital twin: given the total
% external force/moment acting on the airframe at this instant, it
% returns the 12 state derivatives. Nothing in here knows or cares
% whether those forces came from aerodynamics, propulsion, a hand-typed
% test constant, or anything else -- that separation is the whole point
% of Step 2 (see chat explanation).
%
% Source: Way, "Aircraft Flight Dynamics and Control"
%   Force equations      -- Eq.7.2a-c
%   Moment equations      -- Eq.7.3a-c
%   Kinematic equations    -- Eq.7.4a-c
%   Navigation equations   -- Eq.7.5a-c
%
% Inputs:
%   t      -- time (s), passed through to FM_fun (unused internally
%             otherwise; ode45 requires this signature)
%   x      -- 12x1 state vector, in this fixed order:
%             [u; v; w; p; q; r; phi; theta; psi; xE; yE; h]
%             (body velocities; body rates; Euler angles; NED position)
%   FM_fun -- function handle, FM = FM_fun(t, x), returning a 6x1
%             vector [Fx; Fy; Fz; L; M; N] -- the TOTAL body-axis
%             external force (N) and moment (N*m), aerodynamic +
%             thrust combined. Gravity is NOT included here; it is
%             added explicitly below exactly as Way's Eq.7.2 shows.
%   ac     -- struct with fields m, Ixx, Iyy, Izz, Ixz, g0 (mass
%             properties + gravity, from init.m)
%
% Output:
%   xdot   -- 12x1 state derivative vector, same ordering as x.

u = x(1); v = x(2); w = x(3);
p = x(4); q = x(5); r = x(6);
phi = x(7); theta = x(8); psi = x(9);

FM = FM_fun(t, x);
Fx = FM(1); Fy = FM(2); Fz = FM(3);
L = FM(4); M = FM(5); N = FM(6);

m = ac.m; Ixx = ac.Ixx; Iyy = ac.Iyy; Izz = ac.Izz; Ixz = ac.Ixz; g = ac.g0;

%% Force equations (Way Eq.7.2a-c)
udot = Fx/m - g*sin(theta) + r*v - q*w;
vdot = Fy/m + g*sin(phi)*cos(theta) + p*w - r*u;
wdot = Fz/m + g*cos(phi)*cos(theta) + q*u - p*v;

%% Moment equations (Way Eq.7.3a-c)
ID = Ixx*Izz - Ixz^2;
pdot = (Izz/ID)*(L + Ixz*p*q - (Izz - Iyy)*q*r) ...
     + (Ixz/ID)*(N - Ixz*q*r - (Iyy - Ixx)*p*q);
qdot = (1/Iyy)*(M - (Ixx - Izz)*p*r - Ixz*(p^2 - r^2));
rdot = (Ixz/ID)*(L + Ixz*p*q - (Izz - Iyy)*q*r) ...
     + (Ixx/ID)*(N - Ixz*q*r - (Iyy - Ixx)*p*q);

%% Kinematic (Euler-angle) equations (Way Eq.7.4a-c)
phidot   = p + (q*sin(phi) + r*cos(phi))*tan(theta);
thetadot = q*cos(phi) - r*sin(phi);
psidot   = (q*sin(phi) + r*cos(phi))/cos(theta);

%% Navigation equations, flat-Earth (Way Eq.7.5a-c)
xEdot = u*(cos(theta)*cos(psi)) ...
      + v*(sin(phi)*sin(theta)*cos(psi) - cos(phi)*sin(psi)) ...
      + w*(cos(phi)*sin(theta)*cos(psi) + sin(phi)*sin(psi));
yEdot = u*(cos(theta)*sin(psi)) ...
      + v*(sin(phi)*sin(theta)*sin(psi) + cos(phi)*cos(psi)) ...
      + w*(cos(phi)*sin(theta)*sin(psi) - sin(phi)*cos(psi));
hdot  = u*sin(theta) - v*sin(phi)*cos(theta) - w*cos(phi)*cos(theta);

xdot = [udot; vdot; wdot; pdot; qdot; rdot; ...
        phidot; thetadot; psidot; xEdot; yEdot; hdot];
end
