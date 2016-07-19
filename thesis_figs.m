%%
fs = 44100;
dt = 1/fs;
ovTime = 0.05;
t = 0:dt:(ovTime-dt);
freq = 250;
% signal = whitenoiseburst(fs);
signal = (sin(2*pi()*freq*t))';

[b,a] = gammatone(freq,44100,'classic','real');
signal2 = filter(b,a,signal);

% half wave rectification
signal2(signal2<0)=0;

% Low Pass Filter
[HdB,HdA] = butter(5,(1000/44100)); % low pass filter: butterworth 5th order
signal2=filter(HdB,HdA,signal2);     

figure;
plot(t,signal,'color',[0 0.5 0.5]); title('Sine 250 Hz');
hold on;
plot(t,signal2,'r');

%%
fs = 44100;
dt = 1/fs;
ovTime = 0.05;
t = 0:dt:(ovTime-dt);
freq = 600;
% signal = whitenoiseburst(fs);
signal = (sin(2*pi()*freq*t))';

[b,a] = gammatone(freq,44100,'classic','real');
signal2 = filter(b,a,signal);

% half wave rectification
signal2(signal2<0)=0;

% Low Pass Filter
[HdB,HdA] = butter(5,(1000/44100)); % low pass filter: butterworth 5th order
signal2=filter(HdB,HdA,signal2);     

figure;
plot(t,signal,'color',[0 0.5 0.5]); title('Sine 600 Hz');
hold on;
plot(t,signal2,'r');

%%
fs = 44100;
dt = 1/fs;
ovTime = 0.05;
t = 0:dt:(ovTime-dt);
freq = 1000;
% signal = whitenoiseburst(fs);
signal = (sin(2*pi()*freq*t))';

[b,a] = gammatone(freq,44100,'classic','real');
signal2 = filter(b,a,signal);

% half wave rectification
signal2(signal2<0)=0;

% Low Pass Filter
[HdB,HdA] = butter(5,(1000/44100)); % low pass filter: butterworth 5th order
signal2=filter(HdB,HdA,signal2);     

figure;
plot(t,signal,'color',[0 0.5 0.5]); title('Sine 1000 Hz');
hold on;
plot(t,signal2,'r');

%%
fs = 44100;
dt = 1/fs;
ovTime = 0.05;
t = 0:dt:(ovTime-dt);
freq = 2000;
% signal = whitenoiseburst(fs);
signal = (sin(2*pi()*freq*t))';

[b,a] = gammatone(freq,44100,'classic','real');
signal2 = filter(b,a,signal);

% half wave rectification
signal2(signal2<0)=0;

% Low Pass Filter
[HdB,HdA] = butter(5,(1000/44100)); % low pass filter: butterworth 5th order
signal2=filter(HdB,HdA,signal2);     

figure;
plot(t,signal,'color',[0 0.5 0.5]); title('Sine 2000 Hz');
hold on;
plot(t,signal2,'r');