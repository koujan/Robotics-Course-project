% Main file for Image Dehazing
% Uses functions from image dehazing methods (see references)
clc
clear all
close all
addpath('non_local_dehazing','Dark-Channel-Haze-Removal-master','screened_poisson_enhancement')

% Select Image to dehaze
try
    I = imread('non_local_dehazing/images/cityscape_input.png');
catch 
    warning('Image Not Found');
    return
end

% Dehazing method (uncomment the one to use)
method = 'nld'; % Non-local dehazing
% method = 'dcp'; % Dark Channel Prior
% method = 'sp'; % Screened Poisson Contrast Enhancement

% Parameters for each method (default values provided)

% NLD
gamma = 1;   % Radiometric correction

% DCP
omega = 0.95;  % Parameter to keep little haze for distant objects
win_size = 5;  % Patch size in dark channel method

% SP
lambda = 0.0001;   % tradeoff parameter
s = 0.2;      % color saturation percentage

%-------------------------------------------------------------------------
figure();
if (size(I,3) == 1)
    colormap(gray)
end
imagesc(uint8(I)); title('Original Image')


[m,n,~] = size(I);
disp('Image size ')
msg = sprintf('Height %d, Width %d',m,n);
disp(msg)
ts = tic;
if strcmp(method,'nld')
    % Airlight estimation using the approach in Dark Channel Prior method
    dark_channel = get_dark_channel(double(I)/255, 15);
    airlight = get_atmosphere(double(I)/255, dark_channel);
    A = zeros(1,1,3); A(1) = airlight(1); A(2) = airlight(2); A(3) = airlight(3);
    % Non-local Dehazing algorithm
	[Iout, trans_refined] = non_local_dehazing(I, A, gamma );
elseif strcmp(method,'dcp')
    % Faster version of DCP
    Iout = 255*dehaze_fast( double(I)/255, omega, win_size );  % Airlight estimation inside
elseif strcmp(method,'sp')
    % Screened Poisson Equation based Image Enhancement
    Iout = screenedPoissonEnhancement( I, lambda, s );   
end
elapsed = toc(ts);
disp('Elapsed time in seconds : ')
disp(elapsed)

figure();
if (size(Iout,3) == 1)
    colormap(gray)
end
imagesc(uint8(Iout)); title('Dehazed Image')