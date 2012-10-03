function handles = contourPlot(hAxis,handles)
%function handles = contourPlot(hAxis,handles)
%
%this function plots contour-plot on the passed hAxis
%
%APA 10/30/2006, extracted from DREES_GUI
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

[index,dummy] = listdlg('PromptString','Select Ordinate Variable(s):',...
    'SelectionMode','single',...
    'ListString',handles.SelectedVariableNames);
if dummy == 0
    return;
end
var1=handles.dataX(:,index);
[index,dummy] = listdlg('PromptString','Select Abscissa Variable(s):',...
    'SelectionMode','single',...
    'ListString',handles.SelectedVariableNames);
if dummy == 0
    return;
end
var2=handles.dataX(:,index);
plot_contour(hAxis,var1,var2,handles.b);
stateS.predict.miscHandles = [stateS.predict.miscHandles colorbar('peer',hAxis)];
stateS.predict.miscHandles = [stateS.predict.miscHandles xlabel(hAxis,'Linear Combination of Abscissa  Variables')];
stateS.predict.miscHandles = [stateS.predict.miscHandles ylabel(hAxis,'Linear Combination of  Ordinate Variables')];
set(hAxis,'visible','on')
