function [data, selectedfield]=get_field_data(handles,field)
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

%% get the data and the name of a particular field
fieldnames = fields(handles);
selectedfield={};
m=1;
for i=1:length(fieldnames)
    if(findstr(fieldnames{i}, field))
        selectedfield{m}=fieldnames{i};
        data{m}=handles.(fieldnames{i});
        m=m+1;
    end
end
if isempty(selectedfield)
    h = errordlg('No field found','get_field_data');
end
return
