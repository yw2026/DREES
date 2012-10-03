function  [] = ipd_determine_order(filename, test_method, logiter_param, logtol_param, lambda);
%  Wrapper class for the scripted version of the modeling
%  Handles the model order processing
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

% give it the filename without the .mat
  load([filename, '.mat']);
  nboot = length(outcome)*10;
  mfold_cv = 10;
  min_order = 1;
  max_order = 10;
  
% New parameters that need to be set for logistic regression:
% test_method,logiter_param,logtol_param
% test_method = 1  -> Wald's 
% test_method = 2 -> likelihood ratio
% logiter_param -> default = 300
% logtol_param -> default = 1e-6;

disp('Determining model order by cross-validation...')
 [order_cv, rs_cv] =drxlr_find_model_order_cv(x,y,outcome, min_order, max_order,test_method,logiter_param,logtol_param, lambda);
 %[order_mcv, rs_mcv] =get_model_order_mcv(x,y,outcome, min_order, max_order, 10);
 %[order_mcv, rs_mcv1] =get_model_order_mcv(x,y,outcome, min_order, max_order, 8);
 %save([filename, '_mfold.mat'], 'rs_mcv', 'rs_mcv1');
    

disp('Determining model order by bootstrap...')
[order_bs, rs_bs_train, rs_bs_test] =drxlr_find_model_order_bootstrap(x,y,outcome, min_order, max_order,nboot,test_method,logiter_param,logtol_param, lambda);
 %save([filename, '_modelorder.mat'], 'order_cv', 'rs_cv');
     %save([filename, '_modelorder.mat'], 'order_cv', 'rs_cv', 'order_mcv', ...
   %    'rs_mcv', 'order_bs', 'rs_bs');
   
w = 0.63;

rs_bs_mean = mean(((1-w)*rs_bs_train + w*rs_bs_test));
rs_bs_sem = std(((1-w)*rs_bs_train + w*rs_bs_test))/sqrt(nboot); % 1 standard deviation
   
save([filename, '_modelorderbs.mat'], 'order_bs', 'rs_bs_train', 'rs_bs_test','order_cv', 'rs_cv', 'rs_bs_mean', 'rs_bs_sem');