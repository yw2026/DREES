function f = lqTCPobj(x,dvh,outcome)
%function f = lqTCPobj(x,dvh,outcome)
%objective function for TCP LQ model
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

N = x(1);
alpha = x(2);
beta = x(3);
Teff = x(4);
for i = 1:length(dvh)
    D=sum(dvh{i}(2,:));
    S=exp(-((alpha+beta*handles.FractionSize(i))*D+0.6931*handles.TreatmentLength/Teff));
    mu(i,:)=exp(-S*N);
    %dataX(i)=calc_meanDose(data{i}(1,:), data{i}(2,:)); % select mdose as the X-variable
end
f = sum((mu-outcome(:)).^2);
