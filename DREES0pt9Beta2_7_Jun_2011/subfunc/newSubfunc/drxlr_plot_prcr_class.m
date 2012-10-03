function [avgpr, pr, cr]=drxlr_plot_prcr_class(hAxis, g, y, Tstep)
% Precision-recall plotting routine for classification
% Written by Issam El Naqa
% Date: 04/29/07
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

if ~exist('Tstep')
    Tstep=0.1;
end
T=[1:-Tstep:0];
npos=sum(y);
nneg=sum(~y);
for i=1:length(T);
    muc=g>=T(i);
    TP=sum(y(:).*muc(:));
    FP=sum(~y(:).*muc(:));
    cr(i)=TP/npos;
    if TP+FP == 0
        pr(i)=1;
    else
        pr(i)=TP/(TP+FP);
    end
end  % need still interpolation?
avgpr=mean(pr);
plot(hAxis,cr,pr,'k-','LineWidth',1.5,'MarkerSize',12)
xlabel(hAxis,'Recall'), ylabel(hAxis,'Precision')
axis(hAxis,[0 1 0 1])
str=['Average precision=',num2str(avgpr,2)];
text(0.45,0.8,str,'Color','k','parent',hAxis);
return


