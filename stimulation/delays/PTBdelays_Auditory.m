% Script to test the auditory delays using PTB auditory functions.
% 
% Maxime Maheu, 2016

% Clear the place
clear; clc;

% Which presentation method to use?
method = 1; % 1 or 2, see below
forced = 0; % 0 or 1, see below

% How many tests to do?
nTest = 20;

% Initialize the PTB module
InitializePsychSound(1);
AudioFreq = 44100; % hertz
pahandle = PsychPortAudio('Open', [], [], forced, AudioFreq, 2);

% Generate some beep sound 1000 Hz, 0.5 secs, 50% amplitude
BeepDur = 0.1; % second(s)
BeepFreq = 1000; % hertz
Beep = 0.5 * MakeBeep(BeepFreq, BeepDur, AudioFreq);
Beep = repmat(Beep, [2,1]);

% Fill the buffer with that sound
PsychPortAudio('FillBuffer', pahandle, Beep);

% Prepare variables
wantedt   = NaN(1,nTest);
obtainedt = NaN(1,nTest);

% For each test to do
for t = 1:nTest

    % Method 1 => schedule the presentation, then wait until that time is reached
    if method == 1
        wantedt(t) = GetSecs + (BeepDur / 2);
        obtainedt(t) = PsychPortAudio('Start', pahandle, 1, wantedt(t), 1);

    % Method 2 => wait, then quickly present the sound
    elseif method == 2
        WaitSecs(BeepDur);
        wantedt(t) = PsychPortAudio('Start', pahandle, 1, [], 1);
        obtainedt(t) = GetSecs;
    end

    % Display the delay
    fprintf('Sound delay = %1.4fs.\n', obtainedt(t) - wantedt(t));
    WaitSecs(BeepDur);
end

% Close the buffer
PsychPortAudio('Close');

% Display the averaged delay (ans its standard deviation)
fprintf('Average sound delay = %1.4fs (+/- %1.4fs).\n', ...
    mean(obtainedt-wantedt), std(obtainedt-wantedt));