function [SelectedVariables, xsel, addset]=apply_auto_logistic_regression(x,y,outcome,variables,order_sel_method,min_order, max_order,nboot_order, mfold_cv, nboot_param,test_method, logiter_param,logtol_param, lambda)
% Extracted out of DREES_GUI
%
%APA, 10/30/06
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

%logistic regression w/ model order selection
if (max_order>min_order) & (max_order>1)
    switch order_sel_method
        %  Breakpoint to extract data from DREES_GUI for script
        %  processing should go HERE!
        case 1 % LOO-CV
            model_order = drxlr_gui_get_model_order_cv(x,y,outcome,min_order, max_order,test_method,logiter_param,logtol_param, lambda);
        case 2 % bootstrap (+0.63)
            model_order = drxlr_gui_get_model_order_bootstrap(x,y,outcome,min_order, max_order,nboot_order,test_method, logiter_param,logtol_param, lambda);
        case 3 % M-fold-cross validation
            model_order = drxlr_gui_get_model_order_mcv(x,y,outcome,min_order, max_order, mfold_cv, test_method, logiter_param,logtol_param, lambda);
        case 4 % AIC
            model_order = drxlr_gui_get_model_order_analytical(x,y,outcome,min_order, max_order, mfold_cv, test_method, logiter_param,logtol_param, lambda,'aic');
        case 5 % BIC
            model_order = drxlr_gui_get_model_order_analytical(x,y,outcome,min_order, max_order, mfold_cv, test_method, logiter_param,logtol_param, lambda,'bic');
        case 6 % AIC Bootstrap
            model_order = drxlr_find_model_order_infotheory(x,y,outcome,min_order, max_order, mfold_cv, test_method, logiter_param,logtol_param, lambda,'aic');
        case 7 % AICS Bootstrap
            model_order = drxlr_find_model_order_infotheory(x,y,outcome,min_order, max_order, mfold_cv, test_method, logiter_param,logtol_param, lambda,'aics');
        case 8 % BIC Bootstrap
            model_order = drxlr_find_model_order_infotheory(x,y,outcome,min_order, max_order, mfold_cv, test_method, logiter_param,logtol_param, lambda,'bic');
        otherwise
            errordlg('Unknown model order selection method!','Auto Logistic Regression');
    end
else
    model_order=max_order;
end
[best_model, addset]=drxlr_gui_get_most_predictive_model(x,y,outcome, model_order, nboot_param,variables,test_method, logiter_param,logtol_param, lambda,'LOGISTIC');
xsel=x(:,best_model);
SelectedVariables=variables(best_model);
return