% function [LL,g,H,gCD,HCD] = efron(b,surv_time,Zc,cens)
function [LL,g,HCD] = efron(b,surv_time,Zc,cens)
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

LL = -efron_LL(b,surv_time,Zc,cens);
g = -efron_grad(b,surv_time,Zc,cens);
% H = efron_hessian(b,surv_time,Zc,cens);

% %finite difference check for gradient
% db = 1e-4; %step size
% for i=1:length(b)
%     bp = b;
%     bp(i) = bp(i) + db;
%     bm = b;
%     bm(i) = bm(i) - db;
%     LLp = efron_LL(bp,surv_time,Zc,cens);
%     LLm = efron_LL(bm,surv_time,Zc,cens);
%     gCD(1,i) = (LLp-LLm)/2/db;
% end
    
%finite difference check for Hessian
db = 1e-4; %step size
for i=1:length(b)
    bp = b;
    bp(i) = bp(i) + db;
    bm = b;
    bm(i) = bm(i) - db;
    gp = efron_grad(bp,surv_time,Zc,cens);
    gm = efron_grad(bm,surv_time,Zc,cens);
    HCD(i,:) = -(gp-gm)/2/db;
end

function LL = efron_LL(b,surv_time,Zc,cens)
% Efron tie breaker
[uniq_surv_time,assocGroupStart,assocGroup] = unique(surv_time);
for i = 1:length(uniq_surv_time)
    assocInd_W1{i} = find((assocGroup == i) & cens);
    assocInd_W2{i} = find(assocGroup == i);
    numInGroup(i) = length(assocInd_W1{i});
    Zc_group(i,:) = sum(Zc(assocInd_W1{i},:),1);
    cens_group(i,:) = any(cens(assocInd_W2{i}));
end
W1 = Zc_group*b;
[n,p]=size(Zc);
W2=ones(length(uniq_surv_time),1);
for i=1:length(uniq_surv_time)
    for j = 1:numInGroup(i)
        W2(i) = W2(i) * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (j-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
    end        
end
LL = sum((W1-log(W2)).*cens_group);
return;

function g = efron_grad(b,surv_time,Zc,cens);
%gradient
[uniq_surv_time,assocGroupStart,assocGroup] = unique(surv_time);
for i = 1:length(uniq_surv_time)
    assocInd_W1{i} = find((assocGroup == i) & cens);
    assocInd_W2{i} = find(assocGroup == i);
    numInGroup(i) = length(assocInd_W1{i});
    Zc_group(i,:) = sum(Zc(assocInd_W1{i},:),1);
    cens_group(i,:) = any(cens(assocInd_W2{i}));
end
[n,p]=size(Zc);
for i=1:length(uniq_surv_time)
    for j=1:p
        num(i,j) = 0;
        allInGrp = 1:numInGroup(i);        
        for m = 1:numInGroup(i)
            allInGrpToCal = allInGrp;
            allInGrpToCal(m) = [];
            num_tmp(i,j) = sum(Zc(assocInd_W2{i}(1):end,j).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},j).*exp(Zc(assocInd_W1{i},:)*b));
            for mOther = allInGrpToCal
                num_tmp(i,j) = num_tmp(i,j) * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOther-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
            end
            num(i,j) = num(i,j) + num_tmp(i,j);
        end
        den(i,j) = 1;
        for m = 1:numInGroup(i)
            den(i,j) = den(i,j) * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
        end
    end
end
W2 = num./den;
g = sum((Zc_group-W2).*repmat(cens_group,1,p));

function H = efron_hessian(b,surv_time,Zc,cens);
%Hessian
[uniq_surv_time,assocGroupStart,assocGroup] = unique(surv_time);
for i = 1:length(uniq_surv_time)
    assocInd_W1{i} = find((assocGroup == i) & cens);
    assocInd_W2{i} = find(assocGroup == i);
    numInGroup(i) = length(assocInd_W1{i});
    Zc_group(i,:) = sum(Zc(assocInd_W1{i},:),1);
    cens_group(i,:) = any(cens(assocInd_W2{i}));
end
[n,p]=size(Zc);
for i=1:length(uniq_surv_time)
    for j=1:p
        for k=1:p
            %num1(i,j,k) = numInGroup(i) * sum(Zc(assocInd{i}(1):end,j).*Zc(assocInd{i}(1):end,k).*exp(Zc(assocInd{i}(1):end,:)*b));
            %diagonal terms for addition
            num1(i,j,k) = 0;
            allInGrp = 1:numInGroup(i);
            for m = 1:numInGroup(i)
                allInGrpToCal = allInGrp;
                allInGrpToCal(m) = [];
                num_tmp1 = sum(Zc(assocInd_W2{i}(1):end,j).*Zc(assocInd_W2{i}(1):end,k).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},j).*Zc(assocInd_W1{i},k).*exp(Zc(assocInd_W1{i},:)*b));
                for mOther = allInGrpToCal
                    num_tmp1 = num_tmp1 * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOther-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
                end
                num1(i,j,k) = num1(i,j,k) + num_tmp1;
            end
            %non-diagonal terms for addition
            allInGrp = 1:numInGroup(i);
            for m = 1:numInGroup(i)
                allInGrpToCal = allInGrp;
                allInGrpToCal(m) = [];
                num_tmp2 = sum(Zc(assocInd_W2{i}(1):end,j).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},j).*exp(Zc(assocInd_W1{i},:)*b));
                for mOther = allInGrpToCal                    
                    num_tmp2 = num_tmp2 * ( sum(Zc(assocInd_W2{i}(1):end,k).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOther-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},k).*exp(Zc(assocInd_W1{i},:)*b)) );
                    allInGrpToCalRem = allInGrpToCal;
                    allInGrpToCalRem(allInGrpToCal==mOther) = [];
                    for mOtherRem = allInGrpToCalRem
                        num_tmp2 = num_tmp2 * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOtherRem-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
                    end
                end
                num1(i,j,k) = num1(i,j,k) + num_tmp2;
            end

            %num2(i,j,k) = numInGroup(i) * sum(Zc(assocInd{i}(1):end,j).*exp(Zc(assocInd{i}(1):end,:)*b));
            num2(i,j,k) = 0;
            allInGrp = 1:numInGroup(i);
            for m = 1:numInGroup(i)
                allInGrpToCal = allInGrp;
                allInGrpToCal(m) = [];
                num_tmp = sum(Zc(assocInd_W2{i}(1):end,j).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},j).*exp(Zc(assocInd_W1{i},:)*b));
                for mOther = allInGrpToCal
                    num_tmp = num_tmp * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOther-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
                end
                num2(i,j,k) = num2(i,j,k) + num_tmp;
            end

            %num3(i,j,k) = sum(Zc(assocInd{i}(1):end,k).*exp(Zc(assocInd{i}(1):end,:)*b));
            num3(i,j,k) = 0;
            allInGrp = 1:numInGroup(i);
            for m = 1:numInGroup(i)
                allInGrpToCal = allInGrp;
                allInGrpToCal(m) = [];
                num_tmp = sum(Zc(assocInd_W2{i}(1):end,k).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},k).*exp(Zc(assocInd_W1{i},:)*b));
                for mOther = allInGrpToCal
                    num_tmp = num_tmp * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOther-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
                end
                num3(i,j,k) = num3(i,j,k) + num_tmp;
            end

            %den(i,j,k) = sum(exp(Zc(assocInd{i}(1):end,:)*b));
            den(i,j,k) = 1;
            for m = 1:numInGroup(i)
                den(i,j,k) = den(i,j,k) * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
            end
            
        end
    end
end

W1=num1./den;
W2=num2.*num3./den.^2;
H=-squeeze(sum(W1-W2,1));
H=H+eye(size(H))*1e-10;






function H = efron_SA(b,surv_time,Zc,cens);
%%%% efron gradient and Hessian combined
%gradient
[uniq_surv_time,assocGroupStart,assocGroup] = unique(surv_time);
for i = 1:length(uniq_surv_time)
    assocInd_W1{i} = find((assocGroup == i) & cens);
    assocInd_W2{i} = find(assocGroup == i);
    numInGroup(i) = length(assocInd_W1{i});
    Zc_group(i,:) = sum(Zc(assocInd_W1{i},:),1);
    cens_group(i,:) = any(cens(assocInd_W2{i}));
end
[n,p]=size(Zc);
for i=1:length(uniq_surv_time)
    for j=1:p
        num(i,j) = 0;
        allInGrp = 1:numInGroup(i);        
        for m = 1:numInGroup(i)
            allInGrpToCal = allInGrp;
            allInGrpToCal(m) = [];
            num_tmp(i,j) = sum(Zc(assocInd_W2{i}(1):end,j).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},j).*exp(Zc(assocInd_W1{i},:)*b));
            for mOther = allInGrpToCal
                num_tmp(i,j) = num_tmp(i,j) * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOther-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
            end
            num(i,j) = num(i,j) + num_tmp(i,j);
        end
        den(i,j) = 1;
        for m = 1:numInGroup(i)
            den(i,j) = den(i,j) * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
        end
    end
    for k=1:p
            %diagonal terms for addition
            num1(i,j,k) = 0;
            allInGrp = 1:numInGroup(i);
            for m = 1:numInGroup(i)
                allInGrpToCal = allInGrp;
                allInGrpToCal(m) = [];
                num_tmp1 = sum(Zc(assocInd_W2{i}(1):end,j).*Zc(assocInd_W2{i}(1):end,k).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},j).*Zc(assocInd_W1{i},k).*exp(Zc(assocInd_W1{i},:)*b));
                for mOther = allInGrpToCal
                    num_tmp1 = num_tmp1 * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOther-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
                end
                num1(i,j,k) = num1(i,j,k) + num_tmp1;
            end
            %non-diagonal terms for addition
            allInGrp = 1:numInGroup(i);
            for m = 1:numInGroup(i)
                allInGrpToCal = allInGrp;
                allInGrpToCal(m) = [];
                num_tmp2 = sum(Zc(assocInd_W2{i}(1):end,j).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (m-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},j).*exp(Zc(assocInd_W1{i},:)*b));
                for mOther = allInGrpToCal                    
                    num_tmp2 = num_tmp2 * ( sum(Zc(assocInd_W2{i}(1):end,k).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOther-1)/numInGroup(i)*sum(Zc(assocInd_W1{i},k).*exp(Zc(assocInd_W1{i},:)*b)) );
                    allInGrpToCalRem = allInGrpToCal;
                    allInGrpToCalRem(allInGrpToCal==mOther) = [];
                    for mOtherRem = allInGrpToCalRem
                        num_tmp2 = num_tmp2 * ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) - (mOtherRem-1)/numInGroup(i)*sum(exp(Zc(assocInd_W1{i},:)*b)) );
                    end
                end
                num1(i,j,k) = num1(i,j,k) + num_tmp2;
            end
    end
end
W2 = num./den;
g = sum((Zc_group-W2).*repmat(cens_group,1,p));


return;
