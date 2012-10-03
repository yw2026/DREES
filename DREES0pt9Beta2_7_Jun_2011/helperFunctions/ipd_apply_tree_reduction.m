function [modelsSorted, freqSorted]=apply_tree_reduction_preprocess(x,freq,xmodel,correlation_cutoff);
% x is matrix of datavalues for each patient
% npatients by nvariables
% xmodel is model_order x numBootstrapModels
% xmodel in this function is xmodel{i} returned from
% DREX_GUI_subfunctions_params
% and freq is freq{i}
% Returns models and frequencies in sorted order, least to greatest
% Then to get the variables:
% variables(modelsSo
% usage:
%   [modelsSorted, freqSorted]=apply_tree_reduction_preprocess(x,freq,xmodel,correlation_cutoff);
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


model_order = size(xmodel,1);
numTopModels = size(xmodel, 2);
crosscor = zeros(size(x, 2), size(x, 2));
for i = 1:size(x, 2), 
    for j = 1:size(x, 2), 
        crosscor(i, j) = spearman(x(:,i), x(:,j));
    end
end
for i  = 1:size(x, 2), 
    crosscor(i, i) = 1;
end
crosscor = abs(crosscor);
%correlation_cutoff = 0.75;
%crosscor = abs(crosscor)>correlation_cutoff;
for i = 1:size(x, 2), 
    crosscorList{i} = find(crosscor(i, :)>correlation_cutoff);
end

[dummy, inds]=sort(freq); inds=inds(end:-1:1);
freqs=freq(inds);
xmodels=xmodel(:,inds);
model_list=xmodels(:,1:numTopModels);
num_models=size(model_list,2);
freq_list = freqs(1:numTopModels);
modelsToKeep = [];
freqToKeep = [];
i=1;
c=1;
tic
while size(model_list, 2)>1 % top-> bottom
    %disp(size(model_list, 2))
    
        current_model = model_list(:, i);
        modelsToKeep = [modelsToKeep current_model];
        model_list(:,i) = [];
        freqToKeep = [freqToKeep freq_list(i)];
        freq_list(i) = [];
        
        paramList = [];
        for n = 1:model_order,
            if(~isempty(crosscorList{current_model(n)})), 
                paramList = [paramList crosscorList{current_model(n)}];
            end
        end
        modelsToCheck = [];
        if(~isempty(paramList))
            for n = 1:length(paramList)
                [jnk, ind] = find(model_list(:,2:end)==paramList(n));
                modelsToCheck = [modelsToCheck; ind];
            end
        end
       modelsToCheck = unique(modelsToCheck);
        
       removeModelIndex = [];
        for n = 1:length(modelsToCheck), 
            %setxor(current_model, model_list(:, modelsToCheck(n)))
            modelInd = 1:model_order;
            for m1 = 1:model_order,
                [val, ind] = max(crosscor(current_model(m1), model_list(modelInd, modelsToCheck(n))));
                if(val<correlation_cutoff)
                    break
                else
                    modelInd(ind) = [];
                end
                if(isempty(modelInd))
                    removeModelIndex = [removeModelIndex n];
                end
            end
        end
        
            
            
       
        
       % nModelsToCheck(c) = length(modelsToCheck);
       % c=c+1;
        % find correlated models
        % remove correlated models from current list
        % is i implicitly included in removeModelIndex?
        %removeModelIndex = i;
        modelsToKeep = [modelsToKeep];
        model_list(:, [removeModelIndex]) = [];
        freqToKeep(end) = sum([freqToKeep(end) freq_list([removeModelIndex])]);
        freq_list(removeModelIndex) = [];
end
% one model left; add it to the end of the list
modelsToKeep = [modelsToKeep model_list];
freqToKeep = [freqToKeep freq_list];
toc
       
[freqSorted, j] = sort(freqToKeep); 
modelsSorted = modelsToKeep(:,j);

% freqSorted =  freqSorted(end:-1:1);
% modelsSorted = modelsSorted(:, end:-1:1);

