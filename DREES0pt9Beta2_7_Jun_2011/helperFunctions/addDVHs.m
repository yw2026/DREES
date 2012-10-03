function dBase = addDVHs(dBase, field1, field2);
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

for i = 1:length(dBase), 
  dvh1 = dBase(i).(field1);
  dvh2 = dBase(i).(field2);
  l1 = length(dvh1);
  l2 = length(dvh2);
  
  if(l1<l2), 
    dvh1(1, l1+1:l2) = dvh2(1, l1+1:l2);
    dvh1(2, l1+1:l2) = 0;
  elseif(l2<l1), 
    dvh2(1, l2+1:l1) = dvh1(1, l2+1:l1);
    dvh2(2, l2+1:l1) = 0;
  end
  
  dvhnew(1, :) = dvh1(1, :);
  dvhnew(2, :) = dvh1(2, :) + dvh2(2, :);

  dBase(i).ipsiPlusContra = dvhnew;
  clear dvh1 dvh2 dvhnew;
end
