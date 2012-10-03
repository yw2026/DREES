function [Fq,timesq]=drxlr_surv_rate(time, cens)
% computation of the survival rate using the Kaplan-Meier Estimator
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

n = length(time);
[times,ind] = sort(time); % should be in ascending order
cens = cens(ind);
freq = ones(1,n);
totcumfreq = n-cumsum(freq)+1;
t=cens>0;
adfreq=totcumfreq(t);
times = times(t);
S=cumprod(1 - 1./adfreq);
times = [0, times];
F = [1, S];
[timesq Ind]=unique(times);
Fq=F(Ind);
return
