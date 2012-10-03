function ans = calc_Vu(doseBinsV, volsHistV, dosePer, volumeType)
% Returns the lowest dose in x% of structure'
% given the DVH data and the parameter percent.
%  
%  MODIFICATION ALERT:  THIS FUNCTION IS UTILIZED BY THE DREES CODEBASE
%
%  Last modified: IME 1/07  (modified from Vx, where u is the percentage dose!)
%
%  Usage: calc_Vu(doseBinsV, volsHistV, dosePer, volumeType)
%
% volumeType
%  1 = fractional
%  anything else = absolute volumes
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


if ~exist('volumeType')
    volumeType = 0;
end

cumVolsV = cumsum(volsHistV);
cumVols2V  = cumVolsV(end) - cumVolsV;
maxDose=max(doseBinsV(:));
ind = min(find([doseBinsV/maxDose >= dosePer/100]));

if(dosePer==0)
    ans=cumVolsV(end);
else 
    if isempty(ind)
        ans = 0;
    else
        ans = cumVols2V(ind);
    end
end  

if(volumeType == 1)
    ans = ans/cumVolsV(end);
else
    warning('Vu is being calculated in absolute terms.');
end

return;

