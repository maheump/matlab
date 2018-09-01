function lambda = cartes2baryc( r, tri )
%CARTES2BARYC converts cartesian coordinates to barycentric coordinates.
%See https://en.wikipedia.org/wiki/Barycentric_coordinate_system
%
%Inputs:
%   - "r": a 2xN matrix with the cartesian coordinates of the N points to
%   transform into Barycentric coordinates.
%   - "tri": a 3x2 matrix specifying the cartesian coordinates of the
%   3 points defining the triangular space.
%
%Output:
%   - "lambda": a 3xN matrix with the barycentric coordinates.
%
%Copyright 2016 Maxime Maheu

% Coordinates of the triangle vertices in the cartesian coordinates system
%   horizontal    vertical      cartesian coordinates
x1 = tri(1,1); y1 = tri(1,2); % first  vertex of the triangle
x2 = tri(2,1); y2 = tri(2,2); % second vertex of the triangle
x3 = tri(3,1); y3 = tri(3,2); % third  vertex of the triangle
    
% Get cartesian coordinates of the points
x = r(1,:); % horizontal coordinates
y = r(2,:); % vertical   coordinates

% Compute the barycentric coordinates along each dimension
l1 = ((y2-y3) .* (x -x3) + (x3-x2) .* (y -y3)) ./ ...
     ((y2-y3) .* (x1-x3) + (x3-x2) .* (y1-y3));
l2 = ((y3-y1) .* (x -x3) + (x1-x3) .* (y -y3)) ./ ...
     ((y2-y3) .* (x1-x3) + (x3-x2) .* (y1-y3));
l3 = 1 - l1 - l2; % Barycentric coordinates must sum to 1

% Concatenate Barycentric coordinates into a 3xN matrix
lambda = cat(1, l1, l2, l3);

end