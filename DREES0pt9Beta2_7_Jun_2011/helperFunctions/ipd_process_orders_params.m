function []= ipd_process_orders_params(fname, modelorders, correlation_cutoff, test_method, logiter_param, logtol_param, guiflag, lamdba)
% x is matrix of datavalues for each patient npatients by nvariables
% xmodel is model_order x numBootstrapModels
% xmodel in this function is xmodel{i} returned from
% DREX_GUI_subfunctions_params
% and freq is freq{i}
% Returns models and frequencies in sorted order, least to greatest
% Then to get the variables:
% variables(modelsSorted)
%
% usage:
%   function []= ipd_process_orders_params(fname, modelorders, correlation_cutoff);
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


%  If gui has not been requested, setting the guiflag to false
if ~exist('guiflag')
    guiflag = 0;
end

if ~exist('test_method') % if missing, set to Wald's; give same results as previous version
    test_method = 'WALD'; % WALD , LRT, WALD_LRT
end

% % Logistic regression # of bootstraps
if ~exist('logiter_param') % if missing use default
  logiter_param=300;
end  
% % Logistic regression convergence threshold
if ~exist('logtol_param')  % if missing use default
 logtol_param=1e-6;
end
if ~exist('lambda')  % if missing use default
 lambda = 0.5;
end

disp('Loading file...');
load(fname);

%  Create the order output
%  'order_bs'
%  'rs_bs_train'
%  'rs_bs_test'
%  'order_cv'
%  'rs_cv'
%  'rs_bs_mean'
%  'rs_bs_sem

try
    disp('Loading model order data...')
    load([fname '_modelorderbs.mat']);
catch
    disp('Model order data not found... calculating model order.')
    ipd_determine_order(fname, test_method, logiter_param, logtol_param, lambda);
    disp('Loading model order data...')
    load([fname '_modelorderbs.mat']);
end

try
    disp('Loading model parameter data...')
    load([fname '_modelparams.mat']);
catch
    disp('Model parameter data not found... calculating model parameters.')
    ipd_determine_params(fname, modelorders, test_method, logiter_param, logtol_param, lambda);
    disp('Loading model parameter data...')
    load([fname '_modelparams.mat']);
end

disp('Tree reducing models...');

[modelsSorted, freqSorted] = ipd_tree_reduce_all(x,freqvals,xmodel,correlation_cutoff);

%packaging all variables in a nice little bundle for display
save([fname, '_processed.mat'], 'modelorders','correlation_cutoff', 'xmodel', 'freqvals', 'order_bs', 'rs_bs_train', 'rs_bs_test','order_cv', 'rs_cv', 'rs_bs_mean', 'rs_bs_sem', 'modelsSorted', 'freqSorted');
disp('Processing complete.');