function [mu,param_var,param_list,SelectedVariableNames,dataX,indEmpty]=tcp_analytical_models(handles, model_type)
% TCP analytical models
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

%% check for DVH selection
[data, selectedfield]=get_field_data(handles,'dvh_');
% if length(selectedfield)>1
%     [index,dummy] = listdlg('PromptString','Select a dvh:',...
%         'SelectionMode','single',...
%         'ListString',selectedfield);
% else
%     index=1;
% end
index = get(stateS.processData.listVar,'value');
dvh=data{index};
% Filter-out empty DVHs
indEmpty = [];
for i=1:length(dvh)
    if isempty(dvh{i})
        indEmpty = [indEmpty i];
    end
end
dvh(indEmpty) = [];
switch upper(model_type)
    case 'POISSON'
        prompt={'Enter D50 (Starting point):','Enter gamma50 (Starting point):' };
        def={'70','3.0 '};
        dlgTitle=['Poisson model parameters (Starting point)'];
        answer=inputdlg(prompt,dlgTitle,1,def);
        D50 = str2num(answer{1}); % position
        gamma50 = str2num(answer{2}); % slope
        ButtonName = questdlg('Do you wish to optimize the model parameters for your dataset?', ...
            'Optimize?', ...
            'Yes','No','No');
        y = handles.outcome;
        y(indEmpty) = [];
        if strcmpi(ButtonName,'Yes')
            x = fminsearch('poissonTCPobj',[D50 gamma50],[],dvh,y);
            %         x = fmincon('poissonTCPobj',[D50 gamma50],[],[],[],[],[10 0.1],[100 7],[],[],dvh,handles.outcome);
            D50 = x(1);
            gamma50 = x(2);
        end

%         % temporary (plot surface)----        
%         [D50all,gamma50all] = meshgrid(linspace(0,100,25),linspace(0.01,2,25));
%         D50allV     = D50all(:);
%         gamma50allV = gamma50all(:);
%         for i=1:length(D50allV)
%             fAllV(i) = poissonTCPobj([D50allV(i) gamma50allV(i)],dvh,handles.outcome);
%         end
%         fAll = reshape(fAllV,size(D50all));
%         figure, surf(D50all,gamma50all,fAll)        
%         % temporary ----
        
        for i = 1:length(dvh)
            %mu(i)= 0.5^(sum(dvh{i}(2,:).*2*gamma50*(1-dvh{i}(2,:)/D50)/0.6931)) ;
            %dataX(i)=calc_meanDose(data{i}(1,:), data{i}(2,:)); % select mdose as the X-variable
            mu(i)= 0.5^(sum(dvh{i}(2,:).*exp(2*gamma50*(1-dvh{i}(1,:)/D50)/0.6931)));
            dataX(i,:)=calc_meanDose(dvh{i}(1,:), dvh{i}(2,:)); % select mdose as the X-variable
        end        
        SelectedVariableNames={[selectedfield{index},'_mdose']};
        param_var=[D50, gamma50];
        param_list={'D50','gamma50'};
        
    case 'LQ' % linear quadratic
        prompt={'Enter Number of cell:','Enter alpha:',...
            'Enter beta:','Enter potential doubling time (days):'};
        def={'10^9','0.3','0.03','5'};
        dlgTitle=['LQ model parameters'];
        answer=inputdlg(prompt,dlgTitle,1,def);
        N = str2num(answer{1});
        alpha = str2num(answer{2});
        beta = str2num(answer{3});
        Tpot = str2num(answer{4});
        y = handles.outcome;
        y(indEmpty) = [];        
        ButtonName = questdlg('Do you wish to optimize the model parameters for your dataset?', ...
            'Optimize?', ...
            'Yes','No','No');
        if strcmpi(ButtonName,'Yes')
            x = fminsearch('lqTCPobj',[N alpha beta Tpot],[],dvh,y);
            %         x = fmincon('poissonTCPobj',[D50 gamma50],[],[],[],[],[10 0.1],[100 7],[],[],dvh,y);
            N = x(1);
            alpha = x(2);
            beta = x(3);
            Tpot = x(4);
        end
        
        %LB = [10e8 0.1 0.01 3];
        %UB = [10e10 0.5 0.05 7];
        %x = fmincon('lqTCPobj',[N alpha beta Tpot],[],[],[],[],LB,UB,[],[],dvh,y);
       
        for i = 1:length(dvh)
            D=sum(dvh{i}(2,:));
            S=exp(-((alpha+beta*handles.FractionSize(i))*D+0.6931*handles.TreatmentLength/Tpot));
            mu(i)=exp(-S*N);
            dataX(i,:)=calc_meanDose(data{i}(1,:), data{i}(2,:)); % select mdose as the X-variable
        end
        SelectedVariableNames={[selectedfield{index},'_mdose']};
        param_var=[N, alpha, beta, Tpot];
        param_list={'Number of cell','alpha','beta','potential doubling time (days):'};
    otherwise
        errordlg('Unknown TCP model!','Analytical TCP models')
end
