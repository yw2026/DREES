function statC = displayAnalyticalModel(statC)
%function statC = displayAnalyticalModel(statC,pval)
%use this function to display the analytical model
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
indexS = statC{end};

statC{indexS.dreesData}.data_model_param{1}='     Parameter   Value';
statC{indexS.dreesData}.data_model_param{2}='-----------------------------------';
for i=1:length(statC{indexS.dreesData}.ParamVar)
    statC{indexS.dreesData}.data_model_param{i+2}=sprintf('%16.16s   %0.2g',statC{indexS.dreesData}.ParamList{i},statC{indexS.dreesData}.ParamVar(i));
end
%statC{indexS.dreesData}.dataX=dataX(:);
%statC{indexS.dreesData}.SelectedVariableNames=SelectedVariableNames;
%statC{indexS.dreesData}.b=[];
set(stateS.model.paramList,'string',statC{indexS.dreesData}.data_model_param, 'fontname', 'courier new', 'fontsize',8);
