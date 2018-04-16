% This script displays 3 different animated motion of an example image
% using Psychtoolbox.
% 
% Copyright Maxime Maheu 2018

%% DEFINE IMPORTANT PARAMETERS
%  ===========================

% Wether the different movements should begin at the same position of the
% screen
syncbeg = false; % synchronicity of starting points

% Specify the duration of the movie
moviedur = 3; % seconds

% Define a scaling factor for the image that can be used to make it larger
% (> 1) or smaller (< 1)
imgscfac = 1/4; % percentage

% Size of the screen
w = 600; % pixels
h = 400; % pixels

% Size of the movie's 
movwinw = 100; % pixels
movwinh = 100; % pixels

% Borders for the frequency tagging window
ftwinbw = 50; % pixels
ftwinbh = 50; % pixels

% Colors to use (in RGB format)
bgcol = [000 000 000; ... % black
         128 128 128];    % grey

%% OPEN A PSYCHTOOLBOX WINDOW
%  ==========================

% Define the screen's refreshing rate
refrate = 60; % hertz
% N.B. This script works only with 60 Hz refresing rate

% Open a PTB window
if exist('w', 'var') && exist('h', 'var')
    [windowPtr, rect] = Screen('OpenWindow', 0, [0,0,0], [1,1,w,h]);
else % fullscreen mode
    [windowPtr, rect] = Screen('OpenWindow', 0, [0,0,0]);
    HideCursor;
end

% Screen center coordinates
w_px = rect(3);
h_px = rect(4);

% Coordinates of the center of the screen
crossX = 1/2 * w_px;
crossY = 1/2 * h_px;

% Enable transparency
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%% IMPORT AN IMAGE
%  ===============

% Try to load an image
try
    imgpath = 'cow.png';
    notimg = false;

    % Read the image (and its alpha mask)
    [img, ~, alpham]= imread(imgpath); % load the image
    [imgw, imgh, n] = size(img); % get its size
    if n ==1, img = repmat(img, [1,1,3]); end % for black & white images

    % Append the alpha mask to the 3rd dimension and make it texture that can
    % be read by Psychtoolbox
    img = cat(3, img, alpham);
    imTex = Screen('MakeTexture', windowPtr, img);

    % Try to display it at the center of the screen
    imPos = CenterRectOnPoint(Screen('Rect', imTex).*imgscfac, crossX, crossY);
    Screen('DrawTexture', windowPtr, imTex, [], imPos);
    Screen('Flip', windowPtr); 

% If we do not manage to load an image, we simple use a dot
catch
    notimg = true;
    
end

%% SPECIFY MOTION TRAJECTORIES
%  ===========================

% Limits of the motion window
movwinX = [crossX-movwinw/2, crossX+movwinw/2];
movwinY = [crossY-movwinh/2, crossY+movwinh/2];

% Limits of the frequency-tagging window
ftwin = [movwinX(1)-ftwinbw, movwinY(1)-ftwinbh, ...
         movwinX(2)+ftwinbw, movwinY(2)+ftwinbh];

% Get the number of frames
fps = 30; % hertz (number of frames per second)
nframes = fps*moviedur;

% Prepare the output variable
trajcoord = cell(1,3);

% ~~~~~~~~~~~~~ %
% Vertical jump %
% ~~~~~~~~~~~~~ %

% We mimic the gravity effect by sampling on the log scale up to 2
y = logspace(0, 2, nframes/6) - 1;
y = y/max(y);
y = repmat([y, fliplr(y)], 1, nframes/30);

% Convert normalized trajectories (E [0,1]) to trajectories in the screen space
x = repmat(crossX, [1,nframes]); % horizontal coordinates
y = movwinY(1) + y.*diff(movwinY); % vertical coordinates
z = repmat(imgscfac, [1, numel(x)]); % size of the image
if syncbeg % change starting point's position
    x = x - movwinw/2;
    y = y + movwinh/2;
end

% Save trajectories and size in the cell array
trajcoord{1} = [x;y;z];

% ~~~~~~~~~~~~~~~ %
% Pendulum motion %
% ~~~~~~~~~~~~~~~ %

% Properties of the circle
h = 1/2; % horizontal position of the circle's center
k = 1/2; % vertical position of the circle's center
r = 1/2; % radius of the cirsle

% We mimic the gravity effect by sampling on the log scale up to 3
x = logspace(0, 3, nframes/6) - 1;
x = x/max(x)/2;
x = [x, fliplr(1-x)];
x = [x, fliplr(x)];
x = repmat(x, [1, nframes/30]);

% Deduce the vertical coordinates based on the equation of the circle
y = k - sqrt(-h^2+2*h.*x+r^2-x.^2);

% Convert normalized trajectories (E [0,1]) to trajectories in the screen space
x = movwinX(1) + x.*diff(movwinX); % horizontal coordinates
y = movwinY(2) - y.*diff(movwinY); % vertical coordinates
z = repmat(imgscfac, [1, numel(x)]); % size of the image

% Save trajectories and size in the cell array
trajcoord{2} = [x;y;z];

% ~~~~~~~~~~~~~~ %
% Zooming motion %
% ~~~~~~~~~~~~~~ %
    
% Keep the image at the center of the screen 
x = repmat(1/2, 1, nframes);
y = repmat(1/2, 1, nframes);

% Convert normalized trajectories (E [0,1]) to trajectories in the screen space
x = movwinX(1) + x.*diff(movwinX);
y = movwinY(2) - y.*diff(movwinY);
if syncbeg, x = x - movwinw/2; end

% Change the size (in percentage) of the stimulus to be displayed
z = linspace(imgscfac, imgscfac+0.05, nframes/6);
z = [z, fliplr(z)];
z = repmat(z, [1, nframes/30]);

% Save trajectories and size in the cell array
trajcoord{3} = [x;y;z];

%% STIMULATION LOOP
%  ================

% Prepare the output timing variable
timing = NaN(3,nframes);

% For each motion type
for m = 1:3
    
    % Wait a bit
    Screen('Flip', windowPtr);
    WaitSecs(1);
    
    % Initialize the counts
    imov = 1; % we start with the first position
    iter = 2; % we start with the non-background color
    
    % For each frame
    ntotframe = refrate*moviedur;
    for ifr = 1:ntotframe

        % Update image position
        if any(ifr == 1:2:ntotframe) % 30 hertz

            % Update frequency tagging
            if any(ifr == 1:6:ntotframe) % 10 hertz
                Screen('FillRect', windowPtr, bgcol(iter,:), ftwin);
                iter = setdiff(1:2, iter); % change color for the next update
            end

            % Compute image position
            x = trajcoord{m}(1,imov);
            y = trajcoord{m}(2,imov);
            z = trajcoord{m}(3,imov);
            if notimg
                Screen('DrawDots', windowPtr, [x,y], 100*z, repmat(255,1,3));
            elseif ~notimg
                imPos = CenterRectOnPoint(Screen('Rect', imTex).*z, x, y);
                Screen('DrawTexture', windowPtr, imTex, [], imPos);
            end

            % Flip the screen (and save the timing)
            timing(m,imov) = Screen('Flip', windowPtr); 
            imov = imov + 1;
        end
    end
    
    % Clean the screen
    Screen('Flip', windowPtr);
end

% Close the PTB window
sca;

%% DISPLAY MOTION TRAJECTORY AND TIMING
%  ====================================

% Open a new window
figure('Position', [790 369 343 420]);

% Display timing of presentation
subplot(3,1,1);
plot(1:2:ntotframe, [NaN(3,1), diff(timing, 1, 2)], '.-'); hold('on');
set(gca, 'Box', 'Off', 'XLim', [1,ntotframe], 'YLim', [0,max(ylim)]);
xlabel('Frame #'); ylabel('Time between flips');

% Display trajectory of motion
subplot(3,1,2:3);
plot(crossX, crossY, 'ks'); hold('on');
fill(ftwin([1,3,3,1]), ftwin([2,2,4,4]), 'k', 'FaceColor', 'None');
fill(movwinX([1,2,2,1]), movwinY([1,1,2,2]), 'k', 'FaceColor', 'None');
l = cellfun(@(x) plot(x(1,:), x(2,:), '.-'), trajcoord, 'UniformOutput', 0);
axis('equal'); axis(rect([1,3,2,4]));
set(gca, 'YDir', 'Reverse', 'XTick', [], 'YTick', []);
title('Trajectories on screen');
legend([l{:}], {'Vertical jump', 'Pendulum', 'Zoom'});
