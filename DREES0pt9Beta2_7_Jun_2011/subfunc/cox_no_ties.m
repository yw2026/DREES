function [LL,g,H] = cox_no_ties(b,surv_time,Zc,cens)
% function [LL,g,H,gCD,HCD] = cox_no_ties(b,surv_time,Zc,cens)
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

LL = -cox_LL(b,surv_time,Zc,cens);
g = -cox_grad(b,surv_time,Zc,cens);
H = -cox_hessian(b,surv_time,Zc,cens);

% %finite difference check for gradient
% db = 1e-4; %step size
% for i=1:length(b)
%     bp = b;
%     bp(i) = bp(i) + db;
%     bm = b;
%     bm(i) = bm(i) - db;
%     LLp = cox_LL(bp,surv_time,Zc,cens);
%     LLm = cox_LL(bm,surv_time,Zc,cens);
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
%     gp = cox_grad(bp,surv_time,Zc,cens);
%     gm = cox_grad(bm,surv_time,Zc,cens);
%     HCD(i,:) = (gp-gm)/2/db;
% end

return;

function LL = cox_LL(b,surv_time,Zc,cens)
% cox model partial likelihood function
% assume no ties problem otherwise use Efron Approximation
% to be added tie breakers--
[n,p]=size(Zc);
W1=Zc*b;
W2=zeros(n,1);
for i=1:n
    W2(i)=sum(exp(Zc(i:end,:)*b));
end
LL=sum((W1-log(W2)).*cens);
return

function g = cox_grad(b,surv_time,Zc,cens)
% cox model partial likelihood gradient function
% assume no ties problem otherwise use Efron Approximation
[n,p]=size(Zc);
for i=1:n
    for j=1:p
        num(i,j)=sum(Zc(i:end,j).*exp(Zc(i:end,:)*b));
        den(i,j)=sum(exp(Zc(i:end,:)*b));
    end
end
W2=num./den;
g=sum((Zc-W2).*repmat(cens,1,p));
return

function H = cox_hessian(b,surv_time,Zc,cens)
% cox model partial likelihood Hessian function
% assume no ties problem otherwise use Efron Approximation
[n,p]=size(Zc);
for i=1:n
    for j=1:p
        for k=1:p
            num1(i,j,k)=sum(Zc(i:end,j).*Zc(i:end,k).*exp(Zc(i:end,:)*b))*cens(i);
            num2(i,j,k)=sum(Zc(i:end,j).*exp(Zc(i:end,:)*b))*cens(i);
            num3(i,j,k)=sum(Zc(i:end,k).*exp(Zc(i:end,:)*b))*cens(i);
            den(i,j,k)=sum(exp(Zc(i:end,:)*b));
        end
    end
end

W1=num1./den;
W2=num2.*num3./den.^2;
H=-squeeze(sum(W1-W2,1));
H=H+eye(size(H))*1e-10;
return