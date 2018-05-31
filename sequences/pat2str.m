function str = pat2str( pat, letters, stims )
%PAT2STR converts an array into a string (e.g. [2 1 2], [1 0 1] or [4 -1 4]
%are returned as BAB).
%
%Inputs:
%   - "pat": a simple array (no limit regarding the number of different
%	integers as long as it matches the number of elements in "letters").
%   - "letters": a (optional) cell-array specifying the letters to use
%	for the transformation.
%
%Copyright 2016 Maxime Maheu


% Find the stimuli
if nargin < 3
    stims = unique(pat);
end

% Define the entire alphabet
if nargin < 2
    letters = cellfun(@char, num2cell('A'+(1:26)-1), 'UniformOutput', false);
end

% Check
if numel(stims) > numel(letters)
    error('There is not enough letters to describe the pattern.');
end

% Recode the sequence
s = NaN(1,numel(pat));
for i = 1:numel(stims)
    s(pat == stims(i)) = i;
end

% Convert it into a string of character
str = char(letters(s))';

end