function []= ipd_display_results(fname, modelorders, topx, originalyn)
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

if ~exist('originalyn')
    originalyn = 0;
end

load(fname);
load([fname '_processed']);

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

fprintf(['Filename analyzed:  ' fname '\n\n']);

fprintf('Variables included:\n');
for i = 1:length(variables)
    fprintf(['   ' variables{i} '\n'])
end
fprintf('\nModels were generated for these model orders:  \n');
disp(modelorders)
fprintf('\nCross-correlation threshold for tree reduction was:  \n');
disp(correlation_cutoff)

for i = modelorders
    
    if (originalyn == 1)
        fprintf(['\nModel Order = %1.0f | Original\n'], i);
        counter = 1;
        for j = 1:topx
            fprintf(['#%1.0f:  %3.0f%% (%4.0f/%4.0f) Parameters:' ipd_cellstrings_to_string(variables(xmodel{i}(:,end-(j-1)))) '\n'],counter, freqvals{i}(end-(j-1))/sum(freqvals{i})*100, freqvals{i}(end-(j-1)), sum(freqvals{i})) 
            counter = counter+1;
        end
    end
    
    fprintf(['Model Order = %1.0f | Tree Reduced\n'], i);
    
    counter = 1;
    for j = 1:topx
        fprintf(['#%1.0f:  %3.0f%% (%4.0f/%4.0f) Parameters:' ipd_cellstrings_to_string(variables(modelsSorted{i}(:,end-(j-1)))) '\n'],...
            counter, freqSorted{i}(end-(j-1))/sum(freqSorted{i})*100,...
            freqSorted{i}(end-(j-1)), sum(freqSorted{i})) 
        counter = counter+1;
    end
    
    
end