function plotPC(hAxis,handles)
%function plotPC(hAxis,handles)
%
%this function plots Principle Components on the passed hAxis
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
x=handles.dataX;
if size(x,2)<2
    errordlg('Num of variables should be at least 2','PCA analysis');
    return
end
delete(stateS.explore.miscHandles)
cla(hAxis);
reset(hAxis);
axes(hAxis);
stateS.explore.miscHandles = [];

gr = str2num(get(stateS.processData.endptSel,'String'));
[zscores,pcs, sigmas] = drxlr_apply_linear_pca(x);
ind1=find(handles.outcome(:)>=gr);
ind0=find(handles.outcome(:)<gr);
set(hAxis,'nextPlot','add')
stateS.explore.miscHandles = [stateS.explore.miscHandles plot(zscores(ind0,1),zscores(ind0,2),'bo')];
stateS.explore.miscHandles = [stateS.explore.miscHandles plot(zscores(ind1,1),zscores(ind1,2),'rx')];
stateS.explore.miscHandles = [stateS.explore.miscHandles xlabel(hAxis,'First Principal Component')];
stateS.explore.miscHandles = [stateS.explore.miscHandles ylabel(hAxis,'Second Principal Component')];
stateS.explore.miscHandles = [stateS.explore.miscHandles legend(hAxis,'Patients without RT complications','Patients with RT complications')];
