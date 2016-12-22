function [ Iout, nA ] = dcDehazingSTCoh( I,t_map,A,win_size,i,gap )
% Function using Dark Channel Prior and Spatial Temporal Information Fusion for Video frame (see references)
% Refines tranmission through Guided Filter and obtains dehazed image from new transmission

% Parameters for guided filter
r = 15;       % Window size parameter
res = 0.001;  % epsilon parameter in Guided filter equation

[m, n, ~] = size(I);
% Estimate airlight
nA = A;
if mod(i,gap) ~= 1
    dark_channel = get_dark_channel(I, win_size);
    nA = get_atmosphere(I, dark_channel);
    % Weighted with old value
    nA = 0.7*A + 0.3*nA;
end
% Refine tranmission using Guided Filter (Function from Dark Channel code)
nt_map = reshape(guided_filter(rgb2gray(I), t_map, r, res), m, n);
% Get dehazed image from new transmission map
Iout = get_radiance(I, nt_map, nA);   

end

