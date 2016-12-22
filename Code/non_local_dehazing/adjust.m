function adj = adjust(img,percen)
% This is a utility function used by the non-local image dehazing algorithm
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
% Contrast stretch utility function. Clip percen percentages of the pixels,
% while avoiding a drastic change to the white-balance.

if ~exist('percen','var') || isempty(percen), percen=[0.01 0.99]; end;

% linear contrast stretch to [0,1], identical on all colors
minn=min(img(:));
img=img-minn;
img=img./max(img(:));

% limit the change magnitude so the WB would not be drastically changed
contrast_limit = stretchlim(img,percen);
val = 0.2;
contrast_limit(2,:) = max(contrast_limit(2,:), 0.2);
contrast_limit(2,:) = val*contrast_limit(2,:) + (1-val)*max(contrast_limit(2,:), mean(contrast_limit(2,:)));
contrast_limit(1,:) = val*contrast_limit(1,:) + (1-val)*min(contrast_limit(1,:), mean(contrast_limit(1,:)));
adj=imadjust(img,contrast_limit,[],1);
