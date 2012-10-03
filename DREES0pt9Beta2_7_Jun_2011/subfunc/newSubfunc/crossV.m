function [Train, Test, start_pos, end_pos] = crossV(A, ith, start_pos, end_pos, CV)
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

[rows,cols] = size(A);
unit = ceil(rows/CV); % size for each group. But the last group can be more or less
remainder = rem(rows,CV);

if remainder == 0
    unit = unit+1;
end

% if ith < 10
%     Train = [A(1:(ith-1) * unit,:); A(1+(ith * unit):end,:)];
%     Test = A((1+(ith-1) * unit):(ith * unit),:);
% else
%     Train = A(1:(ith-1) * unit,:);
%     Test = A((1+(ith-1) * unit):end,:);
% end

if ith <=remainder
   start_pos = end_pos+1;
   end_pos = start_pos+unit-1;
else
   if ith < CV
      start_pos = end_pos+1;
      end_pos = start_pos+unit-2;
   else %if ith == 10
      start_pos = end_pos+1;
      end_pos = rows;
   end
end

if start_pos > end_pos %thers is no test sample, only training samples
    Train = A;
    Test = [];
else
    Test = zeros(end_pos-start_pos+1,cols);
    Train = zeros(rows-(end_pos-start_pos+1),cols);
    idx = 1;
    for i=start_pos:end_pos % test samples
        Test(idx,:) = A(i,:);
        idx = idx+1;
    end
    
    idx = 1;
    for i=1:rows
        if i>=start_pos && i<=end_pos
        else
            Train(idx,:) = A(i,:);
            idx = idx+1;
        end
    end
end

