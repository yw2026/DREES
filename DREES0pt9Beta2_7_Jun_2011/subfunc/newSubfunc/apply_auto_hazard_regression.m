function [SelectedVariables, xsel]=apply_auto_hazard_regression(surv_time, x,y,outcome,variables,min_order, max_order,nboot_order,nboot_param,test_method, coxiter_param,coxtol_param, lambda,guiflag, waitbar_handle)
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

% Cox regression w/ model order selection
if (max_order>min_order) & (max_order>1)
    %[model_order, bic_boot_avg, bic_boot_std, bic]=drxlr_find_hazard_model_order_bootstrap_bic(surv_time,x,y, min_order, max_order,nboot,test_method, coxiter_param, coxtol_param, lambda, guiflag, waitbar_handle);
    waitbar_handle = waitbar(0,'Automated hazard model...');
    [model_order, bic_boot_avg, bic_boot_std, bic] = drxlr_find_hazard_model_order_bootstrap_bic(surv_time,x,y, min_order, max_order,nboot_order,test_method, lambda, guiflag, waitbar_handle);
    close(waitbar_handle)
    figure, plot([min_order:max_order], bic_boot_avg)
    xlabel('Model order'), %ylabel('Spearman Correlation')
    title('Hazard Model Order Estimation')
else
    model_order=max_order;
end

%[best_model, xmodel, freqvals, freqindex] = drxlr_find_hazard_model_params(surv_time,x,outcome,model_order, nboot_order, variables,test_method,lambda);
[best_model, addset] = drxlr_gui_get_most_predictive_model(x,y,outcome,model_order, nboot_order, variables,test_method,[],[],lambda,'HAZARD',surv_time);
xsel=x(:,best_model);
SelectedVariables=variables(best_model);
return