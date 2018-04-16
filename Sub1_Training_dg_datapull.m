%% Sub1_Training_dg_datapull.m
%
%  Pulls the dataglove traces from IEEGPortal and downsamples them so each
%  sample is separated by 50 ms, to keep them on the same timescale as the 
%  features we will calculate in a separate code.
%
%  This uses MATLAB's decimate(...) function, which resamples data at a 
%  lower rate after lowpass filtering. Y = decimate(X,R) resamples the 
%  sequence in vector X at 1/R times the original sample rate. The 
%  resulting resampled vector Y is R times shorter: 
%  length(Y) = ceil(length(X)/R). By default, decimate(...) filters the 
%  data with an 8th order Chebyshev Type I lowpass filter with cutoff 
%  frequency 0.8*(Fs/2)/R, before resampling.
%
%  Last edited: B. Murphy, 16 April 2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; warning('off');
session = IEEGSession('I521_Sub1_Training_dg','bremu','bre_ieeglogin.bin');
sR = session.data.sampleRate; % sampling rate
nr = ceil(((session.data.rawChannels(1).get_tsdetails.getEndTime)/1e6)/sR);

for i = 1:5
    % pull the data from IEEGPortal
    Sub1_Training_dg(:,i) = session.data.getvalues(1:nr,i);
end
clear i;

% We need to set all NaNs to zero because if decimate(...) sees a NaN
% entry, it will set everything else after that NaN to a NaN as well.
Sub1_Training_dg(isnan(Sub1_Training_dg)) = 0;

for i = 1:5
    % decimate so that each sample is separated by 50 ms, so...
    % [1000 samples/1 s] * [1/50] = [1 sample/50 ms]
    Sub1_Training_dg_downsampled(:,i) = decimate(Sub1_Training_dg(:,i),50);
end
clear i;

save('sub1_training_dg.mat','Sub1_Training_dg_downsampled')
