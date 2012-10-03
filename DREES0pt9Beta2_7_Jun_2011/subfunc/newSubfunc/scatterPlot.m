function scatterPlot(hAxis,handles)
%function scatterPlot(hAxis,handles)
%
%this function plots scatter-plots on the passed hAxis
%
%APA 10/26/2006, extracted from DREES_GUI
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

%select abcissa and ordinate
[index,dummy] = listdlg('PromptString','Select Ordinate Variable:',...
    'SelectionMode','single',...
    'ListString',handles.SelectedVariableNames);
if dummy == 0
    return;
end
var1=handles.dataX(:,index);
nvar1=handles.SelectedVariableNames{index};
[index,dummy] = listdlg('PromptString','Select Abscissa Variable',...
    'SelectionMode','single',...
    'ListString',handles.SelectedVariableNames);
if dummy == 0
    return;
end
var2=handles.dataX(:,index);
nvar2=handles.SelectedVariableNames{index};
delete(stateS.explore.miscHandles)
cla(hAxis);
reset(hAxis);
axes(hAxis);
stateS.explore.miscHandles = [];
greater_than_flag_val = get(stateS.processData.endptSign,'value');
grade_cutoff = str2num(get(stateS.processData.endptSel,'String'));
if greater_than_flag_val==1
    y = handles.outcome(:)>=grade_cutoff;
else
    y = handles.outcome(:)<=grade_cutoff;
end
set(hAxis,'nextPlot','add')
stateS.explore.miscHandles = [stateS.explore.miscHandles plot(hAxis,var1,var2,'k.','MarkerSize',6)];
stateS.explore.miscHandles = [stateS.explore.miscHandles plot(hAxis,var1(y),var2(y),'ro','MarkerSize',6)];
stateS.explore.miscHandles = [stateS.explore.miscHandles xlabel(hAxis,nvar1,'interpreter','none')];
stateS.explore.miscHandles = [stateS.explore.miscHandles ylabel(hAxis,nvar2,'interpreter','none')];
stateS.explore.miscHandles = [stateS.explore.miscHandles legend(hAxis,'No complication','With complication')];
