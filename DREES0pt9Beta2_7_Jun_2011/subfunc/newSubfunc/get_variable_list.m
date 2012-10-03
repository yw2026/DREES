function [outcome, dataX, SelectedVariableNames, isVarValid, validObs] = get_variable_list(handles)
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


global stateS
index=get(stateS.processData.listVar,'Value');
rem_entry=[]; % samples to be removed
outcome = [];
dataX=[];
SelectedVariableNames={};
fieldnames = handles.fieldnames;
isVarValid = 1; % 1:valid, 0:invalid

modelTypeC = get(stateS.processData.modelType,'string');
modelVal = get(stateS.processData.modelType,'value');
if strcmpi(modelTypeC{modelVal},'Analytical')
    dataX                   = [];
    SelectedVariableNames   = {};
    isVarValid              = 1;
    outcome                 = handles.outcome(:);
    validObs                = 1:length(outcome);
    return;
end

for i=1:length(index)
    data = [];
    temp = [];
    temp1=[];
    SelectedVariableNames={SelectedVariableNames{:},handles.fieldnames{index(i)}};
    if(findstr(handles.fieldnames{index(i)}, 'Dx')),
        SelectedVariableNames(end) = [];
        if isempty(handles.params.(fieldnames{index(i)}))
            errordlg(['No values entered for ',handles.fieldnames{index(i)}],'get_variable_list');
            isVarValid = 0;
            return;
        else
            dose=str2num(handles.params.(fieldnames{index(i)}));
        end
        str = handles.fieldnames{index(i)}(4:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        DxVal = []; % initialize DxVal to empty         
        for k = 1:length(dose)
            DxVal = [];
            for j = 1:length(data),
                DxVal(j, k) = calc_Dx(data{j}(1,:), data{j}(2,:), dose(k));
            end
            temp(indexFill,k)   = DxVal(:, k);
            temp(indexEmpty,k)  = NaN;
            DxVal = temp;
            SelectedVariableNames = {SelectedVariableNames{:}, [handles.fieldnames{index(i)} num2str(dose(k))]};
        end
        dataX = [dataX DxVal];
    elseif(findstr(handles.fieldnames{index(i)}, 'Dc')),
        SelectedVariableNames(end) = [];
        if isempty(handles.params.(fieldnames{index(i)}))
            errordlg(['No values entered for ',handles.fieldnames{index(i)}],'get_variable_list');
            isVarValid = 0;
            return;
        else
            dose=str2num(handles.params.(fieldnames{index(i)}));
        end
        str = handles.fieldnames{index(i)}(4:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        DcVal = []; % initialize DxVal to empty   
        txFraction = handles.(stateS.TxFractionField);
        for k = 1:length(dose)
            DcVal = [];
            for j = 1:length(data),
                DcVal(j, k) = calc_Dc(data{j}(1,:), data{j}(2,:), dose(k),txFraction(j));
            end
            temp(indexFill,k)   = DcVal(:, k);
            temp(indexEmpty,k)  = NaN;
            DcVal = temp;
            SelectedVariableNames = {SelectedVariableNames{:}, [handles.fieldnames{index(i)} num2str(dose(k))]};
        end
        dataX = [dataX DcVal];
        
    elseif(findstr(handles.fieldnames{index(i)}, 'MOHx')),
        SelectedVariableNames(end) = [];
        if isempty(handles.params.(fieldnames{index(i)}))
            errordlg(['No values entered for ',handles.fieldnames{index(i)}],'get_variable_list');
            isVarValid = 0;
            return;
        else
            dose=str2num(handles.params.(fieldnames{index(i)}));
        end
        str = handles.fieldnames{index(i)}(6:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        mDxUVal = []; % initialize mDxUVal to empty 
        for k = 1:length(dose)
            mDxUVal = [];
            for j = 1:length(data),
                %  Flag variable 1 = return % volume as opposed to absolute
                %  volumes
                mDxUVal(j, k) = calc_mDx(data{j}(1,:), data{j}(2,:), dose(k),'upper');
            end
            temp(indexFill,k)   = mDxUVal(:, k);
            temp(indexEmpty,k)  = NaN;
            mDxUVal = temp;            
            SelectedVariableNames = {SelectedVariableNames{:}, [handles.fieldnames{index(i)} num2str(dose(k))]};
        end
        dataX = [dataX mDxUVal];
    elseif(findstr(handles.fieldnames{index(i)}, 'MOHc')),
        SelectedVariableNames(end) = [];
        if isempty(handles.params.(fieldnames{index(i)}))
            errordlg(['No values entered for ',handles.fieldnames{index(i)}],'get_variable_list');
            isVarValid = 0;
            return;
        else
            dose=str2num(handles.params.(fieldnames{index(i)}));
        end
        str = handles.fieldnames{index(i)}(6:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        mDcUVal = []; % initialize mDcUVal to empty 
        txFraction = handles.(stateS.TxFractionField);
        for k = 1:length(dose)
            mDcUVal = [];
            for j = 1:length(data),
                %  Flag variable 1 = return % volume as opposed to absolute
                %  volumes
                mDcUVal(j, k) = calc_mDc(data{j}(1,:), data{j}(2,:), dose(k),'upper',txFraction(j));
            end
            temp(indexFill,k)   = mDcUVal(:, k);
            temp(indexEmpty,k)  = NaN;
            mDcUVal = temp;            
            SelectedVariableNames = {SelectedVariableNames{:}, [handles.fieldnames{index(i)} num2str(dose(k))]};
        end
        dataX = [dataX mDcUVal];
    elseif(findstr(handles.fieldnames{index(i)}, 'MOCx')),
        SelectedVariableNames(end) = [];
        if isempty(handles.params.(fieldnames{index(i)}))
            errordlg(['No values entered for ',handles.fieldnames{index(i)}],'get_variable_list');
            isVarValid = 0;
            return;
        else
            dose=str2num(handles.params.(fieldnames{index(i)}));
        end
        str = handles.fieldnames{index(i)}(6:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        mDxLVal = []; % initialize mDxLVal to empty
        for k = 1:length(dose)
            mDxLVal = [];
            for j = 1:length(data),
                %  Flag variable 1 = return % volume as opposed to absolute
                %  volumes
                mDxLVal(j, k) = calc_mDx(data{j}(1,:), data{j}(2,:), dose(k),'lower');
            end
            temp(indexFill,k)   = mDxLVal(:, k);
            temp(indexEmpty,k) 	= NaN;
            mDxLVal = temp;                        
            SelectedVariableNames = {SelectedVariableNames{:}, [handles.fieldnames{index(i)} num2str(dose(k))]};
        end
        dataX = [dataX mDxLVal];

    elseif(findstr(handles.fieldnames{index(i)}, 'Vx')),
        SelectedVariableNames(end) = [];
        if isempty(handles.params.(fieldnames{index(i)}))
            errordlg(['No values entered for ',handles.fieldnames{index(i)}],'get_variable_list');
            isVarValid = 0;
            return;
        else
            dose=str2num(handles.params.(fieldnames{index(i)}));
        end
        str = handles.fieldnames{index(i)}(4:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        VxVal = []; % initialize VxVal to empty 
        for k = 1:length(dose),
            VxVal = [];
            for j = 1:length(data),
                %  Flag variable 1 = return % volume as opposed to absolute
                %  volumes
                VxVal(j, k) = calc_Vx(data{j}(1,:), data{j}(2,:), dose(k), 1);
            end
            temp(indexFill,k)   = VxVal(:, k);
            temp(indexEmpty,k) 	= NaN;
            VxVal = temp;                        
            SelectedVariableNames = {SelectedVariableNames{:}, [handles.fieldnames{index(i)} num2str(dose(k))]};
        end
        dataX = [dataX VxVal];

    elseif(findstr(handles.fieldnames{index(i)}, 'Vu')),
        SelectedVariableNames(end) = [];
        if isempty(handles.params.(fieldnames{index(i)}))
            errordlg(['No values entered for ',handles.fieldnames{index(i)}],'get_variable_list');
            isVarValid = 0;
            return;
        else
            dose=str2num(handles.params.(fieldnames{index(i)}));
        end
        str = handles.fieldnames{index(i)}(4:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        VuVal = []; % initialize VxVal to empty 
        for k = 1:length(dose),
            VuVal = [];
            for j = 1:length(data),
                %  Flag variable 1 = return % volume as opposed to absolute
                %  volumes
                VuVal(j, k) = calc_Vu(data{j}(1,:), data{j}(2,:), dose(k), 1);
            end
            temp(indexFill,k)   = VuVal(:, k);
            temp(indexEmpty,k) 	= NaN;
            VuVal = temp;                        
            SelectedVariableNames = {SelectedVariableNames{:}, [handles.fieldnames{index(i)} num2str(dose(k))]};
        end
        dataX = [dataX VuVal];

    elseif(findstr(handles.fieldnames{index(i)}, 'Mindose'))
        str = handles.fieldnames{index(i)}(9:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        for j = 1:length(data),
            temp(j)= calc_minDose(data{j}(1,:), data{j}(2,:));
        end
        temp1(indexFill)  = temp;
        temp1(indexEmpty) = NaN;
        temp = temp1;
        dataX = [dataX temp'];
    elseif(findstr(handles.fieldnames{index(i)}, 'Maxdose'))
        str = handles.fieldnames{index(i)}(9:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        for j = 1:length(data),
            %  Using the CERR calc_maxDose function
            temp(j)= calc_maxDose(data{j}(1,:), data{j}(2,:));
        end
        temp1(indexFill)  = temp;
        temp1(indexEmpty) = NaN;
        temp = temp1;
        dataX = [dataX temp'];
    elseif(findstr(handles.fieldnames{index(i)}, 'Meandose'))
        str = handles.fieldnames{index(i)}(10:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        for j = 1:length(data),
            temp(j)= calc_meanDose(data{j}(1,:), data{j}(2,:));
        end
        temp1(indexFill)  = temp;
        temp1(indexEmpty) = NaN;
        temp = temp1;
        dataX = [dataX temp'];
    elseif(findstr(handles.fieldnames{index(i)}, 'Mediandose'))
        str = handles.fieldnames{index(i)}(12:end);
        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        for j = 1:length(data),
            temp(j)= calc_medianDose(data{j}(1,:), data{j}(2,:));
        end
        temp1(indexFill)  = temp;
        temp1(indexEmpty) = NaN;
        temp = temp1;
        dataX = [dataX temp'];        
    elseif(findstr(handles.fieldnames{index(i)}, 'GEUD'))
        SelectedVariableNames(end) = [];
        if isempty(handles.params.(fieldnames{index(i)}))
            errordlg(['No values entered for ',handles.fieldnames{index(i)}],'get_variable_list');
            isVarValid = 0;
            return;
        else
            a=str2num(handles.params.(fieldnames{index(i)}));
        end
        
        str = handles.fieldnames{index(i)}(6:end);

        data = handles.(['dvh_', str]);
        [data, indexEmpty, indexFill] = removeEmpty(data);
        for k = 1:length(a)
            temp = [];
            for j = 1:length(data),
                temp(j,k)= calc_EUD(data{j}(1,:), data{j}(2,:), a(k));
            end
            temp1(indexFill,k)  = temp(:,k);
            temp1(indexEmpty,k) = NaN;
            temp = temp1;
            SelectedVariableNames = {SelectedVariableNames{:}, [handles.fieldnames{index(i)} num2str(a(k))]};
        end
        dataX = [dataX temp];

    else
        temp=handles.(fieldnames{index(i)})';
        %Remove NaN entries by deault (APA change 9/17/07)
%         ind=find(isnan(temp));
%         if ~isempty(ind)
%             h=warndlg(['!!There are empty entries in ', fieldnames{index(i)},' !!'],'Variable Selection');
%             set(h,'position', [285.5 431.333 197 79]);
%             button = questdlg('What do you want to do?',...
%                 'Variable Selection','Remove entries','Exclude Variable','Continue','Continue');
%             close(h);
%             if strcmp(button,'Remove entries')
%                 rem_entry=[rem_entry,ind];
%             elseif strcmp(button,'Exclude Variable')
%                 SelectedVariableNames=SelectedVariableNames{1:i-1};
%                 continue;
%             end
%         end
        dataX = [dataX temp(:)];
    end
end

outcome=handles.outcome(:);

% if ~isempty(rem_entry)
%     vec=setdiff([1:size(dataX,1)],rem_entry);
%     dataX=dataX(vec,:);
%     outcome=outcome(vec);
% end
% ln = length(outcome);

%Remove NaN entries
sumDataX  = sum(dataX,2);
nanV      = isnan(sumDataX);
validObs = find(nanV==0);
dataX(nanV,:) = [];
outcome(nanV) = [];
ln = length(outcome);

% check for data centering
if get(stateS.processData.dataCentering,'Value')==1
    mean_data = repmat(mean(dataX,1),ln,1);
    std_data = repmat(std(dataX,1),ln,1);
    dataX = (dataX-mean_data)./(std_data+eps);
end
set(stateS.model.sampleSiz,'String',['Sample Size = ',num2str(ln)]);

return

function [data, indexEmpty, indexFill] = removeEmpty(data)
indexEmpty  = cellfun('isempty',data);
indexFill   = 1:length(data);
indexFill(indexEmpty) = [];
data(indexEmpty) = [];
return
