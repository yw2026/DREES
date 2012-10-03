% function [LL,g,H,gCD,HCD] = breslow(b,surv_time,Zc,cens)
function [LL,g,H] = breslow(b,surv_time,Zc,cens)
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

LL = -breslow_LL(b,surv_time,Zc,cens);
g = -breslow_grad(b,surv_time,Zc,cens);
H = -breslow_hessian(b,surv_time,Zc,cens);

% %finite difference check for gradient
% db = 1e-4; %step size
% for i=1:length(b)
%     bp = b;
%     bp(i) = bp(i) + db;
%     bm = b;
%     bm(i) = bm(i) - db;
%     LLp = breslow_LL(bp,surv_time,Zc,cens);
%     LLm = breslow_LL(bm,surv_time,Zc,cens);
%     gCD(1,i) = (LLp-LLm)/2/db;
% end
%     
% %finite difference check for Hessian
% db = 1e-4; %step size
% for i=1:length(b)
%     bp = b;
%     bp(i) = bp(i) + db;
%     bm = b;
%     bm(i) = bm(i) - db;
%     gp = breslow_grad(bp,surv_time,Zc,cens);
%     gm = breslow_grad(bm,surv_time,Zc,cens);
%     HCD(i,:) = (gp-gm)/2/db;
% end


function LL = breslow_LL(b,surv_time,Zc,cens);
% Breslow tie breaker
[uniq_surv_time,assocGroupStart,assocGroup] = unique(surv_time);
for i = 1:length(uniq_surv_time)
    assocInd_W1{i} = find((assocGroup == i) & cens);
    assocInd_W2{i} = find(assocGroup == i);
    numInGroup(i) = length(assocInd_W1{i});
    Zc_group(i,:) = sum(Zc(assocInd_W1{i},:),1);
    cens_group(i,:) = any(cens(assocInd_W2{i}));
end
%calcullate numerator for partial LL
W1 = Zc_group*b;
%calcullate denominator for partial LL
[n,p] = size(Zc);
W2 = zeros(length(uniq_surv_time),1);
for i = 1:length(uniq_surv_time)
    W2(i) = ( sum(exp(Zc(assocInd_W2{i}(1):end,:)*b)) ) ^ numInGroup(i);
end
LL = sum((W1-log(W2)).*cens_group);
return;


function g = breslow_grad(b,surv_time,Zc,cens);
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
        num(i,j) = numInGroup(i) * sum(Zc(assocInd_W2{i}(1):end,j).*exp(Zc(assocInd_W2{i}(1):end,:)*b));
        den(i,j) = sum(exp(Zc(assocInd_W2{i}(1):end,:)*b));
    end
end
W2 = num./den;
g = sum((Zc_group-W2).*repmat(cens_group,1,p));

return;

function H = breslow_hessian(b,surv_time,Zc,cens);
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
            num1(i,j,k) = numInGroup(i) * sum(Zc(assocInd_W2{i}(1):end,j).*Zc(assocInd_W2{i}(1):end,k).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) * cens_group(i);
            num2(i,j,k) = numInGroup(i) * sum(Zc(assocInd_W2{i}(1):end,j).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) * cens_group(i);
            num3(i,j,k) = sum(Zc(assocInd_W2{i}(1):end,k).*exp(Zc(assocInd_W2{i}(1):end,:)*b)) * cens_group(i);
            den(i,j,k) = sum(exp(Zc(assocInd_W2{i}(1):end,:)*b));
        end
    end
end

W1=num1./den;
W2=num2.*num3./den.^2;
H=-squeeze(sum(W1-W2,1));
H=H+eye(size(H))*1e-10;

return;
