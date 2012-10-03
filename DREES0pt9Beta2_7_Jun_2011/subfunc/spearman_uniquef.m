function [value,freq,index] = spearman_uniquef(grp,sortflag)
% uniquef for spearman.m
% written By I. El Naqa, Spring 2003
%
% Extracted for general use AJH, 2005
%
%  Usage:  [value,freq,index] = uniquef(grp,sortflag)
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

if (nargin < 2) sortflag = []; end;

get_index = 0;
if (nargout > 2)
    get_index = 1;
end;

if (isempty(sortflag))
    sortflag = 0;
end;

tol = eps * 10.^4;
grp = grp(:);

if (get_index)
    ind = [1:length(grp)]';
end;

if (any([~isfinite(grp)]))
    i = find(~isfinite(grp));
    grp(i) = [];
    if (get_index)
        ind(i) = [];
    end;
end;

value = [];
freq = [];

for i = 1:length(grp)
    b = (abs(value-grp(i)) < tol);
    if (sum(b) > 0)
        freq(b) = freq(b) + 1;
    else
        value = [value; grp(i)];
        freq =  [freq; 1];
    end;
end;

if (sortflag)
    [value,i] = sort(value);
    freq = freq(i);
end;

if (get_index)
    nval = length(value);
    index = zeros(nval,1);
    for v = 1:nval
        i = find(grp == value(v));
        index(v) = ind(i(1));
    end;
end;

return;
% modified from stats
