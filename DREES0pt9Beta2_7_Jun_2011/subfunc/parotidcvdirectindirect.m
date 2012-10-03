function [ntcp dv] = parotidcvdirectindirect(param,d,v,dc)
% [ntcp dv ] = parotidcvdirectindirect(param,d,v,dc) returns the NTCP
% according to the CV model, using a local damage model incorporating
% direct and indirect damage.
% The meaning of the parameters is:
%   - param     : The model parameters being
%                       (1:2)   critical volume model params
%                       (3:4) probit parameters direct effect
%                       (5:6) probit parameters indirect effect
%
% Remarks:
%   - If flow data is available and flow is assumed to be proportional
%     to damaged volume, we could model just flow (this reduces the number of
%     parameters since the CV model parameters are no longer needed.
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

p=1-(1-pdirect(param(3:4),d))*(1-pindirect(param(5:6),dc)); % Risk of damage for each dvh bin
dv=sum(v.*p); % Total damaged volume
ntcp=probit(param(1:2),dv); % NTCP assuming a normal distribution for the tolerance volume

function p=pdirect(param,d)
% pdirect(param,d) returns the risk of direct damage due to local dose.

p=phi(param(1)+param(2)*d);

function p=pindirect(param,d)
% pdirect(param,d) returns the risk of indirect damage due to dose to the critical target.

p=phi(param(1)+param(2)*d);

function y=phi(x)
% y=phi(x) returns the cumulative normal distribution.

y=0.5*(1+erf(x/1.41421356237310));