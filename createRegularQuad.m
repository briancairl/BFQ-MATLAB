% CREATEREGULARQUAD
%
%   Creates a quadruped regular "stance" matrix.
%
%   Input
%   =====
%       r  -  x/y distances for front-right manipulator
%   
%   Output:
%   =======
%       M  -  3x4 stance matrix
function sm = createRegularQuad(r,varargin)
    if isempty(varargin)
        c = zeros(3,4);
    else
        c = repmat(varargin{1},1,4);
    end
    sm = ...
    [ 
        +r,-r,-r,+r;
        +r,+r,-r,-r;
         0, 0, 0, 0
    ] + c;
end