function f = poissonTCPobj(X,dvh,outcome)
%function f = poissonTCPobj(X,dvh,outcome)
%objective function for TCP Poisson model
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

D50     = X(1);
gamma50 = X(2);
for i = 1:length(dvh)
    mu(i,:) = 0.5^(sum(dvh{i}(2,:).*exp(2*gamma50*(1-dvh{i}(1,:)/D50)/0.6931)));
    %dataX(i) = calc_meanDose(dvh{i}(1,:), dvh{i}(2,:)); % select mdose as the X-variable    
end
f = sum((mu(:)-outcome(:)).^2);
