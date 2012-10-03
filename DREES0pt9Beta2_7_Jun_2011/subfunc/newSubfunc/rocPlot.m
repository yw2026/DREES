function handles = rocPlot(hAxis,handles)
%function handles = rocPlot(hAxis,handles)
%
%this function plots roc-plot on the passed hAxis
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

y = handles.outcome(:)>=str2num(get(stateS.processData.endptSel,'String'));
prompt={'Enter the threshold step value:'};
Tstep=0.1;
def={num2str(Tstep)};
dlgTitle='ROC Analysis';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
if isempty(answer)
    return;
end
Tstep=str2num(answer{1});
plot_roc(hAxis,y,Tstep,handles.mu);
set(hAxis,'visible','on')
