function univariateCorrelations(dBase, fieldcompare);
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

% for all fields that don't contain the keyword dvh calculate the spearmans
% with outcome display in order from highest to lowest  

v =[];

fields = fieldnames(dBase);
for i = 1:length(fields),
    if(isempty(strfind(fields{i}, 'dvh')))
        x = extractField(dBase, fields{i});
        [v.rs(i), v.p(i)]  = spearmanpv(x, [dBase.(fieldcompare)]);
        %      disp([fields{i}, ':    ', num2str(rs(i))]);
    end   
    
end  
[val, ind] = sort(abs(v.rs));
ind = ind(end:-1:1);
for i = 1:length(ind), 
    disp([fields{ind(i)}, ':    ' num2str(v.rs(ind(i))) '      (' num2str(v.p(ind(i))) ')']);
end


