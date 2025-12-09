close all;
clc;
clear;

% Data:
nfft = 974064;
% Plot:
% nfft = 10000;
message = importdata("Avaz on Rumi Sonnet (96).mp3");
F = linspace(0,message.fs,nfft);
msg_ft_data = fft(message.data,nfft);
msg_absft_data = abs(msg_ft_data);

figure;
plot(F(1:nfft/2), msg_absft_data(1:nfft/2));
xlabel("Frequency");
ylabel("Domain");
title("Frequency - Domain Plot")

%BBBB
white_noise = wgn(length(message.data),2,-20);
white_noise_ft = fft(white_noise,nfft);
white_noise_ftabs = abs(white_noise_ft);
figure;
plot(F(1:nfft/2), white_noise_ftabs(1:nfft/2));
xlabel("Frequency");
ylabel("Domain");
title("Frequency - Noise Domain Plot")

%CCCC
white_noise_Qd = imag(hilbert(white_noise,nfft));
figure;
plot(F(1:nfft/2),white_noise_Qd(1:nfft/2));
plot(F(1:nfft/2), white_noise_ftabs(1:nfft/2));
xlabel("Frequency");
ylabel("Domain");
title("Frequency - Q-Noise Domain Plot")

%DDDD
signal_ft_shifted = msg_ft_data .* exp(4i*pi/9) ;
signal_ft_shifted_WithNoise = signal_ft_shifted + white_noise_ft;
signal_ft_WithNoise = msg_ft_data + white_noise_ft;
signal_shifted = real(ifft(signal_ft_WithNoise));
audiowrite('shifted_audio_with_noise.wav', signal_shifted, message.fs);

%EEEE
channel_ft = signal_ft_WithNoise .* exp(-4i*pi/9) ;
channel_phase = angle(channel_ft);
channel_abs = abs(channel_ft);
figure;
plot(F(1:nfft/2), channel_abs(1:nfft/2));
xlabel("Frequency");
ylabel("Domain");
title("Frequency - Channel Domain Plot");
figure;
plot(F(1:nfft/2), channel_phase(1:nfft/2));
xlabel("Frequency");
ylabel("Domain");
title("Frequency - Channel Phase Plot");
audiowrite('Channel.wav', real(ifft(channel_ft)), message.fs);

%FFFF
figure;
plot(psd(spectrum.periodogram,message.data,'Fs',message.fs,'NFFT',nfft));
Filterd = lowpass(ifft(signal_ft_WithNoise),16000,44100);
Filterd_ft = fft(Filterd,nfft);
Filterd_channel = Filterd_ft .* exp(-4i*pi/9);
figure;
plot(F(1:nfft/2), Filterd_channel(1:nfft/2));
xlabel("Frequency");
ylabel("Domain");
title("Frequency - Filterd Channel Plot");
audiowrite('Channel_Filterd.wav', real(ifft(Filterd_channel)), message.fs);

%GGGG
Filterd_After = lowpass(real(ifft(channel_ft)),16000,44100);
Filterd_After_ft = fft(Filterd_After,nfft);
figure;
plot(F(1:nfft/2), Filterd_After_ft(1:nfft/2));
xlabel("Frequency");
ylabel("Domain");
title("Frequency - Filterd Channel Plot");
audiowrite('Channel_After_Filterd.wav', real(ifft(Filterd_channel)), message.fs);