function boxPlot(hAxis,handles)
%function boxPlot(hAxis,handles)
%
%this function plots box & whisker plot on the passed hAxis
%
%APA 10/27/2006, extracted from DREES_GUI
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

global stateS

for i=1:length(handles.SelectedVariableNames)
    varName{i}=handles.SelectedVariableNames{i};
end
[index,dummy] = listdlg('PromptString','Select Variables:',...
    'SelectionMode','multiple',...
    'ListString',varName);
if dummy == 0
    return;
end

delete(stateS.explore.miscHandles)
cla(hAxis);
reset(hAxis);
axes(hAxis);
stateS.explore.miscHandles = [];

x=handles.dataX(:,index);
xname=varName(index);
drxlr_boxwhisPlot(x,xname,hAxis);
