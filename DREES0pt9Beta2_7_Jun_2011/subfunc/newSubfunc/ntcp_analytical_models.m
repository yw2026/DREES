function [mu,param_var,param_list,SelectedVariableNames,dataX,indEmpty]=ntcp_analytical_models(handles, model_type)
% NTCP analytical models
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
    case 'LKB'   % sigmoidal dose response (Lyman, Rad Res, 1985)
        prompt={'Enter EUD exponent (a)','Enter Slope (m):','Enter D50:' };
        def={'1','0.4','30'};
        dlgTitle=['LKB model parameters'];
        answer=inputdlg(prompt,dlgTitle,1,def);
        a=str2num(answer{1});
        m=str2num(answer{2});
        D50=str2num(answer{3}); % position of dose-response
        % optimize model parameters
        y = handles.outcome(:)>=str2num(get(stateS.processData.endptSel,'String'));
        y(indEmpty) = [];
        ButtonName = questdlg('Do you wish to optimize the model parameters for your dataset?', ...
            'Optimize?', ...
            'Yes','No','No');
        if strcmpi(ButtonName,'Yes')
            x = fminsearch('lkbNTCPobj',[a m D50],[],dvh,y);
            a = x(1);
            m = x(2);
            D50 = x(3);
        end

        for i = 1:length(dvh)
            gmd(i)= calc_EUD(dvh{i}(1,:), dvh{i}(2,:), a);
        end
        mu=drxlr_probit((gmd-D50)/(m*D50));
        dataX=gmd(:); % select gmd as the X-variable
        SelectedVariableNames={[selectedfield{index},'_geud']};
        param_var=[a m D50];
        param_list={'EUD exponent (a)','Slope (m)','D50' };
    case 'CV' % critical volume method for population (Stavrev A.Niemierko)
        prompt={'Enter critical relative volume:','Enter population variability (sigma):',...
            'Enter D50:','Enter gamma50:'};
        def={'0.23','0.25','25','0.74'};
        dlgTitle=['CV model parameters'];
        answer=inputdlg(prompt,dlgTitle,1,def);
        mu_cr=str2num(answer{1});
        sigma=str2num(answer{2});
        D50=str2num(answer{3});
        gamma50=str2num(answer{4});
        % optimize model parameters
        y = handles.outcome(:)>=str2num(get(stateS.processData.endptSel,'String'));
        y(indEmpty) = []; 
        ButtonName = questdlg('Do you wish to optimize the model parameters for your dataset?', ...
            'Optimize?', ...
            'Yes','No','No');
        if strcmpi(ButtonName,'Yes')
            x = fminsearch('cvNTCPobj',[mu_cr sigma D50 gamma50],[],dvh,y);
            mu_cr = x(1);
            sigma = x(2);
            D50 = x(3);
            gamma50 = x(4);
        end

        for i = 1:length(dvh)
            mu_d(i)= sum(dvh{i}(2,:).*drxlr_probit(1.4142*pi*gamma50*log(dvh{i}(1,:)/D50)))/sum(dvh{i}(2,:));
        end
        mu=drxlr_probit((-log(-log(mu_d))+log(-log(mu_cr)))/sigma);
        dataX=mu_d(:); % select mu_d as the X-variable
        SelectedVariableNames={[selectedfield{index},'_mu_d']};
        param_var=[mu_cr, sigma, D50, gamma50];
        param_list={'crit. rel. vol.','populat. var. (sigma):',...
            'D50','gamma50'};
    otherwise
        errordlg('Unknown NTCP model!','Analytical NTCP models')
end

return
