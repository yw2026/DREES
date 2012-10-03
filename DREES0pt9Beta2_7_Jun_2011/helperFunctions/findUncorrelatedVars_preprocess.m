function [] = findUncorrelatedVars_preprocess(dBase);
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

  for i =1 :length(dBase), 
    dvh = dBase(i).dvh_lung;
    for j = 1:100, 
      dxx(i, j) = Dx_patricia(dvh(1, :), dvh(2, :), j);
      vxx(i, j) = Vx_patricia(dvh(1, :), dvh(2, :), j);
    end
    geudval(i) = geud(dvh(1, :), dvh(2, :), 5);
   end
   
  corrCutoff = 0.75;
   nvals = size(dxx, 2);
   keepVals = [];
   keepVals(1) = 1;
   i = 1;
   while(i<nvals-1)
       c = [];
       for j = i+1:nvals, 
           t = corrcoef(dxx(:, i), dxx(:,j));
           c(j) = abs(t(1, 2));
        end     
        ind = find(c(i+1:end)<corrCutoff);
        keepVals = [keepVals ind(1)+i];
       i = ind(1)+i;
     end
    
     
     c = [];
     for i =1 :length(keepVals)-1, 
    t = corrcoef(dxx(:,keepVals(i)), dxx(:, keepVals(i+1)));
    c(i) = t(1, 2);
end

% find Vxx values that are uncorrelated with these Dxx values
removeVxx = [];
for i = 1:nVxx, 
    c = [];
    for j = 1:length(keepVals), 
        t = corrcoef(vxx(:,i), dxx(:, keepVals(j)));
        c(j) = abs(t(1, 2));
    end
    if(max(c)>corrCutoff)
        removeVxx = [removeVxx i];
    end
end

vxxNew = vxx(:,1:nVxx);
vxxNew(:, removeVxx) = [];
vxxList = 1:nVxx;
vxxList(removeVxx) = [];

 corrCutoff = 0.85;
   nvals = length(vxxList);
   keepVals = [];
   keepVals(1) = 1;
   i = 1;
   while(i<nvals-1)
       c = [];
       for j = i+1:nvals, 
           t = corrcoef(vxxNew(:, i), vxxNew(:,j));
           c(j) = abs(t(1, 2));
        end     
        ind = find(c(i+1:end)<corrCutoff);
        keepVals = [keepVals ind(1)+i];
       i = ind(1)+i;
     end
   
     
     c = [];
     for i =1 :length(keepVals)-1, 
    t = corrcoef(vxx(:,keepVals(i)), vxx(:, keepVals(i+1)));
    c(i) = t(1, 2);
end
