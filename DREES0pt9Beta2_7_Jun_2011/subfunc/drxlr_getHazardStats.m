function stats = drxlr_getHazardStats(b,Lb,Ib)
%function stats = drxlr_getHazardStats(b,Lb,Ib)
%
% This function computes statistics for Hazard model from Likelyhood and Information
% matrix (Hessian). stats is a structure with standard error, Wald test for
% significance and two-tailed p-value as its fields
%
%APA 9/14/06, Based on code by IEN
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

stats.likelihood=Lb;
C=inv(Ib);
se = sqrt(max(eps,diag(C)));
stats.se = se;
stats.z = b ./ se; % Wald test for significance
%stats.p = 2 * tcdf(-abs(stats.t), dfe);
stats.p = 2 * normcdf(-abs(stats.z)); % two tail p-value (symmetric)
