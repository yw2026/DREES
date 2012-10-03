function [rs, p] = spearman(x,y)
% spearman for rank correlation
% written By I. El Naqa, Spring 2003
%
% Extracted for general use AJH, 2005
%
%  Note:  This function requires the stats toolbox;  If without the stats toolbox, see spearman_nostats
%
%  Usage:  [rs, p] = spearman(x,y)
%  
%  See also:  spearman_nostats
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

x = x(:);
y = y(:);
n = length(x);
% convert to ranks
x = spearman_ranks(x);
y = spearman_ranks(y);
[ux,tx] = spearman_uniquef(x);
[uy,ty] = spearman_uniquef(y);
sumTx = sum(tx.^3 - tx)./12;
sumTy = sum(ty.^3 - ty)./12;
sumd2 = sum((x-y).^2);
n3n = (n.^3-n)./6;
num =   n3n-sumd2-sumTx-sumTy;
denom = sqrt((n3n-2*sumTx).*(n3n-2*sumTy));
if (denom > 0)
    rs = num ./ denom;
else
    rs = 0;
end

zval=rs*sqrt(n-1);
p = 1-erfc(-zval/sqrt(2))/2;

return
