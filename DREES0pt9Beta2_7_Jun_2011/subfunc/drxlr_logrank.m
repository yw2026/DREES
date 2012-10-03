function p=logranktest(tA,cA,tB,cB)
% log rank risk for survival (two variables only)
% written by Issam ElNaqa, 02/03
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

tt=[tA,tB];
ct=[cA',cB'];
lA=length(tA); lB=length(tB);
nt = length(tt);
[tt,ind] = sort(tt); % should in ascending order
ct = ct(ind);
ft = ones(1,nt);
totcumfreq = nt-cumsum(ft)+1;
qt=ct./totcumfreq;
nAc=lA;
nBc=lB;
for i=1:nt
    nA(i)=nAc;
    nB(i)=nBc;
    if (ind(i)<=lA)
        nAc=nAc-1;
    else
        nBc=nBc-1;
    end
end
EA=sum(nA.*qt);
EB=sum(nB.*qt);
OA=sum(cA);
OB=sum(cB);
testA=(OA-EA)^2/EA;
testB=(OB-EB)^2/EB;
logtest=testA+testB;
p=1-max(min(gammainc(logtest/2,1/2),1),0); % chi2 by integrating gamma.
return
