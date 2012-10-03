function [b, stats]=drxlr_apply_coxphreg(surv_time, cens, Z, binit, Z0, NumIter, TOL)
% Estimation of the Cox proportional hazard model (assuming no tie issues)
% Check for Breslow when ties are considered
% based on the description Klein (Survival Analysis, '97)
% Written By Issam El Naqa, Date: 04/05/04
% LM: APA,9/29/06: Found/Corrected a bug in convergence check for N-R.
% Input:
% - surv_time: vector of survival time
% - cens: vector of an observation is censored "0" or complete "1"
% - Z: matrix of covariables in columns
% - Z0: a row vector of base line values for Z (default: median of Z columns
% Output:
%  -b: coefficients of the cox model
%  - stats: a structure of associated coefficients statistics
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


[n,p]=size(Z);
if (length(surv_time) ~= n) | (length(cens) ~= n)
    error('There is a mismatch in input dimensions in coxphreg!');
end
if nargin==4
     b0=binit(:);
else
     b0=zeros(p,1);
end

if nargin==5
      Zc= Z-repmat(Z0,n,1); % centered covariates
else
    Zc=Z; % one could subtract median or mean for standarization
end
% order data by time
[surv_time,ind] = sort(surv_time); % should in ascending order
cens = cens(ind);
cens=cens(:);
Zc=Zc(ind,:);
%%% apply Newton Raphson optimization to solve the partial likelihood function
if ~exist('TOL')
    TOL=1e-6;
end
if ~exist('NumIter')
    NumIter=20;
end

%solve for model coefficients : b
fun = 'cox_no_ties';
[b,LL,g,H] = fmin_NR(fun,b0,NumIter,TOL,surv_time,Zc,cens);
%compure statistics
stats = drxlr_getHazardStats(b,LL,H);

return

% [b,Lb,Gb,Ib]=Apply_NR(b0,surv_time,Zc,cens,NumIter,TOL);
% % compute statistics
% stats.likelihood=Lb;
% C=inv(Ib);
% se = sqrt(max(eps,diag(C)));
% stats.se = se;
% stats.z = b ./ se; % Wald test for significance
% %stats.p = 2 * tcdf(-abs(stats.t), dfe);
% stats.p = 2 * normcdf(-abs(stats.z)); % two tail p-value (symmetric)
% return

% function [b,Lb,Gb,Ib]=Apply_NR(b0,surv_time,Zc,cens,MAXITER,TOL)
% % Simple Newton Raphson routine
% b=b0;
% Lb0=cox_LL(b,surv_time,Zc,cens);
% for i=1:MAXITER
%     Gb = cox_grad(b,surv_time,Zc,cens);
%     Ib=-cox_hessian(b,surv_time,Zc,cens);
%     temp=Gb*inv(Ib);
%     b=b+temp(:);
%     Lb=cox_LL(b,surv_time,Zc,cens);
%     test_conv=(Lb-Lb0)/abs(Lb0);
%     if test_conv<TOL
%            disp(['Newton Raphson converged successfully in ', num2str(i),' iterations.']);
%         break;
%     else
%         Lb0=Lb;
%     end
% end
%     
% return
%      
%     
% 
% function LL = cox_LL(b,surv_time,Zc,cens)
% % cox model partial likelihood function
% % assume no ties problem otherwise use Efron Approximation
% % to be added tie breakers--
% [n,p]=size(Zc);
% W1=Zc*b;
% W2=zeros(n,1);
% for i=1:n
%     W2(i)=sum(exp(Zc(i:end,:)*b));
% end
% LL=sum((W1-log(W2)).*cens);
% return
% 
% function g = cox_grad(b,surv_time,Zc,cens)
% % cox model partial likelihood gradient function
% % assume no ties problem otherwise use Efron Approximation
% [n,p]=size(Zc);
% for i=1:n
%     for j=1:p
%         num(i,j)=sum(Zc(i:end,j).*exp(Zc(i:end,:)*b));
%         den(i,j)=sum(exp(Zc(i:end,:)*b));
%     end
% end
% W2=num./den;
% g=sum((Zc-W2).*repmat(cens,1,p));
% return
% 
% function H = cox_hessian(b,surv_time,Zc,cens)
% % cox model partial likelihood Hessian function
% % assume no ties problem otherwise use Efron Approximation
% [n,p]=size(Zc);
% for i=1:n
%     for j=1:p
%         for k=1:p
%             num1(i,j,k)=sum(Zc(i:end,j).*Zc(i:end,k).*exp(Zc(i:end,:)*b))*cens(i);
%             num2(i,j,k)=sum(Zc(i:end,j).*exp(Zc(i:end,:)*b))*cens(i);
%             num3(i,j,k)=sum(Zc(i:end,j).*exp(Zc(i:end,:)*b))*cens(i);
%             den(i,j,k)=sum(exp(Zc(i:end,:)*b));
%         end
%     end
% end
% 
% W1=num1./den;
% W2=num2.*num3./den.^2;
% H=-squeeze(sum(W1-W2,1));
% H=H+eye(size(H))*1e-10;
% return
% 
