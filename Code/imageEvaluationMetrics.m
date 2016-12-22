% Image Evaluation Metrics used in Qing et al. (see references)
% Better Dehazing - Lower Mc, Higher Ec and Gc in dehazed image

clear all

% Image to evaluate
try
    I = imread('non_local_dehazing/images/cityscape_input.png');
catch 
    warning('Image Not Found');
    return
end

if (size(I,3) == 1)  % grayscale
    [m,n] = size(I);
    meanc = mean(mean(I));   % mean value
    h = imhist(I)/(m*n);              % compute histogram
    ec = sum(-h.*log2(0.0001+h));  % entropy
    j = 1:m-1;   k = 1:n-1;
    gx = zeros(m-1,n-1); gy = zeros(m-1,n-1);
    gx(j,k) = I(j,k+1) - I(j,k);    % gradient along x direction
    gy(j,k) = I(j+1,k) - I(j,k);    % gradient along y direction
    gc = mean(mean(sqrt(0.5*(gx.^2 + gy.^2))));  % average of gradient magnitude
else    % color
    [m,n,~] = size(I);
    meanc = reshape(mean(mean(I)),1,3);   % mean value
    h1 = imhist(I(:,:,1))/(m*n);      % compute histogram in each channel
    h2 = imhist(I(:,:,2))/(m*n); 
    h3 = imhist(I(:,:,3))/(m*n);
    ec = [sum(-h1.*log2(0.0001+h1)),sum(-h2.*log2(0.0001+h2)),sum(-h3.*log2(0.0001+h3))]; % entropy
    j = 1:m-1;   k = 1:n-1;
    gx = zeros(m-1,n-1,3); gy = zeros(m-1,n-1,3);
    gx(j,k,:) = I(j,k+1,:) - I(j,k,:);    % gradient along x direction
    gy(j,k,:) = I(j+1,k,:) - I(j,k,:);    % gradient along y direction
    gc = reshape(mean(mean(sqrt(0.5*(gx.^2 + gy.^2)))),1,3);  % average of gradient magnitude
end

disp('In order of channels ')
disp('Mean value Mc for image = ');
disp(meanc)
disp('Entropy Ec for image = ');
disp(ec)
disp('Average Gradient Gc for image = ');
disp(gc)

