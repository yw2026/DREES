function plotSelfCorrelation(hAxis,handles)
%function plot_self_correlation(handles)
%
%this function plots correlation-plots on the passed hAxis
%
%APA 10/11/2006, extracted from DREES_GUI
%LM: APA, 10/26/06, passed axis handle as input.
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
allRadBioModels = get(stateS.processData.radbioType,'String');
delete(stateS.explore.miscHandles(find(ishandle(stateS.explore.miscHandles))))
cla(hAxis);
reset(hAxis);
axes(hAxis);
stateS.explore.miscHandles = [];
xt=[handles.outcome(:),handles.dataX];
lx=size(xt,2);
for i=1:lx
    for j=1:lx
        [rs(i,j),prob(i,j)] = spearman(xt(:,i),xt(:,j));
    end
end
variables{1} = allRadBioModels{get(stateS.processData.radbioType,'Value')};
for i=2:lx
    variables{i}=handles.SelectedVariableNames{i-1};
end
for i=1:length(rs)
    rs(i,i) = NaN;
    for j=i:lx
        rs(i,j) = NaN;
    end    
end
stateS.explore.miscHandles = [stateS.explore.miscHandles imagesc(abs(rs))];
set(hAxis,'nextPlot','add')
for i=1:lx
    for j=i:lx
        yV = [i-0.5 i-0.5 i+0.5 i+0.5 i-0.5];
        xV = [j-0.5 j+0.5 j+0.5 j-0.5 j-0.5];
        patch(xV,yV,'w','parent',hAxis,'EdgeColor','w')
    end    
    for j=1:i
        if sign(rs(i,j))==-1
            yV = [i-0.5 i-0.5 i+0.5 i+0.5 i-0.5];
            xV = [j-0.5 j+0.5 j+0.5 j-0.5 j-0.5];
            plot(xV,yV,'k--','linewidth',3,'parent',hAxis)
        end
    end
end
axis(hAxis,'image')
colormap(hAxis,'jet');
stateS.explore.miscHandles = [stateS.explore.miscHandles colorbar('peer',hAxis)];
set(hAxis,'Ytick',[1:size(rs,2)])
set(hAxis,'YtickLabel',variables);
if length(variables) < 6
    rot = 25;
else
    rot = 90;
end
for i=1:length(variables)    
    text(i,length(variables)+0.8,variables{i},'Rotation',rot,'parent',hAxis,'horizontalAlignment','right','fontSize',9,'interpreter','none')
end
set(hAxis,'XtickLabel','')
set(hAxis,'visible','on')
return
