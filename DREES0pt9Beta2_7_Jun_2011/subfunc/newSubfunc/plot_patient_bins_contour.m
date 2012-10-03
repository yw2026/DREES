function plot_patient_bins_contour(X1,X2)
%function plot_patient_bins_contour(X1,X2)
%
%This function plots the distribution of patients in 2D space.
%X1: variable 1
%X2: variable 2
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

%bin the data
numBinsX1   = 10;
numBinsX2   = 10;
X1Data = X1;
X2Data = X2;
cData       = jet(numBinsX1*numBinsX2); %colormap setting
X1BinsV     = [linspace(min(X1),max(X1),numBinsX1+1)]';
X2BinsV     = [linspace(min(X2),max(X2),numBinsX2+1)]';
X1Bins      = [X1BinsV(1:end-1) X1BinsV(2:end)];
X2Bins      = [X2BinsV(1:end-1) X2BinsV(2:end)];
binCount = 0;
numPat = [];
for i = 1:size(X1Bins,1)
    for j = 1:size(X2Bins,1)
        binCount = binCount + 1;
        ind         = find(X1Data>=X1Bins(i,1) & X1Data<X1Bins(i,2) & X2Data>=X2Bins(j,1) & X2Data<X2Bins(j,2));
        numPat(i,j) = length(ind);
    end
end

%plot the data
figure, [C,h]=contourf(X1BinsV(1:end-1)+diff(X1BinsV)/2, X2BinsV(1:end-1)+diff(X2BinsV)/2, numPat);
map = gray(15);
map = flipud(map);
colormap(map)
