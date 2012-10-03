function StatTest=drxlr_stat_test(test_method,z, p, LR, lambda)
% perform statistical test for adding/deleting variabels
% Inputs: method
%         z-value
%         p-value
%         likelihood ratio
%         regularization weight 0-1, 0: choose LRT -> 1: choose wald
% Written by Issam El Naqa 12/05/05
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

if ~exist('lambda')
    lambda=0.5;
end

switch upper(test_method)
    case 'WALD'
        StatTest=z^2;
    case 'LRT' % likelihood ratio test
        StatTest=LR;
    case 'WALD_LRT' % combined wald + likelihood ratio test
        StatTest=(1-drxlr_get_p_gaussian(z))*(1-lambda)+(1-drxlr_get_p_chi2(LR,p))*lambda;
    otherwise
        error('Unknown test method!','drxlr_stat_test')
end

return