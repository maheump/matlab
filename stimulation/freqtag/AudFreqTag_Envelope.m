function [ esnd, isnd, fs ] = AudFreqTag_Envelope( snd, modfreq, modstrength, lp, makeplot )
%AUDFREQTAG_ENVELOPE performs a frequency modulation on the sound envelope.
%
%Inputs:
%   - "snd": name of the sound file to load and modulate.
%   - "modfreq": frequency used to modulate the sound (in Hertz). 
%   - "modstrength": strength of the modulation (between 0 and 1).
%   - "lp": cut-off for the low-pass filter (in Hertz).
%   - "makeplot": boolean specifying whether to display the processing
%     steps or not.
%
%Copyright Maxime Maheu 2016

% Complete the inputs
if nargin < 5 || isempty(makeplot)
    makeplot = true; % boolean
    if nargin < 4 || isempty(lp)
        lp = 100; % in Hertz
        if nargin < 3 || isempty(modstrength)
            modstrength = 0.5; % in percent
            if nargin < 2 || isempty(modfreq)
                modfreq = 41; % in Hertz
            end
        end
    end
end

% Read the sound
[isnd, fs] = audioread(snd);
nsamp = size(isnd,1);
duration = nsamp / fs;
time = linspace(0, duration, nsamp);

% Extract the envelope
[evlup, evllo] = envelope(isnd);

% Apply a low-pass filter on the envelope
n = 6 ; % n-th order Butterworth filter
Wn = lp/(fs/2);
ftype = 'low';
[b, a] = butter(n, Wn, ftype); % using a Butterworth filter
lpevlup = filter(b, a, evlup);
lpevllo = filter(b, a, evllo);

% Create sinusoide at required frequency
t1 = (1:nsamp) ./ fs;
sinus = sin(2 * pi * modfreq * t1);
offset = 1;
modulation = (sinus .* modstrength) + offset;

% Modulate the envelope by the sinusoid
modevlup = lpevlup .* modulation';
modevllo = lpevllo .* modulation';

% Make the product between the modulated envelope and the sound
esnd = zeros(1, nsamp);
esnd(isnd >= 0) =  isnd(isnd >= 0) .* modevlup(isnd >= 0);
esnd(isnd <  0) = -isnd(isnd <  0) .* modevllo(isnd <  0);

% Bring the new sound to the original scale
esnd = setminmax(esnd, [min(isnd), max(isnd)]);

% Display the processing steps
if makeplot
    figure('Position', [0.3333 0.0475 0.3333 0.8725], 'Name', 'Envelope modulation');
    cols = [242, 096, 119; 058, 142, 237; 104, 188, 054] ./ 255;

    % Plot the sound
    subplot(6,1,1); hold('on');
    plot(time, isnd, '-', 'LineWidth', 1, 'Color', cols(1,:));
    plot(time, zeros(1,nsamp), 'k--', 'LineWidth', 1);
    xlim([0, duration]); symaxis('y');
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    ylabel('Amplitude'); title('Raw sound');

    % Plot the envelope
    subplot(6,1,2); hold('on');
    plot(time, evlup, '-', 'LineWidth', 1, 'Color', cols(2,:));
    plot(time, evllo, '-', 'LineWidth', 1, 'Color', cols(2,:));
    plot(time, zeros(1,nsamp), 'k--', 'LineWidth', 1);
    xlim([0, duration]); symaxis('y');
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    ylabel('Amplitude'); title('Raw envelope');

    % Plot the low-pass filtered envelope
    subplot(6,1,3); hold('on');
    plot(time, lpevlup, '-', 'LineWidth', 2, 'Color', cols(2,:));
    plot(time, lpevllo, '-', 'LineWidth', 2, 'Color', cols(2,:));
    plot(time, zeros(1,nsamp), 'k--', 'LineWidth', 1);
    xlim([0, duration]); symaxis('y');
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    ylabel('Amplitude'); title('Low-pass filtered envelope');

    % Plot the sinusoide
    subplot(6,1,4); hold('on');
    plot(time, modulation, '-', 'LineWidth', 2, 'Color', cols(3,:));
    plot(time, repmat(offset,1,nsamp), 'k--', 'LineWidth', 1);
    axis([0, duration, min(modulation), max(modulation)]);
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    ylabel('Amplitude'); title(sprintf('%iHz sinusoid', modfreq));

    % Plot the modulated envelope
    subplot(6,1,5); hold('on');
    plot(time, modevlup, '-', 'LineWidth', 2, 'Color', cols(2,:));
    plot(time, modevllo, '-', 'LineWidth', 2, 'Color', cols(2,:));
    plot(time, zeros(1,nsamp), 'k--', 'LineWidth', 1);
    xlim([0, duration]); symaxis('y');
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    ylabel('Amplitude'); title(sprintf('%i%% modulated envelope', round(modstrength*100)));

    % Plot the new sound
    subplot(6,1,6); hold('on');
    plot(time, esnd, '-', 'LineWidth', 1, 'Color', cols(1,:));
    plot(time, zeros(1,nsamp), 'k--', 'LineWidth', 1);
    xlim([0, duration]); symaxis('y');
    set(gca, 'Box', 'Off', 'TickDir', 'Out', 'Layer', 'Top', 'LineWidth', 1);
    xlabel('Time (s)'); ylabel('Amplitude'); title('New modulated sound');

    % Use similar y axes in several subplots
    ScaleAxis(gcf, 'y', [1:2, 4:6]);
end

end