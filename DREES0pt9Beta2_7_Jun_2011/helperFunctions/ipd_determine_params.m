function [] = ipd_determine_params(filename, order, test_method, logiter_param, logtol_param, lambda);
%  Wrapper class for the scripted version of the modeling
%  Handles the model parameter processing
%
%  Written by:  IEN, PEL, AJH
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

load([filename, '.mat']);
nboot = length(outcome)*5;
 
if ~exist('test_method') % if missing, set to Wald's; give same results as previous version
    test_method = 'WALD'; % WALD , LRT, WALD_LRT
end
if ~exist('logiter_param') % if missing use default
  logiter_param=300;
end
if ~exist('logtol_param')  % if missing use default
 logtol_param=1e-6;
end
if ~exist('lambda')  % if missing use default
 lambda = 0.5;
end

% New parameters that need to be set for logistic regression:
% test_method,logiter_param,logtol_param
% test_method = 1  -> Wald's 
% test_method = 2 -> likelihood ratio
% logiter_param -> default = 300
% logtol_param -> default = 1e-6;

for i = 1:length(order), 
    disp(sprintf('Determining model parameters for model order = %d...', i));
    [best_model{i}, xmodel{i}, freqvals{i}, freqindex{i}]=drxlr_find_model_params(x, y, outcome, order(i), nboot, variables, test_method, logiter_param, logtol_param, lambda);
    
    % moved this to inside subfunction
    %xmodel{i} = xmodel{i}(:, freqindex{i});
    
    save([filename, '_modelparams.mat'], 'xmodel', 'freqvals');
    
end