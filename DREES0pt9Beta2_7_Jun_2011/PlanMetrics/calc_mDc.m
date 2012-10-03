function ans = calc_mDc(doseBinsV, volsHistV, percent,tail,txFraction)
% Returns the mean dose of the upper tail (the hottest (100-x)% of the structure)
% given the DVH data and the parameter percent.
%
%  MODIFICATION ALERT:  THIS FUNCTION IS UTILIZED BY THE DREXLER CODEBASE
%
%  Created: VHC 4/11/06, based off of calc_Dx code, IME modified
%  04/17/06
%
%  Usage: calc_mDx(doseBinsV, volsHistV, percent)
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


cumVolsV = cumsum(volsHistV);
cumVols2V = cumVolsV(end) - cumVolsV;

if ~exist('tail')
    inds = find([cumVols2V/cumVolsV(end)<= percent/100 ]); %all dose(index)s below percent% volume on DVH.
elseif strcmp(lower(tail),'lower')
    inds = find([cumVols2V/cumVolsV(end) >= percent/100 ]); %all dose(index)s above percent% volume on DVH.
else
    inds = find([cumVols2V/cumVolsV(end) <= percent/100 ]); %all dose(index)s below percent% volume on DVH.
end

%find mean of doses represented by inds.

%ind = min(inds); %to get min dose
if isempty(inds)
    ans = 0;
else
    ans = sum(doseBinsV(inds) .* volsHistV(inds)) / sum(volsHistV(inds));
    %ans = doseBinsV(ind); %to get min dose
end
ans = ans/txFraction;
return;