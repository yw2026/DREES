function keepList = findUncorrelatedVars(varList, varVals, outcome);
  
% PEL 08-06-2005  
%usage: 
% [] =  findUncorrelatedVars(varList, varVals, outcome);
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

  
  % preprocessing to generate varList, which should be npatients by nvars
  % outcome is in this case pneumonitis
    
  % going to search through the variables to generate a list of variables
  % with a correlation of less than 0.85 with each other
  % for more highly correlation variables, keep the one which has the
  % highest spearmans with outcome?
    
  nvars = size(varVals, 1);
 
 % nvars = 50;  
  maxCorr = 0.85;
  
  keepList = [];
  availableVals = 1:nvars;
  i=1;
  %while(i<length(availableVals)), 
  while(length(availableVals)>1), 
      i = 1;
      disp(i)
      %  for i = 1:nvars
      c = [];
      %for j = i+1:nvars, 
      for j = i+1:length(availableVals), 
          t = corrcoef(varVals(availableVals(i), :), varVals(availableVals(j), :));
          c(j) = abs(t(1, 2));
      end
      if(max(c)<maxCorr)
          keepList = [keepList availableVals(i)];
          availableVals(i) = [];
          %i=i+1;
      else
          % decide which variable to keep;
          highlyCorrelatedVariables = find(c>=maxCorr);
          highlyCorrelatedVariables = [ highlyCorrelatedVariables i];
          rs = [];
          for k = 1:length(highlyCorrelatedVariables), 
              rs(k) = spearman(varVals(availableVals(highlyCorrelatedVariables(k)), :), outcome);
          end
          %rs = [spearman(varVals(availableVals(i), :), outcome) rs];
          [jnk, ind] = max(rs);
          %if(ind == length(rs))
          %    keepList = [keepList availableVals(i)];
          %    %availableVals([i highlyCorrelatedVariables]) = [];
          %    availableVals([i highlyCorrelatedVariables]) = []; 
          %    %i=i+1;
          %else
              keepList = [keepList availableVals(highlyCorrelatedVariables(ind))];
              availableVals([i highlyCorrelatedVariables]) = []; 
              %i=i+1;
          %end
         
      end
  end
  
  
  
  
%   for i = 1:length(keepList), 
%     for j = i+1:length(keepList), 
%       t = corrcoef(varVals(keepList(i), :), varVals(keepList(j), :));
%       finalCorr(i, j) = t(1, 2);
%     end
%   end
%   
%   