function ans = calc_stdDevDose(doseBinsV, volsHistV)
%Calculate the standard deviation of the dose for a given DVH.
%
%  Created: 6 Oct 06, JOD.
%
% Usage: calc_stdDevDose(doseBinsV, volsHistV)
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

    doseBinsMidPtsV = (doseBinsV(1:end-1)+doseBinsV(2:end))/2;
    meanDose = (sum(doseBinsMidPtsV.*volsHistV(1:end-1))+doseBinsV(end)*volsHistV(end))/sum(volsHistV);
    ans =  ( (sum((doseBinsMidPtsV - meanDose).^2 .* volsHistV(1:end-1))+ (doseBinsV(end) - meanDose)^2 * volsHistV(end)) /sum(volsHistV) )^0.5;
return;