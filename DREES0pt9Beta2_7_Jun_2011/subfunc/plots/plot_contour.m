function hAxis = plot_contour(hAxis,var1,var2,b)
%function hAxis = plot_contour(hAxis,var1,var2,b)
%This function plots "contour plot" on the passed axis handle.
%INPUT: hAxis - axis handle to plot contour plot
%        var1 - abcissa
%        var2 - ordinate
%           b - 
%OUTPUT: hAxis with contour plot
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

N1=500; N2=500;
min_dataX=min(var1);
max_dataX=max(var1);
min_dataY=min(var2);
max_dataY=max(var2);
lX=size(var1,2);
for i=1:lX
    X1V(:,i)=linspace(min_dataX(i),max_dataX(i),N1)';
end
lY=size(var2,2);
for i=1:lY
    X2V(:,i)=linspace(min_dataY(i),max_dataY(i),N2)';
end
bX=b(1:lX);
bY=b(lX+1:lX+lY);
b0=b(end);
XX=X1V*bX(:)/bX(1);
YY=X2V*bY(:)/bY(1);
BB=[bX(1);bY(1);b0];
[X1M,X2M]=meshgrid(XX,YY);
muM = logit3(X1M,X2M,BB); %muM=muM/max(muM(:));
MLver = version;
if str2num(MLver(1)) > 6
    [C,h] = contour(X1M,X2M,muM,20,'parent',hAxis);
else
    axes(hAxis);
    [C,h] = contour(X1M,X2M,muM,20);
end
axis(hAxis,'tight')
clabel(C,h)
return;

function p=logit3(x,y,z)
% the three variable logit
g=x*z(1) + y*z(2) + z(end);
p = 1 ./ (1 + exp(-g));
return

