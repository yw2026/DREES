function [sortorder, plothandle] = drex_bin_plot(fig_handle, metric, bins, linestyle, errorbars)
%  This is a modified (object based) version of the drex_octile_plot
%  function which is modified to only create one plot and to add errorbars
%  as an option
%  
% Input:
%
% fig_handle - target figure for plotting results
% metric - The predictor being plotted
% bins - number of bins
% linestyle - output linestyle
% errorbars - 1 (with errorbars) or 0 (without errorbars)
% 
% Output:
%
% sortorder - the index to the metric sort, which can be passed
%   to drex_bin_plot to plot additional metrics or original data
% 
% plothandle - returns the handle of the resulting plot
% 
% DREX subfunction 
% Written by Issam El Naqa 2003-2005
% Extracted for generalized use 2005, AJH
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
datalength=length(metric);

% Sorts the metric in increasing order
[sortedmetric,sortorder]=sort(metric);

% Bins the data into 'bins' # of bins and calculates the mean and error
% bars for each bin for plotting
binWidth=round(datalength/bins);
for i=1:bins
    vector=(i-1)*binWidth+[1:binWidth];
    vector=vector(find(vector<=datalength));
    binnedMetric(i)=mean(sortedmetric(vector));
    errorBinnedMetric(i)=sqrt(binnedMetric(i)*(1-binnedMetric(i)))/sqrt(length(sortedmetric(vector)));
end

if ~exist('errorbars')
    plothandle = plot([1:bins], binnedMetric, linestyle);
else
    if errorbars == 1
        plothandle = errorbar([1:bins],binnedMetric,errorBinnedMetric,linestyle);
    else
        plothandle = plot([1:bins], binnedMetric, linestyle);
    end
end
return