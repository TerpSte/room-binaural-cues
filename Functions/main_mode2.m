function [init_sig1,le_array,re_array,ild_array,itd_array,freq_array] = main_mode2(x,y,x1,y1,x2,y2)

% Starting
disp('start!');
tic;

% Geometrical parameters
x_dim = 5;              % Room dimensions
y_dim = 5;

res = 0.1;              % Resolution of analysis

% Head parameters
hrad = 0.1;            % Head radius from center to the ear

% Other constants
v = 343;                % sound velocity in m/s

% Importing HRTFs
irs = read_irs('QU_KEMAR_anechoic_1m.mat');

% Load LPF
[HdB,HdA] = butter(5,(1000/44100)); % low pass filter: butterworth 5th order
% load lpfilter_cheby_3ord;

% Initialize arrays
le_array = [];
re_array = [];
ild_array = [];
itd_array = [];

  
% Inserting ONE bandpass filter from gammatone f.
freq_array = erbspacebw(150,16000);
[b,a] = gammatone(freq_array,44100,'classic','real');

% Inserting MONO audio files from two speakers
fs = 44100;
dt = 1/fs;
ovTime = 0.1;
t = 0:dt:(ovTime-dt);
signal = wgn(ovTime*fs,1,0);
% signal = sawtooth(2*pi()*bp_freq*t)';
% [signal,fs]=audioread(['\sources\sine_',num2str(bp_freq),'_1s.wav']);
% [signal,fs]=audioread(['\sources\pink_n_1s.wav']);

% Pascalize (from HUTear) with average sound pressure level being 30dB
signal_pascal = Pascalize(signal,70);

% Stereo panning
init_sig1 = signal_pascal;
init_sig2 = signal_pascal;
% half_period_samples = round((1/125)*fs/2);    % Out of Phase Source
% init_sig2 = init_sig2(half_period_samples:length(init_sig2),1);

criterion = (x>x1-0.2 && x<x1+0.2 && y>y1-0.2 && y<y1+0.2)||...
    (x>x2-0.2 && x<x2+0.2 && y>y2-0.2 && y<y2+0.2);

if criterion==0

    % Calculating DELAY and ATTENUATION due to speakers' distance
    [d1_le,d1_re,a1_le,a1_re] = speaker2ear_dist_fixed(x,y,x1,y1,hrad);
    [d2_le,d2_re,a2_le,a2_re] = speaker2ear_dist_fixed(x,y,x2,y2,hrad);

    sig1_le = init_sig1./d1_le;   % attenuated signal from sp1 - at left ear
    sig1_re = init_sig1./d1_re;   % attenuated signal from sp1 - at right ear
    sig2_le = init_sig2./d2_le;   % attenuated signal from sp2 - at left ear
    sig2_re = init_sig2./d2_re;   % attenuated signal from sp2 - at left ear

    delay1_le = round((d1_le/v)*fs);          % num of samples for sp1 to left ear delay
    delay1_re = round((d1_re/v)*fs);          % num of samples for sp1 to right ear delay
    delay2_le = round((d2_le/v)*fs);          % num of samples for sp2 to left ear delay
    delay2_re = round((d2_re/v)*fs);          % num of samples for sp2 to right ear delay

    % Expand signals to have the same size
    big_d = x_dim^2 + y_dim^2;                % largest possible distance in room
    max_delay = round((big_d/v)*fs);
    sig1_le = [zeros(delay1_le,1) ; sig1_le; zeros(max_delay-delay1_le,1)];
    sig1_re = [zeros(delay1_re,1) ; sig1_re; zeros(max_delay-delay1_re,1)];
    sig2_le = [zeros(delay2_le,1) ; sig2_le; zeros(max_delay-delay2_le,1)];
    sig2_re = [zeros(delay2_re,1) ; sig2_re; zeros(max_delay-delay2_re,1)];
%     sig2_le = [zeros(delay2_le,1) ; sig2_le; zeros(max_delay-delay2_le+half_period_samples-1,1)]; % Out of Phase source
%     sig2_re = [zeros(delay2_re,1) ; sig2_re; zeros(max_delay-delay2_re+half_period_samples-1,1)];


    % Applying HRTFs
    [sig1_le,sig1_re] = applying_hrtfs(sig1_le,sig1_re,a1_le,a1_re,irs);
    [sig2_le,sig2_re] = applying_hrtfs(sig2_le,sig2_re,a2_le,a2_re,irs);

    for i = 1:length(freq_array)
        % Addition of signals
        sig_le = sig1_le + sig2_le;
        sig_re = sig1_re + sig2_re;

        % Gammatone
        sig_le = filter(b(i,:),a(i,:),sig_le);
        sig_re = filter(b(i,:),a(i,:),sig_re);


%         % Half wave rectification
%         sig_le(sig_le<0)=0;
%         sig_re(sig_re<0)=0;
%         figure;
%         plot(sig_le);

        % Full wave rectification
        sig_le = sig_le.^2;
        sig_re = sig_re.^2;

        % Low Pass Filter
        sig_le=filter(HdB,HdA,sig_le);     
        sig_re=filter(HdB,HdA,sig_re);
        le_array(1:length(init_sig1),i)=sig_le(1:length(init_sig1),1);
        re_array(1:length(init_sig1),i)=sig_re(1:length(init_sig1),1);

        % Calculate ITD
        [~,itd,~] = spatialCues(sig_le',sig_re');
%         itd = interaural_time_difference(sig_le,sig_re,fs);
        ild = interaural_level_difference(sig_le,sig_re);
        itd_array(i) = itd;
        ild_array(i) = ild;
    
    end

end

% disp(['itd=',num2str(itd),', ild=',num2str(ild)]);

% % Plotting the arrays in 2d color maps
% disp('now plotting..');
% 
% subplot(311);plot(init_sig1);
% NFFT = 2^nextpow2(length(init_sig1)); % Next power of 2 from length of y
% Y = fft(init_sig1,NFFT)/length(init_sig1);
% f = fs/2*linspace(0,1,NFFT/2+1);
% subplot(312);plot(f,2*abs(Y(1:NFFT/2+1)));
% % Plot single-sided amplitude spectrum.
% plot(f,2*abs(Y(1:NFFT/2+1))) 
% subplot(313);plot(sig_le(1:length(init_sig1)),'b');
% hold on
% subplot(313);plot(sig_re(1:length(init_sig1)),'r');
% 
% disp('ended succesfully!');

toc