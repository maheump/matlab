function [ fliptimes, refreshrate, flipdur ] = VisFreqTag_Display( win, freqrate, ...
    timedur, tbegin, NoiseTexMats, NoisePosMats, ImageTexMats, ImagePosMats )
%VISFREQTAG_DISPLAY displays the flickering noise and some other matrices
%(such as other images, if provided) in a PTB window.
%   - "win": the PsychToolbox window.
%   - "freqrate" (in Hz): the frequency.
%   - "timedur" (in sec): the time duration.
%   - "tbegin" (in machine time): the time at which the flickering must
%      begin.
%   - "NoiseTexMats": array of N-cells containing the 4D noise matrices.
%   - "NoisePosMats": Nx4 matrix containing the screen position at which to
%      display the noise matrices.
%   - "ImageTexMats": array of N-cells containing the 4D image matrices to
%      overlap to the noise.
%   - "ImagePosMats": Nx4 matrix containing the screen position at which to
%      display the image matrices.

% Check the inputs
if ~iscell(NoiseTexMats), NoiseTexMats = {NoiseTexMats}; end
if (numel(NoiseTexMats) ~= size(NoisePosMats, 1)) || (size(NoisePosMats, 2) ~= 4)
    error('Please check the dimensions of the noise inputs');
end
if nargin <= 5, ImageTexMats = {}; end

% Get the screen's refreshing rate
refreshrate = Screen('NominalFrameRate', win);
if refreshrate == 0 || isnan(refreshrate)
    refreshrate = 60;
    warning('Default 60Hz refreshing rate applied.');
end

% Get the number of flips to perform
if     freqrate <  1, Nflipspersec = freqrate * 100;
elseif freqrate >= 1, Nflipspersec = freqrate; end
Nflips = Nflipspersec * timedur;

% Query the frame duration
ifi = Screen('GetFlipInterval', win);
slack = ifi / 2;

% Get the number of free flips between two noise updates
n_ifi = refreshrate / freqrate;

% Get the time to wait after each flip
tflip = (n_ifi*ifi) - slack;

% Prepare output variables that will record real time flips
fliptimes = NaN(1, Nflips+1);
flipdur = NaN(1, Nflips);

% Get the time of the first flip
if isempty(tbegin), fliptimes(1) = GetSecs;
else fliptimes(1) = tbegin - tflip; end

% For each flip
for f = 1:Nflips
    
    % For each random matrix
    for r = 1:numel(NoiseTexMats)
        
        % Convert the matrix into a texture
        noiseTex = Screen('MakeTexture', win, NoiseTexMats{r}(:,:,:,f));

        % Draw the noise
        Screen('DrawTexture', win, noiseTex, [], NoisePosMats(r,:), [], 0);
    end
    
    % Display each image to overlap
    if ~isempty(ImageTexMats)
        for j = 1:numel(ImageTexMats)
            Screen('DrawTexture', win, ImageTexMats{j}, [], ImagePosMats(j,:));
        end
    end
    
    % Flip at proper timing
    [VBL, fliptimes(f+1), Flip] = Screen('Flip', win, fliptimes(f) + tflip);
    flipdur(f) = Flip-VBL;
end

end