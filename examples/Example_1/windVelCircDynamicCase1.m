function windVel = windVelCircDynamicCase1(x,t)

[~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, fluid_vel_vec, tc, index_case_1, ~ ] = loadParamtetersCirc() ;

% create the ramp to be constant at t=tc
vy = fluid_vel_vec(index_case_1) * t/tc * (t <= tc) + fluid_vel_vec(index_case_1) * (t > tc) ;

% compute the wind vel vector according to the cy vector
windVel = [0 vy 0 ]' ;

end