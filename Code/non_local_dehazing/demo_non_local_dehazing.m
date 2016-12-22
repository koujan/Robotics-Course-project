% This is a demo function implementing the non-local image dehazing algorithm
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
% Please read the instructions on Readme.txt in order to use this code.
%
% Author: Dana Berman, 2016. 

% Choose image to use, four example image are supplied with the code in the
% sub-folder images:
image_name = 'pumpkins'; % 'train'; % 'cityscape'; % 'forest'; % 
img_hazy = imread(['images/',image_name,'_input.png']);

% The algorithm uses previous methods for airlight estimation. 
% Load the airlight and gamma from the param file. 
% These values were given by Ra'anan Fattal, above each image:
% http://www.cs.huji.ac.il/~raananf/projects/dehaze_cl/results/
fid = fopen(['images/',image_name,'_params.txt'],'r');
[C] = textscan(fid,'%s %f');
fclose(fid);
gamma = C{2}(1); A = zeros(1,1,3); A(1) = C{2}(2); A(2) = C{2}(3); A(3) = C{2}(4);
	
[img_dehazed, trans_refined] = non_local_dehazing(img_hazy, A, gamma );

figure('Position',[50,50, size(img_hazy,2)*3 , size(img_hazy,1)]);
subplot(1,3,1); imshow(img_hazy);    title('Hazy input')
subplot(1,3,2); imshow(img_dehazed); title('De-hazed output')
subplot(1,3,3); imshow(trans_refined); colormap('jet'); title('Transmission')