function [ Iout, nA ] = nLDehazingSTCoh( I,t_map,A,gamma,i )
% Function using Non Local Dehazing and Spatial Temporal Information Fusion for Video frame (see references)
% Refines tranmission through Guided Filter and obtains dehazed image from new transmission

% Parameters for guided filter
r = 15;    % Window size parameter
res = 0.001;  % epsilon parameter in Guided filter equation

[m, n, ~] = size(I);
nA = zeros(1,1,3);
if (i == 1)  % For first frame
    nA = A;
else
    % Estimate airlight like in Dark Channel Prior Method
    dark_channel = get_dark_channel(double(I)/255, 15);
    airlight = get_atmosphere(double(I)/255, dark_channel);
    % Weighted with old value
    nA(1) = 0.7*A(1) + 0.3*airlight(1); nA(2) = 0.7*A(2) + 0.3*airlight(2); nA(3) = 0.7*A(3) + 0.3*airlight(3);
end
% Refine tranmission using Guided Filter (Function from Dark Channel code)
nt_map = reshape(guided_filter(rgb2gray(double(I)), t_map, r, res), m, n);
% Get dehazed image from new transmission map
Iout = imageFromTransmissionMap(I, nt_map, nA, gamma);	

end

