function R = spearman_ranks(X,grps)
% ranking function for spearman.m
% written By I. El Naqa, Spring 2003
%
% Extracted for general use AJH, 2005
%
%  Usage:  R = ranks(X,grps)
%  
%  See also:  spearman.m
%
% Copyright 2010, Joseph O. Deasy, on behalf of the DREES development team.
% 
% This file is part of the Dose Response Explorer System (DREES).
% 
% DREES development has been led by:  Issam El Naqa, Aditya Apte, Gita Suneja, and Joseph O. Deasy.
% 
% DREES has been financially supported by the US National Institutes of Health under multiple grants.
% 
% DREES is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of DREES is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% DREES is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with DREES.  If not, see <http://www.gnu.org/licenses/>.

if (nargin < 2) grps = []; end;

within_grps = 0;
if (~isempty(grps))
    within_grps = 1;
    ugrps = uniquef(grps);
    ngrps = length(ugrps);
end;

[N,P] = size(X);

row_vect = 0;
if (N==1 & P>1)
    row_vect = 1;
    X = X';
    [N,P] = size(X);
end;

R = zeros(N,P);

for p = 1:P
    x = X(:,p);
    if (within_grps)
        for ig = 1:ngrps
            i = find(grps==ugrps(ig));
            R(i,p) = rankasgn(x(i));
        end;
    else
        R(:,p) = spearman_rankasgn(x);
    end;
end;

if (row_vect)
    R = R';
end;

return;
