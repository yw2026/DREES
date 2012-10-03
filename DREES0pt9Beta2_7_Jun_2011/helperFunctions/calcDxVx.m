function [dxx, vxx, mind, meand, maxd, geudval] = calcDxVx(dBase, dvh_name, a);
% usage
% [dxx, vxx, mind, meand, maxd, geudval] = calcDxVx(dBase, dvh_name, a);
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
  

  if(~exist('a'))
    a =1;
  end


  for i = 1:length(dBase), 
    dvh = dBase(i).(dvh_name);
    if(isempty(dvh))
      dxx(i, 1:100) = -1;
      vxx(i, 1:100) = -1;
      meand(i) = -1;
      mind(i) = -1;
      maxd(i) = -1;
    else
      
      for j = 1:100, 
	dxx(i, j) = calc_Dx(dvh(1, :), dvh(2, :), j);
	vxx(i, j) = calc_Vx(dvh(1, :), dvh(2, :), j, 1);
      end
      meand(i) = calc_meanDose(dvh(1, :),dvh(2, :), 1);
      mind(i) = calc_minDose(dvh(1, :), dvh(2, :), 1);
      maxd(i) = calc_maxDose(dvh(1, :), dvh(2, :), 1);
    end
    geudval(i) = calc_EUD(dvh(1, :), dvh(2, :), a);
    
  end