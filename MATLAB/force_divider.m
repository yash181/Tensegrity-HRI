function [force_actual] = force_divider(force_measured)

% Converts force sensed to actual force through force divider based on the
% selected spring constants

K_outer = 3.783;       %N/mm
K_inner = 0.368;    %N/mm

dist = force_measured/K_inner;
force_actual = (K_outer + K_inner)*dist;

end