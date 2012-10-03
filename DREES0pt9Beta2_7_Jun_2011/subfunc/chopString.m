function strmodel3 = chopString(strmodel3,lenToChop)
%function strmodel3 = chopString(strmodel3,lenToChop)
%
% chops 2nd cell of strmodel3 into separate cells containing strings of length lenToChop
% Input: strmodel3 containing 2 cells
% output: strmodel3 containing 1 + number of chopped cells.
%
% APA, 07/07/06
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

modelTxt = strmodel3{2};
indexTxt = 1;
while length(modelTxt) >= lenToChop*(indexTxt-1)+1
    len = min(length(modelTxt),lenToChop*indexTxt);
    strmodel3{indexTxt + 1} = modelTxt(lenToChop*(indexTxt-1)+1 : len);
    indexTxt = indexTxt + 1;
end
