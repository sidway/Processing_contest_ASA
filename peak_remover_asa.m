%%
% Filter the hydrophone time series to find the passing spacecraft
% Writen by Sidney Cândido

%%
% Cleaning
close all; clear all;
% Inputs
 % Loading the wave
 [signal fs] = audioread('Hydrophone Output Time Series.wav'); 
 % Taking the absolute value for dealing with the complex
 signal = abs(signal);
 % Signal size
 n = length(signal);
 % time vectorw
 time = linspace(0, n/fs, n);
signal = signal';
srate = fs; % Hz

y_med = medfilt1(signal,10000);

figure()
plot(time, signal, '-r', 'linew', 2); hold on; grid on
plot(time, y_med, '--b');
