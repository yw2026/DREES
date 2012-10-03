function [cutoff_logrank, p_adjusted]=drxlr_get_cutoff_logrank(x, t,cens,nprc,prclimit)
%function [cutoff,cutoff_roc]=drxlr_get_cutoff_logrank(x,nprc, t,cens)
%
%This function returns cutoff point for the passed variable that has
%maximum separation based on survival analysis.
% Note: prclimit should be sensibly selected to have balanced number of
% data.
%INPUT: x        - each column represents a separate variable.
%       t        - time for survival analysis.
%       cens     - censors.
%       nprc     - number of percentiles to divide the data into.
%       prclimit - 1x2 vector representing. prclimit(1) is the lower
%                  quantile, prclimit(2) is the upper quantile.
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
if ~exist('prclimit')
    prclimit=[0.25,0.75];
end
quantiles = linspace(prclimit(1),prclimit(2),nprc);
for i=1:num_var
    prc = quantile(x(:,i),quantiles);
    p=[];
    for j=1:nprc
        ind1 = find(x(:,i)>=prc(j));
        ind0 = find(x(:,i)<prc(j));        
        p(j) = drxlr_logrank(t(ind1),cens(ind1,i),t(ind0), cens(ind0));
    end
    [p_min, ind_min] = min(p);
    cutoff_logrank(i) = prc(ind_min);
    p_adjusted(i) = p_min*length(prc); % Benferroni correction (conservative)
end
