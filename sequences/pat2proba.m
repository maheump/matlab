function [ pA, pAlt, pAgB, pBgA ] = pat2proba( pat, id, rep )
%PAT2PROBA computes probabilities p(A), p(alt.), p(A|B) and p(B|A) based on
%a particular binary input pattern.
%
%Inputs:
%   - "pat": a double-array specifying the pattern from which to compute
%   probabilities.
%   - "id": a (facultative) 1x2 array specifying how As and Bs are coded in
%   the pattern. This can be inferred by the function, except if there is
%   only one type of observation in the sequence.
%   - "rep": an (facultative) boolean variable stating whether probabilities
%	must be computed strictly on the pattern (rep = false) or on a
%   repetition of this pattern (rep = true). This changes the transition
%   probabilities (in particular for small patterns) because in the last
%   case, the transition between the latter observation and the first one
%   is also taken into account.
%
%Copyright 2016 Maxime Maheu

% Define observations' identities
if nargin < 2 || isempty(id)
    id = [min(pat), max(pat)];
    if numel(unique(pat)) == 1
        error(['For pattern with a single type of observation. The ', ...
            'input "id" must be provided to ensure that the right ', ...
            'probabilities are computed.']);
    end
end
As = id(1);
Bs = id(2);

% Recode the sequence with 1s and 0s
s = NaN(1,numel(pat));
s(pat == As) = 1; % As are 1s
s(pat == Bs) = 0; % Bs are 0s
pat = s;

% Get the frequency of As
[~, ~, pX] = CountEvents(pat, [1,0]);
pA = pX(1);

% Append the first element of the pattern at the end of it such that
% transitions counts are accurate
if nargin < 3, rep = false; end
if rep, pat = [pat, pat(1)]; end

% Run the "CountEvents" function with the binary pattern
[~, ~, ~, pXgY] = CountEvents(pat, [1,0]);
pAgB = pXgY(2,1); % B => A
pBgA = pXgY(1,2); % A => B

% If there are less than 2 observations, the frequency of alternation
% cannot be computed
if numel(pat) == 1, pAlt = NaN;
    
% Otherwise, compute it simply as follows
else
    diffpat = abs(diff(pat)); % rep. are 0s, alt. are 1s
    [~, ~, pX] = CountEvents(diffpat, [1,0]);
    pAlt = pX(1);
end

end