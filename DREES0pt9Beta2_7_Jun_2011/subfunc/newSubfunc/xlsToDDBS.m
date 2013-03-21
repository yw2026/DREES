function ddbs = xlsToDDBS(xlFile)
%function ddbs = xlsToDDBS(xlFile)
%
%This function reads excel outcomes data into DREES ddbs format
%
%APA 10/05/2006
%
% Copyright 2010, Joseph O. Deasy, on behalf of the DREES development team.
% 
% This file is part of the Dose Response Explorer System (DREES).
% 
% DREES development has been led by:  Ya Wang, Issam El Naqa, Aditya Apte, Gita Suneja, and Joseph O. Deasy.
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

try
    %xlFile = 'C:\CVSROOT\DRE\BIOR_PET_OUTCOMES_ANALYSIS1';
    %hMsg = msgbox('Please select the EXCEL sheet to import data other than DVH. You will be prompted to import the DVH data later. Please refer to user guide for the format of data in Excel spreadsheet.','Import Data','modal');
    %[num,txt,raw] = xlsread(xlFile,-1);
    prompt={'Enter the name of sheet containing metrics and outcome:'};
    name='Metrics and Outcome Sheet Name';
    numlines=1;
    defaultanswer={'Sheet1'};
    sheet_name_metrics = inputdlg(prompt,name,numlines,defaultanswer);
    if ~isempty(sheet_name_metrics)
        sheet_name_metrics = sheet_name_metrics{1};
    else
        error('Name of the Excel Sheet must be entered')
    end
    [num,txt,raw] = xlsread(xlFile,sheet_name_metrics);
    %close(hMsg)
    
    buttonName = questdlg('Do you wish to import DVH Data?','Import DVH Data','Yes','No','No');
    dvh_raw = {};
    if strcmpi(buttonName,'Yes')
        prompt={'Enter the name of sheet containing metrics and outcome:'};
        name='Metrics and Outcome Sheet Name';
        numlines=1;
        defaultanswer={'Sheet2'};
        sheet_name_dvh = inputdlg(prompt,name,numlines,defaultanswer);
        if ~isempty(sheet_name_dvh)
            sheet_name_dvh = sheet_name_dvh{1};
        else
            error('Name of the Excel Sheet must be entered')
        end
        [dvh_num,dvh_txt,dvh_raw] = xlsread(xlFile,sheet_name_dvh);
    end

    %replace spaces with underscores
    for i=1:size(raw,2)
        raw{1,i} = repSpaceHyp(raw{1,i});
    end

    %removes columns with non-numeric data
    indToRemove  = [];
    for i=1:size(raw,2)
        if ~isnumeric([raw{2:size(raw,1),i}]) || all(isnan([raw{2:size(raw,1),i}]))
            indToRemove = [indToRemove i];
        end
    end
    raw(:,indToRemove) = [];
     %removes rows with non-numeric data
    indToRemove  = [];
    for i=1:size(raw,1)
        if all(isnan([raw{i,:}]))
            indToRemove = [indToRemove i];
        end
    end
    raw(indToRemove,:) = [];
    %get variables from the selection list
    [selIndV, OK] = listdlg('ListString',raw(1,:),'PromptString','Select metrics or select All');

    %initialize ddbs
    ddbs = struct();
    numPatients = size(raw,1)-1;
    %set variable fields
    for i=1:length(selIndV)
        for j=1:size(raw,1)-1
            ddbs(j).(raw{1,selIndV(i)}) = raw{j+1,selIndV(i)};
        end
    end

    %get outcome from the selection list
    [selIndV, OK] = listdlg('ListString',raw(1,:),'SelectionMode','single','PromptString','Select Outcome');

    %set outcomes field
    for i=1:length(selIndV)
        for j=1:size(raw,1)-1
            ddbs(j).outcome = raw{j+1,selIndV(i)};
        end
    end

    %Read DVH data

    if ~isempty(dvh_raw)
        organ_indices = find(~cellfun('isempty',dvh_txt));
        organ_names = dvh_txt(organ_indices);
        dvh_data = dvh_raw;
%         ind_to_remove = [];
%         for i=1:size(dvh_num,2)
%             if isnan(dvh_num(2,i))
%                 ind_to_remove = [ind_to_remove i];
%             end
%         end
%         dvh_data(:,ind_to_remove) = [];

        %organ_indices = [organ_indices; size(dvh_raw,1)+1];
        for i=1:length(organ_names)
            for j=1:numPatients
                %dvh_for_patient = dvh_raw(organ_indices(i)+1:organ_indices(i+1)-1, 3*j-2:3*j-1);
                dvh_for_patient = dvh_raw(organ_indices(i)-1+j*3:organ_indices(i)+j*3,:);
                nanIndices = ~cell2mat(cellfun(@isnan,dvh_for_patient,'UniformOutput',false)); %~isnan(dvh_for_patient);
                dvh_withoutNaN = dvh_for_patient(nanIndices(:,1),:);
                dvh_for_patient = dvh_withoutNaN';
                ddbs(j).(['dvh_', organ_names{i}]) = cell2mat(dvh_for_patient);
            end
        end
    end
catch
    errordlg('There was an errror reading the DVH data. Please check the data format and try again.','DVH Import error','modal')
end

return;


% --------- supporting sub-functions
function str = repSpaceHyp(str)
indSpace = findstr(str,' ');
indDot = findstr(str,'.');
str(indDot) = [];
indOpenParan = findstr(str,'(');
indCloseParan = findstr(str,')');
indToReplace = [indSpace indOpenParan indCloseParan];
str(indToReplace) = '_';
indGreaterThan = findstr(str,'>');
indLessThan = findstr(str,'<');
str(indGreaterThan) = 'G';
str(indLessThan) = 'L';
return;
