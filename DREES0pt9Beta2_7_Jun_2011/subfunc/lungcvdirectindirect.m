function [ntcp dv] = lungcvdirectindirect(param,dl,vl,dh,vh)
% [ntcp dv ] = parotidcvdirectindirect(param,d,v,dc) returns the NTCP
% according to the CV model, using a local damage model incorporating
% direct and indirect damage.
% The meaning of the parameters is:
%   - param     : The model parameters being
%                       (1:2) critical volume model params
%                       (3:4) probit parameters direct effect
%                       (5:6) probit parameters heart effect
%                       (7)   contribution of heart to critical volume
%
%param = [-5 10 -20 1 -20 1 0.3]
%
% Remarks:
%   - Does the number of events in the dataset justify the large number of
%     parameters of this model?
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

p=pdirect(param(3:4),dl); % Risk of damage for each dvh bin (only local for now.)
dv=sum(vl.*p); % Total damaged volume
ph=pindirect(param(5:6),sum(dh.*vh)); % Assume heart effect goes with mean heart dose
ntcp=phi(param(1:2),dv+param(7)*ph); % NTCP assuming a normal distribution for the tolerance volume

function p=pdirect(param,d)
% pdirect(param,d) returns the risk of direct damage due to local dose.

p=phi(param(1)+param(2)*d);

function p=pindirect(param,d)
% pdirect(param,d) returns the risk of indirect damage due to dose to the heart.

p=phi(param(1)+param(2)*d);

function y=phi(x)
% Returns the cumulative normal distribution.

y=0.5*(1+erf(x/1.41421356237310));