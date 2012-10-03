function actuarialPlot(hAxis,handles)
%function actuarialPlot(hAxis,handles)
%
%this function plots actuarial analysis on the passed hAxis
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

global stateS statC
indexS = statC{end};

delete(stateS.explore.miscHandles)
cla(hAxis);
reset(hAxis);
axes(hAxis);
stateS.explore.miscHandles = [];
set(hAxis,'visible','off')

for i=1:length(handles.SelectedVariableNames)
    varName{i}=handles.SelectedVariableNames{i};
end
[index,dummy] = listdlg('PromptString','Select a Variable:',...
    'SelectionMode','single',...
    'ListString',varName);

if dummy == 0
    return;
end
x=handles.dataX(:,index);
xname=varName{index};
prompt={'Enter Time-axis variable', 'Enter Event variable',  'Enter event identifier','Enter variable break point(s):'};
%obtain the name of time-variable
timeIndex = strmatch('Time',handles.fieldnames);
if isempty(timeIndex)
    timeStr = 'TimeAxis';
else
    timeStr = handles.fieldnames{timeIndex(1)};
end
def={1,1,'4',num2str(median(x))};
dlgTitle=['Survival break points for ',xname];
%answer=inputdlg(prompt,dlgTitle,1,def);
inputTypeC = {'popup','popup','edit','edit'};
varNamesC = fieldnames(statC{indexS.originalData});
inputQuestC = {varNamesC,varNamesC,'',''};
answer = inputdlgGUI('init',prompt,dlgTitle,inputTypeC,inputQuestC,def,handles,x,xname,hAxis);
% if ~isempty(answer)
% if ~isfield(handles,answer{1}) | ~isfield(handles,answer{2})
%     errordlg('Undefined Time axis or Event variables','Actuarial Survival');
% else
%     time=handles.(answer{1});
%     event=handles.(answer{2});
%     dp=str2num(answer{3});
%     bp=str2num(answer{4});
%     cens=event(:)==dp;
%     stateS.explore.axis = plot_actuarial_survival(stateS.explore.axis,x,bp,cens,time,xname);
%     stateS.explore.miscHandles = [stateS.explore.miscHandles legend(hAxis,[xname,'>',num2str(bp)],[xname,'<=',num2str(bp)])];
% end
% end
return;



