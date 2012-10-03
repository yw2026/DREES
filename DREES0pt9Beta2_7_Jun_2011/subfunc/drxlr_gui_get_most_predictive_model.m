function [best_model, addset]=drxlr_gui_get_most_predictive_model(x, y, outcome, model_order, nboot, variables,test_method,logiter_param,logtol_param, lambda, model_type, varargin)
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

%Preparing the GUI functions (including waitbar) to be passed to the subfunction

h = waitbar(0,['Model parameters selection of order=', num2str(model_order)]);
set(h,'name','Automated logistic regression');

% Letting the subfunction know it's running in a gui-framework
guiflag = 1;

%Calling the subfunction and passing the gui information
switch upper(model_type)
    case 'LOGISTIC'
        [best_model, xmodel, freq, freqindx, addset] = drxlr_find_model_params(x, y, outcome, model_order, nboot, variables, test_method, logiter_param, logtol_param, lambda, guiflag, h);
    case 'HAZARD'
        surv_time = varargin{1};
        [best_model, xmodel, freq, freqindx, addset] = drxlr_find_hazard_model_params(surv_time,x,outcome,model_order, nboot, variables,test_method,lambda,guiflag, h);
end
close(h);

%%% tree collapsing?  %%%
button = questdlg('Selection of model parameters is done. What do you want to do?',...
    'Automated Model Option',...
    'Tree reduction of top models',...
    'Best single model',...
    'Best single Model');

if strcmp(button, 'Tree reduction of top models')
    %GUI code to prepare to use the underlying function to tree reduce the models
    numTopModels=min(5,size(xmodel,2));
    correlation_cutoff=0.75;
    prompt={['Enter number of top models: <= ',num2str(numTopModels)], 'Enter correlation cutoff:'};
    def={num2str(numTopModels), num2str(correlation_cutoff)};
    dlgTitle=['Tree reduction of top models of order ',num2str(model_order)];
    answer=inputdlg(prompt,dlgTitle,1,def);
    numTopModels=str2num(answer{1});
    correlation_cutoff=str2num(answer{2});
    
    % Calling the sub-function which has no GUI code in it
    [num_models, model_list, model_freq] = drxlr_apply_tree_reduction(x,model_order,freq,xmodel, numTopModels, correlation_cutoff);
    
    % Preparing the output from the above sub-function to be re-incorporated
    % into the GUI process
    for i=1:num_models
        model_desc='';
        for j=1:model_order
            model_desc=[model_desc,' ',variables{model_list(j,i)}];
        end
        selectedModels{i}=model_desc;
    end
    vec=[1:num_models];
    figure, barh(vec,model_freq/sum(model_freq)*100)
    xlabel('Percentage frequency'), ylabel('Models')
    set(gca,'Ytick',vec,'YDir','reverse');
    set(gca,'YtickLabel',selectedModels);
    
    [index,dummy] = listdlg('PromptString','Select a model to analyze:',...
        'SelectionMode','single',...
        'ListString',selectedModels);
    best_model=model_list(:,index);
elseif strcmp(button,'Best single model')
    [freqmax, indfreq]=max(freq);
    best_model=xmodel(:,indfreq);
else
    errordlg('Unknown Selection!','get_most_predictive_model');
end

return
