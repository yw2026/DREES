function [S0,uniq_surv_time,cens_group,assocGroup] = drxlr_getSurvivalFun(b,surv_time,Zc,cens)
%function S0 = drxlr_getSurvivalFun(b,surv_time,Zc,cens)
%
%This function returns the survival function S. 
%
%APA 9/15/2006. Referance: John P. Klein, Survival Analysis, 1997 
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

%obtain unique survival times
[uniq_surv_time,assocGroupStart,assocGroup] = unique(surv_time);
uniq_surv_time = uniq_surv_time(:)';
for i = 1:length(uniq_surv_time)
    assocInd_W1{i} = find((assocGroup == i) & cens);
    assocInd_W2{i} = find(assocGroup == i);
    numInGroup(i) = length(assocInd_W1{i});
    Zc_group(i,:) = sum(Zc(assocInd_W1{i},:),1);
    cens_group(i,:) = any(cens(assocInd_W2{i}));
end

% Eq. 8.6.1 in John P. Klein, Survival Analysis, 1997
[n,p] = size(Zc);
W = zeros(1,length(uniq_surv_time));
for i = 1:length(uniq_surv_time)
    W(i) = sum(exp(Zc(assocInd_W2{i}(1):end,:)*b));
end

% Eq. 8.6.2 in John P. Klein, Survival Analysis, 1997
H0 = cumsum(numInGroup./W);

%Baseline survival function, Eq. 8.6.3 in John P. Klein, Survival Analysis, 1997
S0 = exp(-H0);
