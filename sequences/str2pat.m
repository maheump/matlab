function pat = str2pat( str )
%STR2PAT converts a string of characters into an array (e.g. BAB is
%returned as [2 1 2]).
%
%Input:
%   - "str": a string of characters.
% 
%Copyright 2016 Maxime Maheu

% Find letters used in the string of characters
letters = unique(str);

% Turn each letter into a scalar number
pat = NaN(1,numel(str));
for i = 1:numel(letters)
    pat(strfind(str, letters(i))) = i;
end

end
