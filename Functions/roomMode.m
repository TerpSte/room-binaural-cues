function [itd_array,ild_array] = roomMode(x_dim,y_dim,x1,y1,x2,y2,bp_freq,num_so)

% Starting
disp('start!');
tic;
h = waitbar(0,'Please wait...');
% Geometrical parameters


res = 0.1;              % Resolution of analysis

% Head parameters
hrad = 0.09;            % Head radius from center to the ear

% Other constants
v = 343;                % sound velocity in m/s

% Array of signals
itd_array = [];
ild_array = [];

% Importing HRTFs
irs = read_irs('QU_KEMAR_anechoic_1m.mat');

% Load LPF
[HdB,HdA] = butter(5,(1000/44100)); % low pass filter: butterworth 5th order
% load lpfilter_cheby_3ord;

% Choose bandpass filter frequency
% for bp_freq = [250,500,1000,2000,4000,6000,8000,10000,12000,16000]
    
   
% Inserting ONE bandpass filter from gammatone f.
[b,a] = gammatone(bp_freq,44100,'classic','real');

% Inserting MONO audio files from two speakers
fs = 44100;
dt = 1/fs;
t = 0:dt:0.1-dt;
signal = sawtooth(2*pi()*bp_freq*t)';
% [signal,fs]=audioread(['\sources\sine_',num2str(bp_freq),'_1s.wav']);
% [signal,fs]=audioread(['\sources\pink_n_1s.wav']);

% Convert to pascal units with average sound pressure level being 70dB
level = 70;     % dB
signal_pascal = signal.*(10^(level/20))./sqrt( (sum(abs(signal).^2))/length(signal) );

% Stereo panning
init_sig1 = signal_pascal;
if num_so==1
    init_sig2 = zeros(length(signal_pascal),1);
else
    init_sig2 = signal_pascal;
end
% half_period_samples = round((1/125)*fs/2);    % Out of Phase Source
% init_sig2 = init_sig2(half_period_samples:length(init_sig2),1);


% ---------------------------
% For every point on the grid
% ---------------------------
for x = hrad:res:(x_dim-hrad)
%     disp([bp_freq x]);
    waitbar(x/x_dim);
    for y = 1+hrad:res:(1+y_dim-hrad)
        
        criterion = (x>x1-0.2 && x<x1+0.2 && y>y1-0.2 && y<y1+0.2)||...
            (x>x2-0.2 && x<x2+0.2 && y>y2-0.2 && y<y2+0.2);

        if criterion==0

            % Calculating DELAY and ATTENUATION due to speakers' distance
            [d1_le,d1_re,a1_le,a1_re] = speaker2ear_dist_fixed(x,y,x1,y1,hrad);
            [d2_le,d2_re,a2_le,a2_re] = speaker2ear_dist_fixed(x,y,x2,y2,hrad);

            sig1_le = init_sig1./(d1_le-1);   % attenuated signal from sp1 - at left ear
            sig1_re = init_sig1./d1_re;   % attenuated signal from sp1 - at right ear
            sig2_le = init_sig2./d2_le;   % attenuated signal from sp2 - at left ear
            sig2_re = init_sig2./d2_re;   % attenuated signal from sp2 - at left ear

%             delay1_le = round((d1_le/v)*fs);          % num of samples for sp1 to left ear delay
%             delay1_re = round((d1_re/v)*fs);          % num of samples for sp1 to right ear delay
%             delay2_le = round((d2_le/v)*fs);          % num of samples for sp2 to left ear delay
%             delay2_re = round((d2_re/v)*fs);          % num of samples for sp2 to right ear delay

            sig1_le = init_sig1;   % attenuated signal from sp1 - at left ear
            sig1_re = init_sig1;   % attenuated signal from sp1 - at right ear
            sig2_le = init_sig2;   % attenuated signal from sp2 - at left ear
            sig2_re = init_sig2;   % attenuated signal from sp2 - at left ear

            delay1_le = 0;          % num of samples for sp1 to left ear delay
            delay1_re = 0;          % num of samples for sp1 to right ear delay
            delay2_le = 0;          % num of samples for sp2 to left ear delay
            delay2_re = 0;          % num of samples for sp2 to right ear delay

            % Expand signals to have the same size
            big_d = x_dim^2 + y_dim^2;                % largest possible distance in room
            max_delay = round((big_d/v)*fs);
            sig1_le = [zeros(delay1_le,1) ; sig1_le; zeros(max_delay-delay1_le,1)];
            sig1_re = [zeros(delay1_re,1) ; sig1_re; zeros(max_delay-delay1_re,1)];
            sig2_le = [zeros(delay2_le,1) ; sig2_le; zeros(max_delay-delay2_le,1)];
            sig2_re = [zeros(delay2_re,1) ; sig2_re; zeros(max_delay-delay2_re,1)];
%             sig2_le = [zeros(delay2_le,1) ; sig2_le; zeros(max_delay-delay2_le+half_period_samples-1,1)]; % Out of Phase source
%             sig2_re = [zeros(delay2_re,1) ; sig2_re; zeros(max_delay-delay2_re+half_period_samples-1,1)];

            % Applying HRTFs
            [sig1_le,sig1_re] = applying_hrtfs(sig1_le,sig1_re,a1_le,a1_re,irs);
            [sig2_le,sig2_re] = applying_hrtfs(sig2_le,sig2_re,a2_le,a2_re,irs);

            % Addition of signals
            sig_le = sig1_le + sig2_le;
            sig_re = sig1_re + sig2_re;

            % Gammatone
            sig_le = filter(b,a,sig_le);
            sig_re = filter(b,a,sig_re);

            % Half wave rectification
            sig_le(sig_le<0)=0;
            sig_re(sig_re<0)=0;

            % Full wave rectification
%             sig_le = sig_le.^2;
%             sig_re = sig_re.^2;

            % Low Pass Filter
%             sig_le=filter(HdB,HdA,sig_le);     
%             sig_re=filter(HdB,HdA,sig_re);

            % Calculate ITD
%             [~,itd,~] = spatialCues(sig_le',sig_re');
            itd = interaural_time_difference(sig_le,sig_re,fs);
            ild = interaural_level_difference(sig_le,sig_re);
            idxX = round((1/res)*x+1);  % index x
            idxY = round((1/res)*y);  % index y
            itd_array(idxX,idxY) = abs(itd);
            ild_array(idxX,idxY) = abs(ild);


        end
    end
end



itd_array(itd_array>0.000656) = 0.000656;

% % Plotting the arrays in 2d color maps
% disp('now plotting..');
% figure;
% subplot(121);surf(itd_array,'EdgeColor', 'None', 'facecolor', 'interp');...
%     view(90,90);axis('equal');axis('off');%axis([2,length(itd_array),2,length(itd_array),]);
% subplot(122);surf(ild_array(2:length(ild_array),2:length(ild_array)),'EdgeColor', 'None', 'facecolor', 'interp');...
%     view(90,90);axis('equal');axis('off');
% 
% disp('ended succesfully!');

close(h)
toc