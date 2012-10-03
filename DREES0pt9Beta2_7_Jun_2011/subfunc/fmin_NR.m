function [x,f,g,H] = fmin_NR(fun,x0,MAXITER,TOL,varargin)
%function [x,f,g,H] = fmin_NR(fun,x0,MAXITER,TOL,varargin)
%Simple Newton Raphson routine.
%fun is the objective function which is of the form [f,g,H]=fun(x,params)
%MAXITER is the maximum number of iterationf for Newton Ralphson's method.
%TOL is the tolerance for change in objective function for N-R iterations.
%any parameters beyond TOL are additional parameters for objective function.
%
%APA 9/12/06: Based on code by IEN
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

x = x0;
[f0,g,H] = feval(fun,x,varargin{:});
for i=1:MAXITER
    temp = g*inv(H);
    x = x - temp(:);
    [f,g,H] = feval(fun,x,varargin{:});
    test_conv = abs((f-f0)/f0);
    if test_conv<TOL
%            disp(['Newton Raphson converged successfully in ', num2str(i),' iterations.']);
        break;
    else
        f0 = f;        
    end
end
