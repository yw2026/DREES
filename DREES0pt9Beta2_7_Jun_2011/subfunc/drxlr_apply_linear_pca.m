function [zscores,pcs, sigmas]=drxlr_apply_linear_pca(x)
% Linear PCA analysis
% Written by Issam El Naqa 06/06/07
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

[n,p]=size(x);
xmean=mean(x);
xn=x-xmean(ones(n,1),:);
C=xn'*xn/n;
[evecs,evals] = eig(C);
sigma=abs(diag(evals));
[sigmas, inds]=sort(sigma);
sigmas=sigmas(end:-1:1); inds=inds(end:-1:1);
pcvars=sigmas.^2;
pcs=evecs(:,inds);
zscores=xn*pcs;
pccum=cumsum(pcvars./sum(pcvars) * 100);
return