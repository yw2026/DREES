function hAxis = plot_roc(hAxis,y,Tstep,mu)
%function hAxis = plot_roc(hAxis,y,Tstep,mu)
%This function plots "roc plot" on the passed axis handle.
%INPUT: hAxis - axis handle to plot octile plot
%           y - 
%       Tstep -
%          mu - 
%OUTPUT: hAxis with roc plot
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

T=[1:-Tstep:0];
npos=sum(y);
nneg=sum(~y);
for i=1:length(T);
    muc = mu>=T(i);
    TPF(i)=sum(y(:).*muc(:))/npos;
    FPF(i)=sum(~y(:).*muc(:))/nneg;
end  % need still interpolation?
% TPF.*(1-FPF)
% nprc = 10;
% [cutoff,cutoff_roc]=drxlr_get_cutoff(x,y,nprc, T,cens)
Az=trapz(FPF,TPF);
plot(hAxis,FPF,TPF,'k-','LineWidth',1.5,'MarkerSize',12);
xlabel(hAxis,'False positive rate (1-Specificity)'),
ylabel(hAxis,'True positive rate (Sensitivity)')
axis(hAxis,[0 1 0 1])
str=['Az=',num2str(Az,2)];
text(0.65,0.5,str,'Color','k','parent',hAxis);