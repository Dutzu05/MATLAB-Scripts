function [CLalpha, Cmalpha, static_margin] = aero_derivative_formulas( ...
    CLalpha_wf, CLalpha_t, eta, St_S_ratio, deps_dalpha, xbar_minus_xbarwf, Vt)
%AERO_DERIVATIVE_FORMULAS  Semi-empirical longitudinal derivative buildup.
%
% Source: Tewari, "Automatic Control of Atmospheric and Space Vehicles",
%   Sec.4.3.1.2 -- Eq.4.58 (lift-curve slope), Eq.4.63/4.65 (Cmalpha and
%   the controls-fixed static margin).
%
% This is the wing+tail buildup that turns basic geometry and airfoil
% data into the two most consequential longitudinal derivatives:
%   CLalpha -- how much lift you gain per unit angle of attack
%   Cmalpha -- whether the aircraft is statically stable in pitch at all
%              (must be negative), and by how much (the static margin)
%
% Inputs (consistent units, e.g. all "per deg" or all "per rad" -- the
%   formulas are unit-agnostic as long as CLalpha_wf and CLalpha_t use
%   the same angle unit):
%   CLalpha_wf         -- wing-fuselage lift-curve slope
%   CLalpha_t          -- tail lift-curve slope
%   eta                -- tail efficiency factor (dynamic pressure ratio)
%   St_S_ratio          -- tail-to-wing planform area ratio, St/S
%   deps_dalpha         -- downwash derivative, d(epsilon)/d(alpha)
%   xbar_minus_xbarwf   -- (CG location - wing-fuselage a.c. location),
%                          nondimensionalized by the wing MAC
%   Vt                  -- tail volume ratio, Vt = (St/S)*(tail_arm/c)
%
% Outputs:
%   CLalpha        -- whole-aircraft lift-curve slope (same unit as inputs)
%   Cmalpha        -- whole-aircraft pitching-moment-curve slope (same unit)
%   static_margin  -- controls-fixed static margin, fraction of MAC
%                     (positive = stable, CG ahead of neutral point)

CLalpha = CLalpha_wf + eta*St_S_ratio*CLalpha_t*(1 - deps_dalpha);          % Eq.4.58

static_margin = -xbar_minus_xbarwf ...
              + eta*Vt*(CLalpha_t/CLalpha)*(1 - deps_dalpha);               % Eq.4.65, rearranged

Cmalpha = -CLalpha * static_margin;                                         % Eq.4.64
end
