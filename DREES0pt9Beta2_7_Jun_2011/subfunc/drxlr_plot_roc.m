function [Az, TPF, FPF]=drxlr_plot_roc(g,y,Tstep)
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

% simple ROC plot routine
if ~exist('Tstep')
    Tstep=0.1;
end
T=[1:-Tstep:0];
npos=sum(y);
nneg=sum(~y);
for i=1:length(T);
    muc=g>=T(i);
    TPF(i)=sum(y(:).*muc(:))/npos;
    FPF(i)=sum(~y(:).*muc(:))/nneg;
end  % need still interpolation?
Az=trapz(FPF,TPF);
plot(FPF,TPF,'kx-','LineWidth',1.5,'MarkerSize',12);
xlabel('False positive rate (1-Specificity)'), ylabel('True positive rate (Sensitivity)')
axis([0 1 0 1])
str=['Az=',num2str(Az,2)];
text(0.65,0.5,str,'Color','k');

return