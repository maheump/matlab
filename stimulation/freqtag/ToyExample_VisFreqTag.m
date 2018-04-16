% Toy example of visual frequency tagging.
% Maxime Maheu (03/03/2016)

%% PREPARE THE SCREEN

% Clear the place
clear; close('all');

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

%% LOAD THE IMAGE TO OVERLAP

% Get the image
birdImg = imread('bird.png');

% Detect the bird in the image
[h_bird, w_bird, ~] = size(birdImg);
mask = zeros(h_bird, w_bird);
for i = 1:3, mask = mask + (birdImg(:,:,i) == 128); end

% Create the transparency map
alphaval = 0.9;
alphamap = repmat(round(alphaval*255), [h_bird, w_bird]);

% Remove the background, but keep the bird!
alphamap(mask == 3) = 0;
birdImg(:,:,4) = alphamap;

% Reduce the image size
birdImg = imresize(birdImg, 0.50);
[h_bird, w_bird, ~] = size(birdImg);

% Convert it into a texture
birdTex = Screen('MakeTexture', windowPtr, birdImg);
birdPos = CenterRectOnPoint(Screen('Rect', birdTex), crossX, crossY);

%% BUILD THE NOISE MATRIX

freqrate = 30; % Hertz
timedur = 2; % seconds
n_h_pix = 50; % rows of flickering squares
noiseTex = VisFreqTag_GetRandMats(windowPtr, freqrate, timedur, n_h_pix);
noisePos = [0, 0, w_px, h_px];

%% DISPLAY THE IMAGE WITH A FLICKERING BACKGROUND

% Beginning
ton = GetSecs+2;

% Display
tic;
[fliptimes, refreshrate, flipdur] = VisFreqTag_Display(windowPtr, ...
    freqrate, timedur, ton, {noiseTex}, noisePos, {birdTex}, birdPos);
toc;

% Close the screen
sca;

% Plot the histogram of time errors
figure; hist(diff(fliptimes)); hold('on');
plot(repmat(1/freqrate, [1,2]), ylim, 'k--', 'LineWidth', 1);
    
%% DISPLAY 2 DIFFERENT FLICKERING AREAS

% A function scaling 2 (or more) noise matrice in the time dimension (the
% 4th one) is in preparation. This will allow different part of the screen
% to flicker at different frequencies.
