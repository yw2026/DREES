function handles=drxlr_get_clinical_data(FileName,handles)
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

load (FileName);

% change dBase to ddbs
if exist('dBase')==1 & exist('ddbs')~=1
    ddbs = dBase;
    clear dBase
end

% initialize
handles.Ddata=[];
handles.Vdata=[];
n=length(ddbs);
handles.n=n;

%%%%%%%%%% Clinical data  %%%%%
fieldnames = fields(ddbs);
dvhInd = [];
for i = 1:length(fieldnames)
    %         if strcmpi(fieldnames{i}, 'outcome')
    %             continue;
    %         end
    
    try
        data  = {ddbs.(fieldnames{i})};
    catch
        for j = 1:length(ddbs),
            data{j} = getfield(ddbs, {j}, fieldnames{i});
        end
    end
    
    if(findstr(fieldnames{i}, 'dvh'))
        dvhInd = [dvhInd i];
        handles = setfield(handles, fieldnames{i}, data);
        continue;
    end
    
    if isnumeric(data{1})
        temp= [data{:}];
        if length(temp)<n
            temp=[];
            for j=1:length(data)
                if ~isempty(data{j})
                    temp(j)=data{j};
                else
                    temp(j)=NaN;
                end
            end
        end
        handles = setfield(handles, fieldnames{i},temp);
    elseif ischar(data{1})
        numericStrings = 1;
        temp = {};
        for j = 1:length(data),
            if isempty(data{j})
                temp{j}=NaN;
            else
                temp{j} = str2num(data{j});
                if isempty(temp{j})
                    numericStrings = 0;
                    break;
                end
            end
        end
        if numericStrings
            handles = setfield(handles, fieldnames{i}, [temp{:}]);
        else
            clear temp;
            uniqueData = unique(lower(data));
            
            %for j = 1:length(data),
            [junk, temp] = ismember(lower(data), uniqueData);
            %end
            handles = setfield(handles, fieldnames{i}, temp);
        end
    else
        warning('invalid data type');
        continue;
    end
end

dvhFieldNames = {fieldnames{dvhInd}};
fieldnames(dvhInd) = [];
for i=1:length(dvhInd);
    singleFieldName = dvhFieldNames{i};
    strName = singleFieldName(5:end);
    newFields = {['Dx_' strName], ['Vx_' strName],['Mindose_' strName],['Maxdose_' strName],['Meandose_' strName],['GEUD_' strName],...
       ['MOHx_' strName],['MOCx_' strName]};
    fieldnames = {newFields{:}, fieldnames{:}};
end

for i = 1:length(fieldnames)
    handles.params.(fieldnames{i}) = [];
end
handles.fieldnames = fieldnames;
return
