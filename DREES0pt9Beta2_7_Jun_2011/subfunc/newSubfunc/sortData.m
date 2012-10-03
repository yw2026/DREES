function [sort_Data, sort_Class, each_class_no] = sortData(Data, Class,k)
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

[n,m] = size(Data);
sort_Data = zeros(n,m);
sort_Class = zeros(n,1);
each_class_no = size(k,1);

idx=1;
for i=0:k-1
    pos = find (Class==i);
    [no,o] = size(pos);
    each_class_no(i+1) = no;
    for j=1:no
        sort_Data(idx,:) = Data(pos(j),:);
        if(i==0)
            sort_Class(idx) = 1;
        else
            sort_Class(idx) = -1;
        end
        idx = idx+1;
    end
end