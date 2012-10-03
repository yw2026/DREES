function [model_order, aic] = drxlr_find_model_order_analytical(x,y,outcome, min_order, max_order, mfold_cv,test_method,logiter_param,logtol_param, lambda, guiflag, waitbar_handle,aic_flag)
%  Get the model order using multi-fold cross-validation
%
%  Originally written by Issam El Naqa 2003-2005
%  Extracted by AJH 2005 into a gui wrapper class and processing subfunction
%
%  Usage:  [model_order, rs_test_grade_mean, rs_test_grade_std] = drxlr_find_model_order_mcv(x,y,outcome, min_order, max_order, mfold_cv,test_method,logiter_param,logtol_param, guiflag, waitbar_handle)
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


%  If not being called from a gui, setting the guiflag to false
if ~exist('guiflag')
    guiflag = 0;
end

[n,pa] = size(x);
fold_size=floor(n/mfold_cv);
vec=[1:n];
m=1;
addset{m}=zeros(pa-1,pa);
xc = [];
for i=1:max_order
    StatTest=zeros(1,pa);
    for j=1:size(x,2)
        temp=sum(addset{m});
        if (temp(j)== 0)
            xd=[xc,x(:,j)];
            p=size(xd,2);
            [mu_f, b_f, pvals, z, LR, convState]=drxlr_apply_logistic_regression(xd,y,logiter_param,logtol_param);
            convergeState{m}{i,j} = convState;
            StatTest(j)=drxlr_stat_test(test_method,z(p),p,LR, lambda);
        end
    end
    [dumm,indx]=max(StatTest);
    addset{m}(i:end,indx)=1;
    xc=[xc,x(:,indx)];
end
for i=min_order:max_order
    %% apply to CV samples
    [mu_xc,b_xc, pvals,z,LR]=drxlr_apply_logistic_regression(xc(:,1:i),y,logiter_param,logtol_param);
    %%% apply to m-fold samples
    switch upper(aic_flag)
        case 'AIC'
            if n>100
                aic(i) = -2*LR+2*p;
            else
                aic_temp = -2*LR+2*p;
                aic(i) = aic_temp+2*p*(p+1)/(n-p-1);
            end
        case 'BIC'
            aic(i) = -2*LR + p*log(n);
    end
end

[min_aic,min_index]=min(aic);
model_order=min_index+min_order-1;

% print convergence information to a file
percentNotConverged = drxlr_writeConvergHistToFile(convergeState,'ANALYTICAL_MODEL_ORDER_CONVERG.out');

return;
