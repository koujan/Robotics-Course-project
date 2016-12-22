function [img_dehazed] = imageFromTransmissionMap(img_hazy,transmission, air_light, gamma)
%% This is part of the function in non_local_dehazing.m which computes the dehazed image
%  from the given tranmission map

%%
% This is the core function implementing the non-local image dehazing algorithm
% described in the paper:
% Non-Local Image Dehazing. Berman, D. and Treibitz, T. and Avidan S., CVPR2016,
% which can be found at:
% www.eng.tau.ac.il/~berman/NonLocalDehazing/NonLocalDehazing_CVPR2016.pdf
% If you use this code, please cite our paper.
% 
% The software code of the non-local image dehazing algorithm is provided
% under the attached Non-commercial_copyright_license.rtf
% The license can also be found at:
% www.eng.tau.ac.il/~berman/NonLocalDehazing/Non-commercial_copyright_license.rtf
%
%
%   Input arguments: (changed from original)
%   ----------------
%	img_hazy     - A hazy image in the range [0,255], type: uint8
%   transmission - Transmission map of the scene, in the range [0,1] 
%	air_light    - As estimated by prior methods, normalized to the range [0,1]
%	gamma        - Radiometric correction. If empty, 1 is assumed
%
%   Output arguments: (changed from original)
%   ----------------
%   img_dehazed  - The restored radiance of the scene (uint8)
%
% Author: Dana Berman, 2016. 


%% Compute Dehazed image
trans_min = 0.1;
[h,w,n_colors] = size(img_hazy);
img_hazy = im2double(img_hazy);
img_hazy_corrected = img_hazy.^gamma; % radiometric correction
img_dehazed = zeros(h,w,n_colors);
leave_haze = 1.06; % leave a bit of haze for a natural look (set to 1 to reduce all haze)
for color_idx = 1:3
    img_dehazed(:,:,color_idx) = ( img_hazy_corrected(:,:,color_idx) - ...
        (1-leave_haze.*transmission).*air_light(color_idx) )./ max(transmission,trans_min);
end

% Limit each pixel value to the range [0, 1] (avoid numerical problems)
img_dehazed(img_dehazed>1) = 1;
img_dehazed(img_dehazed<0) = 0;
img_dehazed = img_dehazed.^(1/gamma); % radiometric correction

% For display, we perform a global linear contrast stretch on the output, 
% clipping 0.5% of the pixel values both in the shadows and in the highlights 
adj_percent = [0.005, 0.995];
img_dehazed = adjust(img_dehazed,adj_percent);

img_dehazed = im2uint8(img_dehazed);

end % function imageFromTransmissionMap
