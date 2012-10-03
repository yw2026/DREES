function plot_self_correlation(handles)
%function plot_self_correlation(handles)
%
%this function plots correlation-plots on from the passed handles
%
%APA 10/11/2006, extracted from DREES_GUI
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

axes(handles.variable_axis);  cla reset
xt=[handles.outcome(:),handles.dataX];
lx=size(xt,2);
for i=1:lx
    for j=1:lx
        [rs(i,j),prob(i,j)] = spearman(xt(:,i),xt(:,j));
    end
end
variables{1}=handles.radiol_model;
for i=2:lx
    variables{i}=handles.SelectedVariableNames{i-1};
end
imagesc(rs), axis image, colormap('jet') ,colorbar
set(handles.variable_axis,'Ytick',[1:size(rs,2)])
set(handles.variable_axis,'YtickLabel',variables);
set(handles.variable_axis,'XtickLabel','')
return
