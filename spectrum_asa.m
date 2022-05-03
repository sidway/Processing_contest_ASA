%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TASK 3 Processing Technique - Center of gravity
% TASK: Retrieve the instanteneous frequency from the hydrophone time
% series
% Writen By Sidney Cândido in 2019
% Last review: 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all;
 % Load signal
[y fs] = audioread('Hydrophone Output Time Series.wav');
% Parameters 
 % Length of the signal(samples)
 N = length(y);
 % Overlap
 overlap = 0.85; %Higher the overlap, higher resolution, higher the cost
 % Block size
 NB = 32; %32 is the optimal value
 % Hanning window
 win = hanning(N/NB); %
 % The analysis are being made in PSD or FFT?
 % A: PSD to improve SNR
 k = 'psd';
% Start 
 % Compute the PSD, FFT, Fc and Tc matrix (All frequencies each block
 [S,freq,time,sinal_power,Fc,Tc] = spectrogram(y,win,round(overlap*N/NB),[0:0.1:200],fs);
 % Normalize amplitude
  if k == 'psd'
   sinal_norm = abs(sinal_power)./max(abs(sinal_power));
  else 
   sinal_norm = abs(S)/max(abs(S));
  end
 % Frequency distribution
  % Frequencies, min and max
  f = [60 80];
  idx(1) = find(f(1) == freq); 
  idx(2) = find(f(2) == freq); 
  
 % Take the temporal index of the peak in the frequencies of interest 
  [peak, idx_t] = max(sinal_norm(idx(1):idx(2),:),[],2);
   
 % Initiate count to treshold
  h = 1;
 
 % Loop varyng the peaks of the psd/fft 
   for kk = 1:length(peak)
       % Treshold
       if peak(kk) > 0.15
          % Compute indices to Fc and Tc
          real_idx(h) = idx_t(kk);
          % Save amplitude
          tresh_amp(h) = peak(kk);
          % Save the Fc and Tc of the specific block
          tresh_fc(h) = Fc(idx(1)+kk-1,real_idx(h));
          tresh_tc(h) = Tc(idx(1)+kk-1,real_idx(h));
          % count
          h = h+1;
       end
   end
%% Plot     
figure()
  plot(tresh_tc, tresh_fc,'*','color', [0.2 0.54 0.17],'linew', 1.2); %hold on
  xlim([52 57]); ylim([62 75]); grid minor;
  ylabel('Frequency (Hz)'); xlabel('Time (s)');
  set(gca, 'fontsize', 18);
  
% From this line foward was done some analysis of the window size parameter
% and save, to check the response of the processing with diferent NBs and
% 50% overlap, uncomment lines 74 and 91+ and pick a number between 1 and 11
% % Diferents NB (block number)
% % dbn_nb{u,1} = NB;
% % dnb_tc{u,1} = tresh_tc;
% % dnb_fc{u,1} = tresh_fc;
% % u = u+1;
% % save('diferents_NB.mat', 'dbn_nb', 'dnb_fc', 'dnb_tc')
% % ALL Plots
% %   load('diferents_NB.mat');
% %   figure()
% %   for l = 1:size(dbn_nb)
% %     plot(dnb_tc{l,1}, dnb_fc{l,1}, '*', 'DisplayName',...
% %          ['Window size: ' num2str(120/dbn_nb{l,1}) ' (s)'] ); hold on  
% %   end
% %   lgd = legend;
% %   lgd.FontSize = 14;
% %   grid minor; xlim([52 57]); ylim([62 75]);
% %     ylabel('Frequency (Hz)'); xlabel('Time (s)');
% %   set(gca, 'fontsize', 18);
% %  Best Plot 
% %  There is 11 plots, varying the window size (block size)
% %  The x and y limits were already optimized at the time and frequency of
% %  the event 
% % figure()
% %   plot(dnb_tc{3,1}, dnb_fc{3,1},'*','color', [0.2 0.54 0.17],'linew', 1.2); %hold on
% %   xlim([52 57]); ylim([62 75]); grid minor;
% %   ylabel('Frequency (Hz)'); xlabel('Time (s)');
% %   set(gca, 'fontsize', 18);
