function hAxis = plot_cum_hist(hAxis,x,y,mu,model_flag,b,radBioModelStr)
%function hAxis = plot_cum_hist(hAxis,x,y,mu,varargin)
%This function plots cumulative histogram on the passed axis handle.
%INPUT: hAxis - axis handle to plot histogram
%           x - exploratory variable [x1(:) x2(:) ... xn(:)]    
%           y - end-point
%          mu - 
%  model_flag - 1: multimetric, 2: analytical
%           b -
%OUTPUT: hAxis with plot for cumulative histogram
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

% if isempty(varargin)
%     model_flag = 2;
% elseif length(varargin)==1 & length(varargin{:})==size(x,2)+1
%     b = varargin{1};
%     model_flag = 1;
% else
%     error('Incorrect Input Parameters passed to plot_cum_hist. Please check and try again')
% end
    
cla(hAxis);
axes(hAxis);
if exist('radBioModelStr') && ischar(radBioModelStr)
else
    radBioModelStr = '';
end
if model_flag==1 %% multimetric
    sx=size(x,2);
    lastb=b(end);
    GX=(x*b(1:sx))+lastb;
elseif model_flag==2 | model_flag==3 % analytical
    GX=x;
else
    errordlg('No field found','get_field_data');
end
[SortedGX,indexGX]=sort(GX);
SortedY=y(indexGX);
SortedMu=mu(indexGX);
[numelements,binlocation]=hist(SortedGX,8);
boundary=[-Inf (diff(binlocation)/2)+binlocation(1:end-1) Inf];
SortedY2=[];
for i=2:length(boundary)
    SortedY1=SortedY(boundary(i-1)<SortedGX & SortedGX<=boundary(i));
    if isempty(SortedY1)
        SortedY1=0;
    end
    SortedY2=[SortedY2,mean(SortedY1)];
end
%bin mu as well
SortedMuBin=[];
for i=2:length(boundary)
    SortedMuBin1 = SortedMu(boundary(i-1)<SortedGX & SortedGX<=boundary(i));
    if isempty(SortedY1)
        SortedMuBin1=0;
    end
    if isempty(SortedMuBin1)
        SortedMuBin1 = NaN;
    end
    SortedMuBin=[SortedMuBin,mean(SortedMuBin1)];
end


SortedMu1=cumsum(SortedMu);
nextPlot = get(hAxis,'nextPlot');
set(hAxis,'nextPlot','add');
%Plot bar graph for unique binlocations only
%if length(unique(binlocation)) == length(binlocation)
    set(bar(hAxis,binlocation,cumsum(SortedY2)/sum(SortedY2),1),'FaceColor','w','LineWidth',1.5)
%end
plot(hAxis,SortedGX,cumsum(SortedMu1)/sum(SortedMu1),'b-','LineWidth',1.5,'MarkerSize',9,'parent',hAxis),axis(hAxis,'tight')
xlabel(hAxis,'g(x)', 'units', 'normalized','FontWeight','normal');
ylabel(hAxis,['Cumulative ', radBioModelStr], 'units', 'normalized','FontWeight','normal');
set(hAxis,'nextPlot',nextPlot);
set(hAxis,'visible','on')

% Ep = cumsum(SortedY)/sum(SortedY);
% O = cumsum(SortedMu1)/sum(SortedMu1);
Ep = SortedY2;
O = SortedMuBin;
chi2 = sum((O(:)-Ep(:)).^2 ./ (Ep(:)+1e-3));
np = length(O)-length(b);
p = 1-drxlr_get_p_chi2(chi2,np);

legend(hAxis,['p = ',num2str(p)])
return
