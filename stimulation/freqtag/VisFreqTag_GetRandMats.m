function [ noiseTex, refreshrate ] = VisFreqTag_GetRandMats( win, freqrate, timedur, n_h_pix, alphaval, colrange )
%VISFREQTAG_GETRANDMATS builds the noise matrix that will then be flickered
%on the screen using the VisFreqTag_Display function.
%   - "win": the PsychToolbox window.
%   - "freqrate" (in Hz): the frequency.
%   - "timedur" (in sec): the time duration.
%   - "n_h_pix" (in squares): the number of horizontal squares to draw.
%   - "alphaval" (a scalar): the transparency of the noise.
%It returns a height x width x [R,G,B,alpha] x (freqrate*timedur) noise
%matrix.

% Get the window's size
[w_px, h_px] = Screen('WindowSize', win);

% Complete the inputs
if nargin < 2 || isempty(freqrate), freqrate = 15;           end
if nargin < 3 || isempty(timedur),  timedur = 1;             end
if nargin < 4 || isempty(n_h_pix),  n_h_pix = h_px;          end
if nargin < 5 || isempty(alphaval), alphaval = 1;            end
if nargin < 6 || isempty(colrange), colrange = [0, 255];     end

% Sanity check
if n_h_pix > h_px, error('You do not have enough pixels...'); end

% Get the screen's refreshing rate
refreshrate = Screen('NominalFrameRate', win);
if refreshrate == 0 || isnan(refreshrate)
    refreshrate = 60;
    warning('Default 60Hz refreshing rate applied.');
end

% Check that the screen can really perform that flickering
nmatpersec = refreshrate / freqrate;
if nmatpersec ~= round(nmatpersec)
    error('The frequency rate you provided is not a multiple of the screen''s refreshing rate');
end

% Scale the noise
scalingfact = h_px / n_h_pix;
noiseDim = round([h_px, w_px] ./ scalingfact);

% Get the number of noise matrix to build
nMat = freqrate * timedur;
if nMat ~= round(nMat)
    warning('The "ceil" function has been used to get the number of random noise frames to build');
    nMat = ceil(nMat);
end

% Prepare the noise matrix (for each second, and for each random matrix to draw at each second)
rng('shuffle');
noiseTex = uint8(randi(colrange, [noiseDim, 1, nMat]));
noiseTex = repmat(noiseTex, [1, 1, 3, 1]);

% Build a 2D transparency map
transmap = repmat(round(alphaval*255), noiseDim);

% Apply the map on the noise matrix
noiseTex(:,:,4,:) = repmat(transmap, [1, 1, 1, nMat]);

end