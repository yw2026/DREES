function [plothandle] = drex_bin_plot_sorted(fig_handle, sortindex, data, bins, linestyle, errorbars)
% DREX subfunction 
% Written by Issam El Naqa 2003-2005
% Modified for generalized use 2005, AJH
%
% Companion function to drex_bin_plot which will sort data based on a
% pre-existing index and create plots to add original data to an existing
% figure
%
% SORTINDEX MUST BE THE SAME LENGTH AS THE DATA
%
% Input:
%
% fig_handle - target figure for plotting results
% sortindex - index to the data as sorted by drex_bin_plot()
% data - The predictor being plotted
% bins - number of bins
% linestyle - output linestyle
% errorbars - 1 (with errorbars) or 0 (without errorbars)
% 
% Output:
%
% plothandle - returns the handle of the resulting plot
% 
% Usage:  
% function [plothandle] = drex_bin_plot_sorted(fig_handle, sortindex, data, bins, linestyle, errorbars)
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

% forces current figure for the following plots to the passed handle
figure(fig_handle);

% Determines the length of the metric
datalength=length(data);

% Check to see if length of sort index = length of data, if not, ERROR!
if length(sortindex) ~= length(data)
    error('Sort index of different length than data.');
end

% Sorts the metric in increasing order
sorteddata=data(sortindex);

% Bins the data into 'bins' # of bins and calculates the mean and error
% bars for each bin for plotting

binWidth=round(datalength/bins);
for i=1:bins
    vector=(i-1)*binWidth+[1:binWidth];
    vector=vector(find(vector<=datalength));
    binnedData(i)=mean(sorteddata(vector));
    errorBinnedData(i)=sqrt(binnedData(i)*(1-binnedData(i)))/sqrt(length(sorteddata(vector)));
end

% Creates plot, checking for optional use of error bars
if ~exist('errorbars')
    plothandle = plot([1:bins], binnedData, linestyle);
elseif errorbars == 1
    plothandle = errorbar([1:bins],binnedData,errorBinnedData,linestyle);
else
    plothandle = plot([1:bins], binnedData, linestyle);
end
    
end
return