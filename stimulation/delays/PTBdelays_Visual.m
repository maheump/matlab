% Launch Psychtoolbox
try 
    PsychtoolboxVersion;
catch
    error('Could not find Psychtoolbox!');
end

% Open a window
bg = round(255*0.75); % background color
[w_px, h_px] = Screen('WindowSize', 0);
[windowPtr, rect] = Screen('OpenWindow', 0, [bg, bg, bg], [1, 1, 1+0.5*w_px, 1+0.5*h_px]);
[w_px, h_px] = Screen('WindowSize', windowPtr);
Screen('Preference', 'SkipSyncTests', 1);

% Screen center coordinates
crossY = 1/2 * h_px;
crossX = 1/2 * w_px;

% Enable transparancy
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('TextSize', windowPtr, 50);
Screen('TextFont', windowPtr, 'Arial');

% Initialize screen
Screen(windowPtr, 'Flip');
text = 'Wait...';
[w, h] = RectSize(Screen('TextBounds', windowPtr, text));
Screen('DrawText', windowPtr, text, round(crossX-w/2), round(crossY-h*3/2), repmat(255, 1, 3));
Screen(windowPtr, 'Flip');
WaitSecs(1); % second

t = NaN(1,600);
for i = 1:600
    [~,t(i)] = Screen(windowPtr, 'Flip');
end
sca;

figure;
hist(diff(t), 50)