function f = cvNTCPobj(x,dvh,outcome)
%function f = cvNTCPobj(x,dvh,outcome)
%objective function for NTCP CV model
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

mu_cr = x(1);
sigma = x(2);
D50 = x(3);
gamma50 = x(4);
for i = 1:length(dvh)
    mu_d(i)= sum(dvh{i}(2,:).*drxlr_probit(1.4142*pi*gamma50*log(dvh{i}(1,:)/D50)))/sum(dvh{i}(2,:));
end
mu=drxlr_probit((-log(-log(mu_d))+log(-log(mu_cr)))/sigma);
f = sum((mu(:)-outcome(:)).^2);
