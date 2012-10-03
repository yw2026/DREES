function [] = plot_aveDVH_outcome_threshold(dBase, dvh_name, complication_threshold)
%  Average DVHs for complication vs. not complication
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

outcome = [dBase.outcome];
if (~exist('dxx') | ~exist('vxx') | ~exist('mind') | ~exist('meand') | ~exist('maxd'))
[dxx, vxx, mind, meand, maxd] = calcDxVx(dBase, dvh_name);
end

h = figure;
hold on;


vxx_nocomp = vxx(outcome<complication_threshold,:);
vxx_comp = vxx(outcome>=complication_threshold,:);

dxx_nocomp = dxx(outcome<complication_threshold,:);
dxx_comp = dxx(outcome>=complication_threshold,:);

plot_all = plot(1:1:100,mean(vxx)*100, 'k-', 'LineWidth',1)
plot_nocomp = plot(1:1:100,mean(vxx_nocomp)*100, 'g-', 'LineWidth',1)
plot_comp = plot(1:1:100,mean(vxx_comp)*100,'r-', 'LineWidth',1)

axis([0 80 0 100])
set(gca,'FontSize',14);
set(gca,'color','none');
set(gca,'YColor',[0,0,0]);
set(gca,'XColor',[0,0,0]);
set(gca,'TickDir','Out')
set(get(gca,'xlabel'), 'FontSize', 18);
set(get(gca,'ylabel'), 'FontSize', 18);

for i = 1:100
    dxx_diff = mean(dxx_comp) - mean(dxx_nocomp);
    vxx_diff = mean(vxx_comp)*100 - mean(vxx_nocomp)*100;
end

plot_dxxdist = plot(dxx_diff, 'b-')
plot_vxxdist = plot(vxx_diff, 'c-')

legend([plot_all plot_nocomp plot_comp plot_dxxdist plot_vxxdist],...
    'Average DVH',...
    ['Average DVH for those without complications (Grade <' num2str(complication_threshold) ')'],...
    ['Average DVH for those with complications (Grade >= ' num2str(complication_threshold) ')'],...
    ['Separation between Dxx values'],...
    ['Separation between Vxx values']);


