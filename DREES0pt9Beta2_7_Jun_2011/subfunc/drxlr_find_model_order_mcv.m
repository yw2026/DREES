function [model_order, rs_test_grade_mean, rs_test_grade_std, percentNotConverged] = drxlr_find_model_order_mcv(x,y,outcome, min_order, max_order, mfold_cv,test_method,logiter_param,logtol_param, lambda, guiflag, waitbar_handle)
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
for m=1:mfold_cv
    if guiflag == 1
        waitbar(m/mfold_cv,waitbar_handle);
    end

    indtest=(m-1)*fold_size+[1:fold_size];
    excess=n-max(indtest);
    if excess < 0 % circular round
        indtest=[indtest(1:fold_size+excess),1:abs(excess)];
    end
    indtrain=setdiff(vec,indtest);
    xtrain=x(indtrain,:);
    ytrain=y(indtrain);ytrain=ytrain(:);
    outtrain=outcome(indtrain);outtrain=outtrain(:);
    xm=x(indtest,:);
    ym=y(indtest);
    outcomem=outcome(indtest);outcomem=outcomem(:);
    addset{m}=zeros(pa-1,pa);
    xc_train=[];
    xc_test=[];
    for i=1:max_order
        StatTest=zeros(1,pa);
        for j=1:size(xtrain,2)
            temp=sum(addset{m});
            if (temp(j)== 0)
                xd=[xc_train,xtrain(:,j)];
                p=size(xd,2);
                [mu_f, b_f, pvals, z, LR, convState]=drxlr_apply_logistic_regression(xd,ytrain,logiter_param,logtol_param);
                convergeState{m}{i,j} = convState;
                StatTest(j)=drxlr_stat_test(test_method,z(p),p,LR, lambda);
            end
        end
        [dumm,indx]=max(StatTest);
        addset{m}(i:end,indx)=1;
        xc_train=[xc_train,xtrain(:,indx)];
        xc_test=[xc_test,xm(:,indx)];
    end
    for i=min_order:max_order
        %% apply to CV samples
        [mu_xc,b_xc, pvals,z,LR]=drxlr_apply_logistic_regression(xc_train(:,1:i),ytrain,logiter_param,logtol_param);
        %%% apply to m-fold samples
        mu_test=drxlr_logit_fun(xc_test(:,1:i),b_xc);
        rs_test_grade(m,i-min_order+1)=spearman(mu_test(:), outcomem(:));
    end
end

rs_test_grade_mean=mean(rs_test_grade);
rs_test_grade_std=1.96*std(rs_test_grade); % 95% CI

[max_rs,max_index]=max(rs_test_grade_mean);
model_order=max_index+min_order-1;

% print convergence information to a file
percentNotConverged = drxlr_writeConvergHistToFile(convergeState,'MCV_MODEL_ORDER_CONVERG.out');

return;
