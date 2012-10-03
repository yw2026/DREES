function [plothandle] = drex_next_octile_plot(fig_handle, primary_mu_sort, mu, ln, linespecstring)
% y: original grade
% mu is your predictor
%DREX subfunction 
%Written by Issam El Naqa 2003-2005
%Extracted for generalized use 2005, AJH
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

%forces current figure for the following plots to the passed handle
figure(fig_handle);

ls=length(mu);
if ~exist('ln')
    ln=8;
end
xs = mu(primary_mu_sort);
nBins=round(ls/ln);

for i=1:ln
    vec=(i-1)*nBins+[1:nBins];
    vec=vec(find(vec<=ls));
    xh(i)=mean(xs(vec));
    sxh(i)=sqrt(xh(i)*(1-xh(i)))/sqrt(length(xs(vec)));
end

plothandle = errorbar([1:ln],xh,sxh,linespecstring);%'LineWidth',2.5,'MarkerSize',12);
% set(handles.prediction_axis,'LineWidth',2.5,'MarkerSize',12);
xlabel('Patient Group')
ylabel('Prediction')
axis([1 ln 0 1])

return