function windVel = windVelCircStatic(x,t)

[~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, uy_vec ] = loadParamtetersCirc() ;


% compute the wind vel vector according to the cy vector
windVel = [0 uy_vec(t) 0 ]'; 

end