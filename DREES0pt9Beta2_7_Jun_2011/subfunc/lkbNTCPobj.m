function f = lkbNTCPobj(x,dvh,outcome)
%function f = lkbNTCPobj(x,dvh,outcome)
%objective function for NTCP CV model
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

a = x(1);
m = x(2);
D50 = x(3);
for i = 1:length(dvh)
    gmd(i)= calc_eud(dvh{i}(1,:), dvh{i}(2,:), a);
end
mu=drxlr_probit((gmd-D50)/(m*D50));
%f = sum((mu(:)-outcome(:)).^2);
f = -spearman(mu(:),outcome(:));
