function r = spearman_rankasgn(x)
% breaking ties routine...for spearman.m
% written By I. El Naqa, Spring 2003
%
% Extracted for general use AJH, 2005
%
%  Usage:  r = rankasgn(x)
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

[n,c] = size(x);
r = zeros(n,1);
[x,index] = sort(x);          % Sort and get indices to x
i = 1;
while (i<n)
    if (x(i+1) ~= x(i))           % Not a tie?
        r(index(i)) = i;
        i = i+1;
    else                          % A Tie?
        at_end = 0;
        for j = (i+1):n
            if (x(i) ~= x(j))
                j = j-1;
                break;
            end;
        end;
        midrank = mean(i:j);  % use mean..
        for k = i:j
            r(index(k)) = midrank;
        end;
        i = j+1;
    end;
end;
if (r(index(n)) == 0)
    r(index(n)) = n;
end

return