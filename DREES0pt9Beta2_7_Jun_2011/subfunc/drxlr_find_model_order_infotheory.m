function [model_order, aic_true, aic_true_mean, aic_true_se, percentNotConverged] = drxlr_find_model_order_infotheory(x,y,outcome, min_order, max_order,nboot,test_method, logiter_param,logtol_param, lambda, aic_flag)
%  Get the model order using bootstrap (+0.632)
%
%  Originally written by Issam El Naqa 2003-2005
%  Extracted by AJH 2005 into a gui wrapper class and processing subfunction
%
%  Usage:  [model_order, rs_test_grade] = 
%           drxlr_find_model_order_bootstrap(x,y,outcome, min_order, max_order,test_method,logiter_param,logtol_param, guiflag, waitbar_handle)
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
y=y(:);
% bootstrapping initialization
bootsam = drxlr_pseudo_sample(n,n,nboot);
w=0.632;
for b=1:nboot

    if guiflag == 1
        waitbar(b/nboot,waitbar_handle);
    end
    
    xb=x(bootsam(:,b),:);
    yb=y(bootsam(:,b));
    outcomeb=outcome(bootsam(:,b));
    if b~=1
        indtest=setdiff([1:n]',bootsam(:,b));
        xt=x(indtest,:);
        yt=y(indtest);        
    else
        xt=x;
        yt=y;        
    end
    addset{b}=zeros(pa-1,pa);
    xc_boot=[];
    xc_test=[];
    for i=1:max_order
        StatTest=zeros(1,pa);
        for j=1:size(xb,2)
            temp=sum(addset{b});
            if (temp(j)== 0)
                xd=[xc_boot,xb(:,j)];
                p=size(xd,2);
                [mu_f{i,j}, b_f{i,j}, pvals, z,LR, convState]=drxlr_apply_logistic_regression(xd,yb,logiter_param,logtol_param);
                convergeState{b}{i,j} = convState;
                StatTest(j)=drxlr_stat_test(test_method,z(p),p,LR, lambda);
            end
        end
        [dumm,indx]=max(StatTest);
        addset{b}(i:end,indx)=1;
        xc_boot=[xc_boot,xb(:,indx)];
        xc_test=[xc_test,xt(:,indx)];
    end
    for i=min_order:max_order         %% apply to bootstrap samples
        [mu_xc,b_xc, pvals,z,LR]=drxlr_apply_logistic_regression(xc_boot(:,1:i),yb,logiter_param,logtol_param);
        [aic(b,i-min_order+1), aics(b,i-min_order+1), bic(b,i-min_order+1)] = model_select(LR,i,size(xc_boot,1));
        %do same for test data
        [mu_xc_test,b_xc_test, pvals_test,z_test,LR_test]=drxlr_apply_logistic_regression(xc_test(:,1:i),yt,logiter_param,logtol_param);
        [aic_test(b,i-min_order+1), aics_test(b,i-min_order+1), bic_test(b,i-min_order+1)] = model_select(LR_test,i,size(xc_test,1));        
    end
end

aic_mean            = mean(aic);
aic_se              = std(aic)/sqrt(nboot);
aics_mean           = mean(aics);
aics_se             = std(aics)/sqrt(nboot);
bic_mean            = mean(bic);
bic_se              = std(bic)/sqrt(nboot);

%Calculate for test dataset
aic_mean_test            = mean(aic_test);
aic_se_test              = std(aic_test)/sqrt(nboot);
aics_mean_test           = mean(aics_test);
aics_se_test             = std(aics_test)/sqrt(nboot);
bic_mean_test            = mean(bic_test);
bic_se_test              = std(bic_test)/sqrt(nboot);

% [min_aic,min_index] = min(aic_mean); % an acceptable rs is >0!
% model_order(1)      = min_index+min_order-1;
% [min_aics,min_index]= min(aics_mean); % an acceptable rs is >0!
% model_order(2)      = min_index+min_order-1;
% [min_bic,min_index] = min(bic_mean); % an acceptable rs is >0!
% model_order(3)      = min_index+min_order-1;

%Combined grade
aic_true        = aic_mean*(1-w)+aic_mean_test*w;
aics_true       = aics_mean*(1-w)+aics_mean_test*w;
bic_true        = bic_mean*(1-w)+bic_mean_test*w;

aic_true_mean   = aic_mean*(1-w)+aic_mean_test*w;
aic_true_se     = (aic_se*(1-w)+aic_se_test*w)/sqrt(nboot);
aics_true_mean  = aics_mean*(1-w)+aics_mean_test*w;
aics_true_se    = (aics_se*(1-w)+aics_se_test*w)/sqrt(nboot);
bic_true_mean   = bic_mean*(1-w)+bic_mean_test*w;
bic_true_se     = (bic_se*(1-w)+bic_se_test*w)/sqrt(nboot);

[min_aic,min_index] = min(aic_true_mean); % an acceptable rs is >0!
model_order(1)      = min_index+min_order-1;
[min_aics,min_index]= min(aics_true_mean); % an acceptable rs is >0!
model_order(2)      = min_index+min_order-1;
[min_bic,min_index] = min(bic_true_mean); % an acceptable rs is >0!
model_order(3)      = min_index+min_order-1;

switch aic_flag
    case 'aic'        
        
    case 'aics'
        aic_true         = aics_true;
        aic_true_mean    = aics_true_mean;
        aic_true_se      = aics_true_se;
        
    case 'bic'
        aic_true         = bic_true;
        aic_true_mean    = bic_true_mean;
        aic_true_se      = bic_true_se;        
end

figure, errorbar([min_order:max_order], aic_true_mean, aic_true_se)
xlabel('Model order'), ylabel(aic_flag)
title('Info. Theory Bootstrap Model Order Estimation')

% print convergence information to a file
percentNotConverged = drxlr_writeConvergHistToFile(convergeState,'BOOTSTRAP_MODEL_ORDER_CONVERG.out');

return

function [aic, aicc, bic] = model_select(LLF,NumParams,NumObs)
% model selection criteria
aic=-2*LLF+2*NumParams;
aicc=aic+2*NumParams*(NumParams+1)/(NumObs-NumParams-1);
bic=-2*LLF+NumParams*log(NumObs);
return
