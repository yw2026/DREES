function [model_order, bic_boot_avg, bic_boot_std, bic]=drxlr_find_hazard_model_order_bootstrap_bic(surv_time,x,y, min_order, max_order,nboot,test_method, lambda, guiflag, waitbar_handle)
%  Get the model order using simple bootstrap
%
%  Originally written by Issam El Naqa 2003-2005
%  Extracted by AJH 2005 into a gui wrapper class and processing subfunction
%  Using information theory (BIC) with bootstrap to find model order...
%  Combine Wald and Likelihood to forward selection of parameters
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
bootsam = [[1:n]',drxlr_pseudo_sample(n,n,nboot)];

for b=1:nboot+1       
    xb=x(bootsam(:,b),:);
    yb=y(bootsam(:,b));
    tb=surv_time(bootsam(:,b));
    addset{b}=zeros(pa-1,pa);
    numVar = size(xb,2);
    xc_boot=[];
    for i=1:max_order
        StatTest=zeros(1,pa);
        for j=1:numVar
            if guiflag == 1
                waitbar(((b-1)*max_order*numVar + (i-1)*numVar + j) / ((nboot+1)*max_order*numVar),waitbar_handle,['Automated Hazard Modeling... boot# ',num2str(b),', order# ',num2str(i),', var# ',num2str(j)]);
            end
            temp=sum(addset{b},1);
            if (temp(j)== 0)
                xd=[xc_boot,xb(:,j)];
                p=size(xd,2);
                [b_f, stats_f]=drxlr_apply_coxphreg(tb, yb, xd, zeros(p,1), median(xd));
                StatTest(j)=drxlr_stat_test(test_method,stats_f.z(p),p,stats_f.likelihood, lambda);
            end
        end
        [dumm,indx]=max(StatTest);
        addset{b}(i:end,indx)=1;
        xc_boot=[xc_boot,xb(:,indx)];
    end
    for i=min_order:max_order         %% apply to bootstrap samples
        [b_xc, stats_xc]=drxlr_apply_coxphreg(tb, yb, xc_boot(:,1:i), zeros(i,1), median(xc_boot(:,1:i)));        
        bic(b,i)=drxlr_bic_model_select(stats_xc.likelihood,i+1,n);
    end
end

bic_boot_avg=mean(bic);
bic_boot_std=std(bic);

[min_bic,min_index]=min(bic_boot_avg); % lowest complexity...
model_order=min_index+min_order-1;
return
