% Main file for Video Dehazing
% Uses functions from image dehazing methods (see references)
clc
clear all
close all
addpath('non_local_dehazing','Dark-Channel-Haze-Removal-master','screened_poisson_enhancement','spatial_temporal_information_fusion_video')

% Select Video to dehaze
try
    mov=VideoReader('input.mp4');
catch 
    warning('Input Video Not Found');
    return
end

% Write Output video
try
    vidObj = VideoWriter('dehazed_output');
catch 
    warning('Ouput Video cannot be written');
    return
end


% Video Processing Method
% fmethod = 'frameByFrame';   % Dehazing algorithm applied on each frame separately
fmethod = 'spatialTemporalFusion'; % Spatial-Temporal Information Fusion 

% Interval at which transmission is recomputed in S-T Information Fusion
gap = 10;

% Dehazing method (uncomment the one to use)
dmethod = 'nld'; % Non-local dehazing
% dmethod = 'dcp'; % Dark Channel Prior
% dmethod = 'sp'; % Screened Poisson Contrast Enhancement

% Parameters for each method (default values provided)
% NLD
gamma = 1;     % Radiometric correction

% DCP
omega = 0.95;  % Parameter to keep little haze for distant objects
win_size = 5;  % Patch size in dark channel method

% SP
lambda = 0.0001;  % tradeoff parameter
s = 0.2;          % color saturation percentage

%-------------------------------------------------------------------------

open(vidObj);
nFrames=mov.NumberOfFrames;
ts = tic;
if strcmp(dmethod,'nld')   % Non-local Dehazing
    if strcmp(fmethod,'frameByFrame')
        for i=1:nFrames
            I=read(mov,i);   % Read frame
            % Airlight estimation using the approach in Dark Channel Prior method
            dark_channel = get_dark_channel(double(I)/255, win_size);
            airlight = get_atmosphere(double(I)/255, dark_channel);
            A = zeros(1,1,3); A(1) = airlight(1); A(2) = airlight(2); A(3) = airlight(3);
            % Non-local Dehazing algorithm
            [Iout, trans_refined] = non_local_dehazing(I, A, gamma );
            writeVideo(vidObj,uint8(Iout));
        end
    elseif strcmp(fmethod,'spatialTemporalFusion')
        for i=1:nFrames
            I=read(mov,i);   % Read frame
            if mod(i,gap) == 1    % Only for frames at intervals of gap
                if i == 1   % for the first frame
                    % Airlight estimation using the approach in Dark Channel Prior method
                    dark_channel = get_dark_channel(double(I)/255, win_size);
                    airlight = get_atmosphere(double(I)/255, dark_channel);
                    A = zeros(1,1,3); A(1) = airlight(1); A(2) = airlight(2); A(3) = airlight(3);
                    % Non-local Dehazing algorithm to obtain the transmission map
                    ot_map = non_local_dehazing_trans(I, A, gamma ); % Transmission Map of first frame from NLD
                    nt_map = ot_map;    % Will store Tranmission Map of frame at gap distance from current frame
                    t_map = ot_map;  % Set current map as map for first frame
                end                
                if (i+gap) > nFrames   % No frame at gap distance from current frame
                    % Video near its end
                    ot_map = nt_map;   % Update current frame's transmission map
                    nt_mapf = nt_map;  % Use same map for the frame at gap distance (for computation)
                else                   % Frame exists at gap distance from current frame
                    nI = read(mov,i+gap);  % Read frame at gap distance
                    % Airlight estimation using the approach in Dark Channel Prior method
                    dark_channel = get_dark_channel(double(nI)/255, win_size);
                    airlight = get_atmosphere(double(nI)/255, dark_channel);
                    nA = zeros(1,1,3); nA(1) = airlight(1); nA(2) = airlight(2); nA(3) = airlight(3);
                    nA = 0.7*A + 0.3*nA;   % airlight weighted average with old airlight
                    nt_mapf = non_local_dehazing_trans(nI, nA, gamma ); % compute transmission map from NLD
                end                
                if (i > 1)
                    % Set current map as average of current map, map at gap interval backward and forward
                    % To avoid flickering
                    t_map = 0.333*(nt_map + ot_map + nt_mapf);   
                    ot_map = t_map;   % Save this map for use in linear interpolation for following frames
                end                
                if (i+gap) <= nFrames
                    nt_map = nt_mapf; % Update map of frame at gap interval, also to be used for linear interpolation
                end
               
            % For all other frames in between    
            else  
                tgap = mod(i,gap);  % Determine position in the current set of gap frames
                if tgap == 0
                    tgap = gap;
                end
                % Linear interpolation between map at first frame of the current set 
                % and last frame of the set (at gap interval from the first frame)
                t_map = ot_map + ((tgap-1)/gap)*(nt_map-ot_map);
            end
                
            % Refine the transmission estimate using Guided Filter and get dehazed frame
            % also get updated airlight which will be propagated
            [Iout, A] = nLDehazingSTCoh(I,t_map,A,gamma,i);
           
            writeVideo(vidObj,uint8(Iout));
        end
    end
elseif strcmp(dmethod,'dcp')   % Dark Channel Prior
    if strcmp(fmethod,'frameByFrame')
        for i=1:nFrames
            I=read(mov,i);   % Read frame
            % Faster version of DCP
            writeVideo(vidObj,uint8(dehaze_fast( double(I), omega, win_size )));  % Airlight estimation inside
        end
    elseif strcmp(fmethod,'spatialTemporalFusion')
        % One difference with the corresponding section in NLD is here the
        % map of the frame at gap interval which is computed from DCP
        % method does not need to be averaged with frames at gap
        % distances backward and forward from it to reduce flickering.
        % Same linear interpolation method for intermediate frames
        for i=1:nFrames
            I=double(read(mov,i));   % Read frame
            if mod(i,gap) == 1   % Only for frames at intervals of gap
                if i == 1   % for the first frame
                    % Airlight estimation
                    dark_channel = get_dark_channel(I, win_size);
                    A = get_atmosphere(I, dark_channel);
                    ot_map = get_transmission_estimate(I, A, omega, win_size); % Transmission Map of first frame from DCP
                else
                    ot_map = nt_map;   % update map of first frame in current set of gap frames
                    A = 0.7*A + 0.3*nA;  % Airlight a weighted average with old value
                end
                if (i+gap) > nFrames    % No frame at gap distance from current frame
                    % Video near its end
                    nt_map = ot_map;  % Use same map for the frame at gap distance (for computation)
                    nA = A;   % Use same value of airlight as old one
                else
                    nI = double(read(mov,i+gap)); % Read frame at gap distance
                    % Compute airlight
                    ndark_channel = get_dark_channel(nI, win_size);
                    nA = get_atmosphere(nI, ndark_channel);
                    if (i > 1)
                        nA = 0.7*A + 0.3*nA;    % weighted average with old value
                    end 
                    % compute transmission map for frame at gap distance using DCP
                    nt_map = get_transmission_estimate(nI, nA, omega, win_size); 
                end
            end
            % Now for all frames 
            % Linear interpolation between map at first frame of the current set 
            % and last frame of the set (at gap interval from the first frame)
            tgap = mod(i,gap);
            if tgap == 0
                tgap = gap;
            end
            t_map = ot_map + ((tgap-1)/gap)*(nt_map-ot_map);
            
            % Refine the transmission estimate using Guided Filter and get dehazed frame
            % also get updated airlight which will be propagated
            [Iout, A] = dcDehazingSTCoh(I,t_map,A,win_size,i,gap);
            
            writeVideo(vidObj,uint8(Iout));
        end
    end
elseif strcmp(dmethod,'sp')   % Screened Poisson Enhancement
    if strcmp(fmethod,'frameByFrame')
        for i=1:nFrames
            I=read(mov,i);   % Read frame
            % Screened Poisson Equation based Image Enhancement
            writeVideo(vidObj,uint8(screenedPoissonEnhancement( I, lambda, s )));
        end
    elseif strcmp(fmethod,'spatialTemporalFusion')
        disp('Spatial-Temporal Information Fusion not compatible with Screened Poisson') 
    end
end
elapsed = toc(ts);
disp('Elapsed time in seconds : ')
disp(elapsed)
close(vidObj);