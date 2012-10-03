function hAxis = plot_octile(hAxis,y,mu)
%function hAxis = plot_octile(hAxis,y,mu)
%This function plots "octile plot" on the passed axis handle.
%INPUT: hAxis - axis handle to plot octile plot
%           y - 
%          mu - 
%OUTPUT: hAxis with octile plot
%
%APA 9/26/2006, extracted from DREES_GUI
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

ls=length(mu);
ln=8;
[xs,rx]=sort(mu);
ys=y(rx);
nBins=round(ls/ln);
for i=1:ln
    vec=(i-1)*nBins+[1:nBins];
    vec=vec(find(vec<=ls));
    yh(i)=mean(ys(vec));
    syh(i)=sqrt(yh(i)*(1-yh(i)))/sqrt(length(ys(vec)));
    xh(i)=mean(xs(vec));
    sxh(i)=sqrt(xh(i)*(1-xh(i)))/sqrt(length(xs(vec)));
    rxh(i)=(yh(i)-xh(i))/sqrt(xh(i)*(1-xh(i)));
end
rxh2=rxh.^2;
nextPlot = get(hAxis,'nextPlot');
set(hAxis,'nextPlot','add');
hError1 = errorbar(hAxis,[1:ln],yh,syh,'rx-');%'LineWidth',2.5,'MarkerSize',12);
hError2 = errorbar(hAxis,[1:ln],xh,sxh,'bo--');%'LineWidth',2.5,'MarkerSize',12);
plot(hAxis,[1:ln],xh+rxh2,'k:');%'LineWidth',2.5,'MarkerSize',12);
h = plot(hAxis,[1:ln],xh-rxh2,'k:');%'LineWidth',2.5,'MarkerSize',12);
xlabel('Patient Group')
ylabel('Prediction')
legend([hError1(1) hError2(1) h], 'Original','Prediction model','Squared-Residual Error')
axis(hAxis,[1 ln 0 1])
set(hAxis,'nextPlot',nextPlot);
