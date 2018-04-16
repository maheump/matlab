% Toy example of auditory frequency tagging.
% Maxime Maheu (14/03/2016)

%% INITIALIZATION

clear; close('all');
sndname = 'kafou.wav';
slowingfactor = 0.9;

%% PERFORM FREQUENCY MODULATION ON THE SOUND ENVELOPE

% Options
modfreq     = 38; % Hertz
modstrength = 0.35; % percent
lowpass     = 100; % Hertz
makeplot    = true; % boolean

% Perform the modulation
[esnd, isnd, fs] = AudFreqTag_Envelope(sndname, modfreq, modstrength, 100, makeplot);

% Listen to the sounds
soundsc(isnd, fs * slowingfactor); pause(1);
soundsc(esnd, fs * slowingfactor); pause(1);

% Save the sound
audiowrite('kafou_FreqTag1.wav', esnd, fs * slowingfactor);
try export_fig('kafou_FreqTag1.png', '-p0.01', '-m3'); catch, end;

%% ADD MODULATED NOISE TO THE SOUND

% Options
modfreq          = 20; % Hertz
modstrength      = 0.15; % in percent
noisemodstrength = 0.50; % in percent
noisetype        = 'pink';
makeplot         = true; % boolean

% Perform the modulation
[esnd, isnd, fs] = AudFreqTag_Noise(sndname, modfreq, modstrength, noisetype, noisemodstrength, makeplot);

% Listen to the sounds
soundsc(isnd, fs * slowingfactor); pause(1);
soundsc(esnd, fs * slowingfactor); pause(1);

% Save the sound and the figure
audiowrite('kafou_FreqTag2.wav', esnd, fs * slowingfactor);
try export_fig('kafou_FreqTag2.png', '-p0.01', '-m3'); catch, end;