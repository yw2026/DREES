function addset= drxlr_simple_bootstrap_analysis(x, y, nboot, test_method, logiter_param,logtol_param,lambda, guiflag, waitbar_handle)
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

% select best model of certain order based on bootstrapping
[n,pa] = size(x);
y=y(:);

% bootstrapping initialization
bootsam = drxlr_pseudo_sample(n,n,nboot);
bootsam=[[1:n]',bootsam]; % 1st column is the whole data...
for b=1:nboot+1
    if guiflag == 1
        waitbar(b/(nboot+1),waitbar_handle);
    end
    xb=x(bootsam(:,b),:);
    yb=y(bootsam(:,b));
    addset{b}=zeros(pa-1,pa);
    xc=[];
    for i=1:size(xb,2)
        StatTest=zeros(1,pa);
        for j=1:size(xb,2)
            temp=sum(addset{b},1);
            if (temp(j)== 0) % variable wasn't selected before?
                xd=[xc,xb(:,j)];
                p=size(xd,2);
                [mu_f{i,j}, b_f{i,j}, pval, z,LR, convState]=drxlr_apply_logistic_regression(xd,yb,logiter_param,logtol_param);
                convergeState{b}{i,j} = convState;
                StatTest(j)=drxlr_stat_test(test_method,z(p),p, LR, lambda);
            end
        end
        [dumm,indx]=max(StatTest);
        addset{b}(i:end,indx)=1;
        xc=[xc,xb(:,indx)];
    end
end

% print convergence information to a file
percentNotConverged = drxlr_writeConvergHistToFile(convergeState,'BOOTSTRAP_MODEL_CONVERG');

return

