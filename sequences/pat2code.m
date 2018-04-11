function code = pat2code( pat )
%PAT2CODE transforms a pattern into a code (e.g. it is easier to code
%"AAABBABB" as "3212").
%
%Input:
%   - "pat": a 1xN array.
%
%Copyright 2016 Maxime Maheu

% Pattern's length
L = numel(pat);

% Get repetitions and alternations
ds = abs(diff(pat));

% Count the number of repeated stimuli for each repetitions cluster
if any(ds == 1)
    jump = find(ds == 1);
    d = [jump(1), diff(jump), L-jump(end)];
else, d = L;
end

% Generate a simplest code to identify the patterns
code = str2double(sprintf('%i', d));

end
