function k = mysvkernel(ker,u,v,p1,p2)
%SVKERNEL kernel for Support Vector Methods
%
%  Usage: k = svkernel(ker,u,v)
%
%  Parameters: ker   - kernel type
%              u,v   - kernel arguments
%              p1,p2 - parameters for the different kernel types
%
%  Values for ker: 'linear'  -
%                  'poly'    - p1 is degree of polynomial
%                  'rbf'     - p1 is width of rbfs (sigma)
%                  'sigmoid' - p1 is scale, p2 is offset
%                  'spline'  -
%                  'bspline' - p1 is degree of bspline
%                  'fourier' - p1 is degree
%                  'erfb'    - p1 is width of rbfs (sigma)
%                  'anova'   - p1 is max order of terms
%              
%  Author: Issam ElNaqa
% just faster!!!
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

  if (nargin < 1) % check correct number of arguments
     help mysvkernel
  else
       
%      global p1 p2
    % could check for correct number of args in here
    % but will slow things down further
    switch lower(ker)
      case 'linear'
        k = u*v';
      case 'poly'
        k = (u*v' + 1).^p1;
     case 'rbf'
        x2=u*u';
        y2=v*v';
        [ug,vg]=meshgrid(diag(y2),diag(x2));
        clear x2 y2 
        uvg=ug+vg;
        clear ug vg 
        uv=u*v';
        clear u v
        uvg=uvg-2*uv;
        k = exp(-(uvg)/(2*p1^2));
     case 'erbf'
        uv=u*v';
        x2=u*u';
        y2=v*v';
        [ug,vg]=meshgrid(diag(y2),diag(x2));
        k = exp(-sqrt(ug+vg-2*ug)/(2*p1^2));
      case 'sigmoid'
         %k = tanh(p1*u*v'/length(u)+p2) ;
          %k = tanh(p1*u*v' + p2);
          k=1./(1+exp(-p1*u*v'/length(u)));
      case 'fourier' % double check!!
        z = sin(p1 + 1/2)*2*ones(length(u),1);
        i = find(u-v);
        z(i) = sin(p1 + 1/2)*(u(i)-v(i))./sin((u(i)-v(i))/2);
        k = prod(z);
      case 'spline'
        z = 1 + u.*v + u.*v.*min(u,v) - ((u+v)/2).*(min(u,v)).^2 + (1/3)*(min(u,v)).^3;
        k = prod(z);
      case {'curvspline','anova'}
        z = 1 + u.*v + (1/2)*u.*v.*min(u,v) - (1/6)*(min(u,v)).^3;
        k = prod(z);

% - sum(u.*v) - 1; 
%        z = 1 + u.*v + (1/2)*u.*v.*min(u,v) - (1/6)*(min(u,v)).^3;
%        k = prod(z); 
%        z = (1/2)*u.*v.*min(u,v) - (1/6)*(min(u,v)).^3;
%        k = prod(z); 

      case 'bspline'
        z = 0;
        for r = 0: 2*(p1+1)
          z = z + (-1)^r*binomial(2*(p1+1),r)*(max(0,u-v + p1+1 - r)).^(2*p1 + 1);
        end
        k = prod(z);
      case 'anovaspline1'
        z = 1 + u.*v + u.*v.*min(u,v) - ((u+v)/2).*(min(u,v)).^2 + (1/3)*(min(u,v)).^3;
        k = prod(z); 
      case 'anovaspline2'
        z = 1 + u.*v + (u.*v).^2 + (u.*v).^2.*min(u,v) - u.*v.*(u+v).*(min(u,v)).^2 + (1/3)*(u.^2 + 4*u.*v + v.^2).*(min(u,v)).^3 - (1/2)*(u+v).*(min(u,v)).^4 + (1/5)*(min(u,v)).^5;
        k = prod(z);
      case 'anovaspline3'
        z = 1 + u.*v + (u.*v).^2 + (u.*v).^3 + (u.*v).^3.*min(u,v) - (3/2)*(u.*v).^2.*(u+v).*(min(u,v)).^2 + u.*v.*(u.^2 + 3*u.*v + v.^2).*(min(u,v)).^3 - (1/4)*(u.^3 + 9*u.^2.*v + 9*u.*v.^2 + v.^3).*(min(u,v)).^4 + (3/5)*(u.^2 + 3*u.*v + v.^2).*(min(u,v)).^5 - (1/2)*(u+v).*(min(u,v)).^6 + (1/7)*(min(u,v)).^7;
        k = prod(z);
      case 'anovabspline'
        z = 0;
        for r = 0: 2*(p1+1)
          z = z + (-1)^r*binomial(2*(p1+1),r)*(max(0,u-v + p1+1 - r)).^(2*p1 + 1);
        end
        k = prod(1 + z);
      otherwise
        k = u*v';
    end

  end
