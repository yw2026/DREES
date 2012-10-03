function displayClinicalStats(FileName, cutoff)
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

handles = [];  
handles = readData(FileName,handles);
% if length(unique(data))<discreteCutoff, assume data is NOT continuous

discreteCutoff = 10;

%fieldType = 1 (dvh)
%fieldType = 2 (continuous)
%fieldType = 3 (discrete)

for i = 1:length(handles.fieldnames), 
  field = handles.fieldnames{i};
  if(~isempty(strfind(field, 'dvh')))
    fieldType(i) = 1;
  else
    data = [handles.(field)];
    if(length(unique(data))>discreteCutoff)
      fieldType(i) = 2;
    else
      fieldType(i) = 3;
    end
  end
end



fieldIndex = find(fieldType == 2);
fprintf('Continuous Variables\n');
fprintf('\t\t\t\t All Patients\t\t\t Patients with outcome >= %d\t\t Patients with outcome < %d\n',cutoff, cutoff')
fprintf('\t\t\t\t\t\t\t   min  - max   mean   (std)   median\t\t\t');
fprintf('  min  - max   mean   (std)  median\t\t\t');
fprintf('  min  - max   mean   (std)  median\t');
fprintf('[Missing Data]\n');
s = 'No Data';

for i = 1:length(fieldIndex), 
  field = handles.fieldnames{fieldIndex(i)};
  
  dataAll = [handles.(field)];
  missingData = find(isnan(dataAll) | dataAll == -1) ;
  dataAll(missingData) = [];
  
  index = handles.outcome>=cutoff;
  index(missingData) = [];
  
  data = dataAll;
  
%  if(~isempty(missingData)), 
%    fprintf('[%d] ', length(missingData));
%  end
  
  fprintf('%20s\t %8.2f -%8.2f %8.2f (%8.2f) %8.2f\t', field, min(data),max(data),mean(data),std(data),median(data));
  
  data = dataAll(index);
  data1 = data;
  
  if(isempty(data))
    fprintf('%36s\t', s);
  else
    fprintf('%8.2f -%8.2f %8.2f (%8.2f) %8.2f\t', min(data),max(data),mean(data),std(data),median(data));
  end
  
  data = dataAll(~index);
  data2 = data;

  if(isempty(data))
    fprintf('%36s\t', s);
  else
    fprintf('%8.2f -%8.2f %8.2f (%8.2f) %8.2f\t', min(data),max(data), ...
	    mean(data),std(data),median(data));
  end
  
  if(isempty(data))
      fprintf('%36s\t',s);
  else
      [h,p,ci,stats] = ttest2(data1,data2);
      fprintf('%8.6f', p);
  end
      
  if(~isempty(missingData)), 
      fprintf('[%d]\n', length(missingData));
   else
     fprintf('\n');
   end
   
   
end

  
fprintf('\n Discrete Variables\n');
fprintf('\t\t\t %% of All patients with val \t %% of patient with val with outcome>=%d\t [Missing Data] \n', cutoff)

fieldIndex = find(fieldType == 3);
for i = 1:length(fieldIndex), 
  field = handles.fieldnames{fieldIndex(i)};
  
  dataAll = [handles.(field)];
  missingData = find(isnan(dataAll) | dataAll == -1) ;
  dataAll(missingData) = [];
  
  index = handles.outcome>=cutoff;
  index(missingData) = [];
  
  data = dataAll;
  datawith = dataAll(index);
  datawithout = dataAll(~index);
  p = ranksum(datawithout,datawith,0.05);

  dataVals = unique(data);
  
  for j = 1:length(dataVals), 
    num = sum(data == dataVals(j));
    percenttotal = sum(data == dataVals(j))/length(data)*100;

    numwith = sum(data(index)==dataVals(j));
    percentwith = sum(data(index)==dataVals(j))/length(data(index))*100;

    numwithout = sum(data(~index) == dataVals(j));
    percentwithout = sum(data(~index) == dataVals(j))/length(data(~index))*100;

    statsdata1 = datawith==dataVals(j);
    statsdata2 = datawithout==dataVals(j);
    
    fprintf('%20s val = %d\t %6.2f (n = %3.0f/%3.0f) \t\t %6.2f (n = %3.0f/%3.0f) \t\t %6.2f (n = %3.0f/%3.0f) \t\t ', field, dataVals(j), percenttotal, num, length(data), percentwith, numwith, length(data(index)), percentwithout, numwithout, length(data(~index)));

%    if(~strcmp(field,'outcome'))
     if(isempty(data))
      fprintf('%36s\t',s);
       else
      p = ranksum(statsdata1',statsdata2',0.05);
      fprintf('p=%6.6f', p);
      end
      % end
  
    if(~isempty(missingData)), 
      fprintf('[%d]\n', length(missingData));
      else
     fprintf('\n');
    end
  end
end

