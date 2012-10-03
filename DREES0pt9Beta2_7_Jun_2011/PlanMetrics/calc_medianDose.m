function ans = calc_medianDose(doseBinsV, volsHistV, volumeType)
% Calculates the median dose for a given DVH
% The last argument 'volumeType' is ignored in this instance
%
%  MODIFICATION ALERT:  THIS FUNCTION IS UTILIZED BY THE DREXLER CODEBASE
%
%  Last modified: IEN 10/09
% 
%  Usage:  calc_medianDose(doseBinsV, volsHistV)
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


      ind = median(find([volsHistV~=0]));
      ind1 = floor(ind);
      ind2 = ceil(ind);
      ans = (doseBinsV(ind1) + doseBinsV(ind2))/2;

%       ind = length(volsHistV)/2;
%       ind1 = floor(ind);
%       ind2 = ceil(ind);
%       ans = (doseBinsV(ind1) + doseBinsV(ind2))/2;
      
return;
