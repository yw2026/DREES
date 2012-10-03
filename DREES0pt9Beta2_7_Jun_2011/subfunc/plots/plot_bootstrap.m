function hAxis = plot_bootstrap(hAxis,addset)
%function hAxis = plot_bootstrap(hAxis,addset)
%This function plots "bootstrap plot" on the passed axis handle.
%INPUT: hAxis - axis handle to plot bootstrap plot
%      addset - 
%OUTPUT: hAxis with bootstrap plot
%
%APA 9/26/2006, extracted from DREES_GUI
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

bootimage=[];

for i=1:length(addset);
    temp=reshape(addset{i},prod(size(addset{i})),1);
    bootimage=[bootimage, temp];
end

% imagesc(1-bootimage,'parent',hAxis)

colormaped_image = index2rgb_direct((1-bootimage)*2, gray(2));
imagesc(colormaped_image,'parent',hAxis)

%subimage(1-bootimage,gray(100)), axis normal
%colormap(hAxis,'gray')
return;
