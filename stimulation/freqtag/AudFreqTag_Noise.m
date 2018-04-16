function [ esnd, isnd, fs ] = AudFreqTag_Noise( snd, modfreq, modstrength, noisetype, noisemodstrength, makeplot )
%AUDFREQTAG_NOISE adds auditory noise (whose envelope is modulated
%according to a particular frequency) to the sound.
%
%Inputs:
%   - "snd": name of the sound file to load and modulate.
%   - "modfreq": frequency used to modulate the noise (in Hertz). 
%   - "modstrength": strength of the added noise (between 0 and 1).
%   - "noisetype": either 'white' or 'pink' noise.
%   - "noisemodstrength": strength of the modulation of the noise envelope.
%   - "makeplot": boolean specifying whether to display the processing
%     steps or not.
%
%Copyright Maxime Maheu 2016

% Complete the inputs
if nargin < 6 || isempty(makeplot)
    makeplot = true; % boolean
    if nargin < 5 || isempty(noisemodstrength)
        noisemodstrength = 0.5; % in percent
        if nargin < 4 || isempty(noisetype)
            noisetype = 'white';
            if nargin < 3 || isempty(modstrength)
                modstrength = 0.5; % in percent
                if nargin < 2 || isempty(modfreq)
                    modfreq = 41; % in Hertz
                end
            end
        end
    end
end

% Read the sound
[isnd, fs] = audioread(snd);
nsamp = size(isnd,1);
duration = nsamp / fs;
time = linspace(0, duration, nsamp);

% Generate the random noise
if     strcmpi(noisetype, 'white'), noise = WhiteNoise(nsamp);
elseif strcmpi(noisetype, 'pink'),  noise = PinkNoise(nsamp); end
noise = setminmax(noise, [-1, 1]);

% Create sinusoide at required frequency
t1 = (1:nsamp) ./ fs;
sinus = sin(2 * pi * modfreq * t1);
offset = 1;
modulation = (sinus .* noisemodstrength) + offset;

% Modulate the noise with the desired frequency
modnoise = noise .* modulation;

% Perform a weighted average between the noise and the sound
soundpart = (1-modstrength) .* isnd;
noisepart = modstrength  .* modnoise';
esnd = (soundpart + noisepart) ./ 2;

% Bring the new sound to the original scale
esnd = setminmax(esnd, [min(isnd), max(isnd)]);

% Display the processing steps
if makeplot
    figure('Position', [0.3333 0.0475 0.3333 0.8725], 'Name', 'Noise modulation');
    cols = [242, 096, 119; 058, 142, 237; 104, 188, 054] ./ 255;
    
    % Plot the sound
    subplot(5,1,1); hold('on');
    plot(time, isnd, '-', 'LineWidth', 1, 'Color', cols(1,:));
    plot(time, zeros(1,nsamp), 'k--', 'LineWidth', 1);
    xlim([0, duration]); symaxis('y');
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    ylabel('Amplitude'); title('Raw sound');
    
    % Plot the noise
    subplot(5,1,2); hold('on');
    plot(time, noise, '-', 'LineWidth', 1, 'Color', cols(2,:));
    plot(time, zeros(1,nsamp), 'k--', 'LineWidth', 1);
    xlim([0, duration]); symaxis('y');
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    ylabel('Amplitude'); title(sprintf('Raw %s noise', lower(noisetype)));
    
    % Plot the sinusoide
    subplot(5,1,3); hold('on');
    plot(time, modulation, '-', 'LineWidth', 2, 'Color', cols(3,:));
    plot(time, repmat(offset,1,nsamp), 'k--', 'LineWidth', 1);
    axis([0, duration, min(modulation), max(modulation)]);
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    ylabel('Amplitude'); title(sprintf('%iHz sinusoid', modfreq));
    
    % Plot the modulated noise
    subplot(5,1,4); hold('on');
    plot(time, modnoise, '-', 'LineWidth', 1, 'Color', cols(2,:));
    plot(time, zeros(1,nsamp), 'k--', 'LineWidth', 1);
    xlim([0, duration]); symaxis('y');
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    ylabel('Amplitude'); title(sprintf('%i%% modulated noise', round(noisemodstrength*100)));
    
    % Plot the sound
    subplot(5,1,5); hold('on');
    plot(time, esnd, '-', 'LineWidth', 1, 'Color', cols(1,:));
    plot(time, zeros(1,nsamp), 'k--', 'LineWidth', 1);
    xlim([0, duration]); symaxis('y');
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    xlabel('Time (s)'); ylabel('Amplitude'); title(sprintf('New %i%% modulated sound', round(modstrength*100)));
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = WhiteNoise( N )
%WHITENOISE generates random white noise.

y = randn(1, N);

end

function y = PinkNoise( N )
%PINKNOISE generates random pink noise. Inspired from Hristo Zhivomirov
%"pinknoise" function available on the FileExchange.

% Define the length of the vector ensure that the M is even
if rem(N,2), M = N + 1;
else         M = N; end

% Generate white noise
x = WhiteNoise(M);

% Perform a Fourrier transform
X = fft(x);

% Prepare a vector for 1/f multiplication
NumUniquePts = M/2 + 1;
n = 1:NumUniquePts;
n = sqrt(n);

% Multiplicate the left half of the spectrum so the power spectral density
% is proportional to the frequency by factor 1/f
X(1:NumUniquePts) = X(1:NumUniquePts) ./ n;

% Prepare a right half of the spectrum - a copy of the left one, except the
% DC component and Nyquist frequency - they are unique.
X(NumUniquePts+1:M) = real(X(M/2:-1:2)) -1i*imag(X(M/2:-1:2));

% Perform an inverse Fourrier transform
y = ifft(X);

% Prepare output vector y
y = real(y(1, 1:N));

% Ensure unity standard deviation and zero mean value
y = y - mean(y);
yrms = sqrt(mean(y.^2));
y = y/yrms;

end