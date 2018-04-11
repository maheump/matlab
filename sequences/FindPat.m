function idx = FindPat( seq, pat )
%FINDPAT returns the indices of all elements (columns) from the input
%pattern that are present in the input sequence (rows).
%
%Inputs:
%   - "s": the sequence of observation.
%   - "pat": the pattern to look for.
%
%Outputs:
%   - "idx": a AxB matrix where size(idx,1) is the number of times the
%   pattern has been found in the sequence and size(idx,2) corresponds to
%   the length of the pattern.
%
%Copyright 2016 Maxime Maheu

% Make sure the sequence is a row vector
seq = seq(:)';

% Get the size of the pattern to look for
Np = numel(pat);

% Derive possible positions of each element of the pattern
locations = cell(1, Np);
for p = 1:(Np), locations{p} = find(seq == pat(p)); end

% Initialize count variable
N = 1;

% Initialize output variable
idx = [];

% Find instances of the pattern in the array
for p = 1:numel(locations{1})

    % Look for a consecutive progression of locations
    start_value = locations{1}(p);
    for q = 2:numel(locations)
        
        % Default boolean
        found = true;
        
        % If it does not match the previously derived possible positions
        if ~any((start_value + q - 1) == locations{q})
            
            % Turn the boolean off
            found = false;
            break;
        end
    end
	
    % If the boolean is enables
    if found
        
        % Save the positions in the output variable
        idx(N, 1:Np) = locations{1}(p) : locations{1}(p) + Np - 1;
        
        % Increment the count variable
        N = N + 1;
    end
end

end