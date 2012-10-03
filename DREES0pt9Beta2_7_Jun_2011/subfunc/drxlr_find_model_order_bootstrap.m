function [model_order, rs_boot_grade, rs_test_grade, rs_true_grade_mean, rs_true_grade_se, percentNotConverged]=drxlr_find_model_order_bootstrap(x,y,outcome, min_order, max_order,nboot,test_method, logiter_param,logtol_param, lambda, guiflag, waitbar_handle)
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
        outcomet=outcome(indtest);
    else
        xt=x;
        yt=y;
        outcomet=outcome;
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
        rs_boot_grade(b,i-min_order+1)=spearman(mu_xc(:), outcomeb(:));
        mu_test=drxlr_logit_fun(xc_test(:,1:i),b_xc);
        rs_test_grade(b,i-min_order+1)=spearman(mu_test(:), outcomet(:));
    end
end

rs_boot_grade_mean=abs(mean(rs_boot_grade));
rs_boot_grade_std=1.96*std(rs_boot_grade);
rs_test_grade_mean=abs(mean(rs_test_grade));
rs_test_grade_std=1.96*std(rs_test_grade);
rs_true_grade_mean=rs_boot_grade_mean*(1-w)+rs_test_grade_mean*w;
rs_true_grade_se=(rs_boot_grade_std*(1-w)+rs_test_grade_std*w)/sqrt(nboot);
[max_rs,max_index]=max(rs_true_grade_mean); % an acceptable rs is >0!
model_order=max_index+min_order-1;

% print convergence information to a file
percentNotConverged = drxlr_writeConvergHistToFile(convergeState,'BOOTSTRAP_MODEL_ORDER_CONVERG.out');

return
