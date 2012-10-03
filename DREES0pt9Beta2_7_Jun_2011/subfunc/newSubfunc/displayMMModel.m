function statC = displayMMModel(statC,pval)
%function displayMMModel(statC{indexS.dreesData})
%use this function to display the multi-metric model
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

strmodel2={};
temp='Y = ';
for q=1:length(statC{indexS.dreesData}.b)-1;
    temp=[temp,num2str(statC{indexS.dreesData}.b(q),'%0.3g'),'*X',num2str(q),' ','+',' '];
    if mod(q,6)==0
        strmodel2={strmodel2{:},temp};
        temp='';
    end
end
temp=[temp,num2str(statC{indexS.dreesData}.b(end),'%0.3g')];
allRadBioModels = get(stateS.processData.radbioType,'String');
strmodel = allRadBioModels{get(stateS.processData.radbioType,'Value')};

allAlgos = get(stateS.processData.modelAlgo,'string');
modelAlgo = allAlgos{get(stateS.processData.modelAlgo,'value')};

strmodel3={[modelAlgo,' ',strmodel,' model'],[strmodel2{:},temp]};
strmodel3 = chopString(strmodel3,35);

set(stateS.model.equation,'String',strmodel3,'fontsize',8,'fontweight','normal')
statC{indexS.dreesData}.data_model_param{1}='Var.       Name      p-value';
statC{indexS.dreesData}.data_model_param{2}='-----------------------------';
for i=1:length(statC{indexS.dreesData}.b)-1
    statC{indexS.dreesData}.data_model_param{i+2}=sprintf('X%d %14.12s     %0.2g',i,statC{indexS.dreesData}.SelectedVariableNames{i},pval(i));
end
set(stateS.model.paramList,'string',statC{indexS.dreesData}.data_model_param, 'fontname', 'courier new', 'fontsize',8);
