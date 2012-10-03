function [cutoff_roc,TPF,FPF] = drxlr_get_cutoff_roc(x,y,t)
%function [cutoff_roc,TPF,FPF] = drxlr_get_cutoff_roc(x,y,t)
%
%This function returns cutoff point for the passed variable that has
%maximum separation based on roc plot.
%
%IEN, APA 9/11/2006
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

num_var=size(x,2);
for i=1:num_var
    max_x(i) = max(x(:,i));
    [As,Bs] = getScale01(min(x(:,i)),max(x(:,i)));
    Xs = scaleX(x(:,i),As,Bs);
    [TPF{i}, FPF{i}] = roc(Xs,y,t);
    [Th(i),ind_max] = max(TPF{i}.*(1-FPF{i}));
    cutoff_roc(i) = unScaleX(t(ind_max),As,Bs);
end
return;


function [As,Bs] = getScale01(XL,XU)
% returns coefficients A and B to scale x-data from 0 to 1
% APA

%Method:
% xs=a+x*b
% 0=a+XL*b
% 1=a+XU*b

%Non-matrix form
% for i=1:length(XData(1,:)) % number of variables
%     bs(i)=1/(max(XData(:,i))-min(XData(:,i)));
%     as(i)=1-bs(i)*max(XData(:,i));
% end

%Matrix Form
Bs=1./(XU-XL);
As=1-Bs.*XU;
return;
%---------------------------------------

function Xs = scaleX(X,As,Bs)
%scaleX.m : Scale X between 0 and 1, given the scaling coefficienta A and B.
%APA
Ndata=length(X(:,1));
E=ones(Ndata,1);
Xs=X.*(E*Bs)+(E*As);
return;
%---------------------------------------

function X = unScaleX(Xscaled,As,Bs)
%unScaleX.m : Un-scale X to physical units, given the scaling coefficienta A and B.
%APA
Ndata = length(Xscaled(:,1));
E = ones(Ndata,1);
X = (Xscaled - E*As)./(E*Bs);
return;
%---------------------------------------

function [TPF, FPF] = roc(mu,y,T)
%returns True Positive Fraction and False Positive Fraction for scaled input
%variable x.
npos=sum(y);
nneg=sum(~y);
for i=1:length(T)
    muc = mu >= T(i);
    TPF(i) = sum(y(:).*muc(:))/npos;
    FPF(i) = sum(~y(:).*muc(:))/nneg;
end  % need still interpolation?
return;
%---------------------------------------
