function drxlr_boxwhisPlot(DATA,label,hAxis)
%function drxlr_boxwhisPlot(DATA,label,hAxis)
% drxlr_boxwhisPlot(X) produces a box and whisker plot with one box for each column
% of X.  The boxes have lines at the lower quartile, median, and upper
% quartile values.  The whiskers are lines extending from each end of the
% boxes to 5 and 95th quantiles.  Outliers are data with values beyond the ends
% of the whiskers.
%
%label: an optional input to display label for each box at the bottom of
%axis
%hAxis: an optional input to plot on hAxis. If not specified, box-Whisker plot is
%drawn on the current axis (gca).
%
%APA, 07/05/2006
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

if ~exist('hAxis')
    hAxis = gca;
end
boxWhisInfo = boxwhis(DATA);
if ~exist('label')
    xTick = 1:size(boxWhisInfo,2)
else
    xTick = [];
end
set(hAxis,'nextPlot','add','yLimMode','auto','XTick',xTick) %'XTickMode','off'
for i = 1:size(boxWhisInfo,2)
    XL = i - 0.2;
    XU = i + 0.2;
    X25 = boxWhisInfo(2,i);
    X50 = boxWhisInfo(3,i);
    X75 = boxWhisInfo(4,i);
    plot([XL XU XU XL XL],[X25 X25 X50 X50 X25],'k','linewidth',2,'parent',hAxis)
    plot([XL XU XU XL XL],[X50 X50 X75 X75 X50],'k','linewidth',2,'parent',hAxis)
    plot([(XL+XU)./2 (XL+XU)./2],boxWhisInfo(1:2,i),'k','parent',hAxis)
    plot([(XL+XU)./2 (XL+XU)./2],boxWhisInfo(4:5,i),'k','parent',hAxis)
end
set(hAxis,'xLim',[0.5 size(boxWhisInfo,2)+0.5])
if exist('label') & ~iscell(label)
    label = {label};
end
if exist('label') & length(label)==size(boxWhisInfo,2)
    yLim = get(hAxis,'yLim');
    for i = 1:length(label)
        text(i,yLim(1),label{i},'HorizontalAlignment','center','VerticalAlignment','top','interpreter','none')
    end
else
    errordlg('label must be a cell array containing strings')
end

return

% -------------------------------------------

function boxWhisInfo = boxwhis(DATA)
%function boxwhis(X)
%returns 5,25,50,75 and 95 precent limits for for the input X.
%X can be a vector or a matrix. If X is an (n x m) matrix, boxWhisInfo is
%an (m x 5) matrix containing boxWhis information for each column of X.
%outliers are data beyond 5% and 95%
%
%APA, 07/05/2006

if size(DATA,1)==1 | size(DATA,2)==1
    DATA = DATA(:);
end

boxWhisInfo = [];

for i = 1:size(DATA,2)
    X = DATA(:,i);

    %filter out NaN and inf
    indexNaN = isnan(X);
    indexInf = isinf(X);
    X([indexNaN(:);indexInf(:)]) = [];

    [Xsort,Isort]=sort(X);
    n=length(Xsort);

    % 5th Quantile
    I5f=floor(max(5/100*n,1));
    I5c=ceil(5/100*n);
    if I5f~=I5c
        X5=(Xsort(I5c)-Xsort(I5f))./(I5c-I5f)*(5/100*n-I5f)+Xsort(I5f);
    else
        X5=Xsort(I5f);
    end

    % 25th Quantile
    I25f=floor(max(25/100*n,1));
    I25c=ceil(25/100*n);
    if I25f~=I25c
        X25=(Xsort(I25c)-Xsort(I25f))./(I25c-I25f)*(25/100*n-I25f)+Xsort(I25f);
    else
        X25=Xsort(I25f);
    end

    % 50th Quantile
    I50f=floor(max(50/100*n,1));
    I50c=ceil(50/100*n);
    if I50f~=I50c
        X50=(Xsort(I50c)-Xsort(I50f))./(I50c-I50f)*(50/100*n-I50f)+Xsort(I50f);
    else
        X50=Xsort(I50f);
    end

    % 75th Quantile
    I75f=floor(max(75/100*n,1));
    I75c=ceil(75/100*n);
    if I75f~=I75c
        X75=(Xsort(I75c)-Xsort(I75f))./(I75c-I75f)*(75/100*n-I75f)+Xsort(I75f);
    else
        X75=Xsort(I75f);
    end

    % 95th Quantile
    I95f=floor(max(95/100*n,1));
    I95c=ceil(95/100*n);
    if I95f~=I95c
        X95=(Xsort(I95c)-Xsort(I95f))./(I95c-I95f)*(95/100*n-I95f)+Xsort(I95f);
    else
        X95=Xsort(I95f);
    end

    boxWhisInfoForOneVar = [X5 X25 X50 X75 X95]';

    boxWhisInfo = [boxWhisInfo boxWhisInfoForOneVar];
end

return;
