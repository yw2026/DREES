function []= ipd_plot_order_results(fname)
%  Display function
%  fname - filename
%  modelorders - vector of the model orders to evaluate ([1 2 3])
%  topx - Display the top X number model information (ie: top 10, top 5)
%  originalyn - Switch to display the original model order and frequencies
%    (default off)
%  usage:
%  function []= ipd_display_results(fname, modelorders, topx, originalyn)
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

if ~exist('ninetytenswitch')
    originalyn = 0;
end
if ~exist('bsswitch')
    originalyn = 0;
end
if ~exist('looswitch')
    originalyn = 0;
end

load(fname);
load([fname '_processed']);

%  Should now have
%  'order_bs'
%  'rs_bs_train'
%  'rs_bs_test'
%  'order_cv'
%  'rs_cv'
%  'rs_bs_mean'
%  'rs_bs_sem
%  'xmodel' - cell array of models
%  'freqvals' - cell array of frequencies
%  'modelsSorted'
%  'freqSorted'

figure
hold on

cvplot = plot(rs_cv, 'r-');
%bsplot = plot(rs_bs_mean, 'k-');

xlabel('Model order');
ylabel('Spearman''s rank correlation (Rs)');
set(gca,'color','none');
set(gca,'FontSize',14')
set(gca,'TickDir','Out')
set(get(gca,'Xlabel'), 'FontSize', 18);
set(get(gca,'Ylabel'), 'FontSize', 18);

legend_handle = legend([cvplot], 'Leave one out cross-validation',3);
%legend_handle = legend([cvplot bsplot], 'Leave one out cross-validation', 'Bootstraped sample analysis',3);
set(legend_handle, 'Color', 'none');
set(get(gca,'Xlabel'), 'FontSize', 18);
set(get(gca,'Ylabel'), 'FontSize', 18);