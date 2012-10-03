function [num_models, model_list, model_freq] =drxlr_apply_tree_reduction(x, model_order, freq, xmodel, numTopModels, correlation_cutoff)
%  multiple models tree reduction
%
% Originally written by Issam El Naqa, 2005
% Extracted for general use by AJH, 2005
%
%  Usage: [num_models, model_list, model_freq] = drxlr_apply_tree_reduction(x, model_order, freq,xmodel, variables)
%  NOTE:  model_freq is UNIMPLEMENTED 

%  This function should have the ultimate frequencies of the models that have been
%  reduced in the following variable, but this is currently unimplemented
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


model_freq = [];

[dummy, inds]=sort(freq); inds=inds(end:-1:1);
freqs=freq(inds);
xmodels=xmodel(:,inds);
model_list=xmodels(:,1:numTopModels);
num_models=size(model_list,2);
model_freq=freqs(1:numTopModels); % just truncate the rest!
i=1;
while i < num_models % top-> bottom
    disim_ij=[1:i];  % collect dissimilar i, j models
    for j=i+1:num_models
        test_model=model_list(:,j);
        test_corr=zeros(1,model_order);
        for m=1:model_order
            for n=1:length(test_model)
                xsp=spearman(x(:,model_list(m,i)),x(:,test_model(n)));
                
                if abs(xsp)> correlation_cutoff
                    test_corr(m)=1;
                    test_model(n)=[];
                    break;
                end
            end
        end
        if sum(test_corr)<model_order % not similar model
            disim_ij=[disim_ij,j];
        else
            model_freq(i)=model_freq(i)+model_freq(j); % same model has been repeated
        end
    end
    model_list=model_list(:,disim_ij);
    model_freq=model_freq(disim_ij);
    num_models=size(model_list,2);
    i=i+1;
end

return