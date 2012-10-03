function univariateCorrelationsDV(dBase, comparefield, dvhName, arrayDxx, arrayVxx);
% dvhName is a string with the name of dvh field (i.e., 'dvh_lung')
% arrayDxx and arrayVxx are arrays with desired Dx and Vx values 
%  
% for the dvh field, calculate the spearman between
% specified Dxx and Vxx values and outcome  
%
%  Usage:  univariateCorrelationsDV(dBase, comparefield, dvhName, arrayDxx, arrayVxx)
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

dvh = [];

if(~isfield(dBase, dvhName))
    error(['specified DVH ' dvhName ' is not a field']);
else
    if(~isempty(arrayDxx)), 
        
        for i = 1:length(arrayDxx), 
            dxx = [];
            for j = 1:length(dBase), 
                dvh = dBase(j).(dvhName);
                dxx(j) = calc_Dx(dvh(1, :), dvh(2, :), arrayDxx(i));
            end
            rs = spearman(dxx, [dBase.(comparefield)]);
            disp(['D' num2str(arrayDxx(i)) ' ' num2str(rs)]);
        end
    end
    if(~isempty(arrayVxx)), 
        for i = 1:length(arrayVxx), 
            dxx = [];
            for j = 1:length(dBase), 
                dvh = dBase(j).(dvhName);
                vxx(j) = calc_Vx(dvh(1, :), dvh(2, :), arrayVxx(i),1);
            end
            rs = spearman(vxx, [dBase.(comparefield)]);
            disp(['V' num2str(arrayVxx(i)) ' ' num2str(rs)]);
        end
    end
    
    for j = 1:length(dBase)
        dvh = dBase(j).(dvhName);
        meanj(j) = calc_meanDose(dvh(1,:),dvh(2,:));
    end
    rs = spearman(meanj,[dBase.(comparefield)]);
    disp(['Meandose: ' num2str(rs)]);
end


