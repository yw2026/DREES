function select_variable(type, inds)

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

selected_variables={};

if nargin~=0
    if strcmp(lower(type),'index')==1
        for i=1:length(inds)

            selected_variables{i}=statC{indexS.scriptDreesData}.D_variables{inds(i)};
        end
    else
        disp(sprintf('Please call this function in the following way:\n    >> select_variable(''index'', [11 23 35])'));
        return;
    end

    if length(selected_variables)~=0
       selected_variables
    end
    
    statC{indexS.scriptDreesData}.D_selected_variables=selected_variables;
    statC{indexS.scriptDreesData}.D_selected_indices=inds;
    statC{indexS.scriptDreesData}.D_selected_data=statC{indexS.scriptDreesData}.D_data(:,inds);
    
    %non-nan data: D_selected_data
%     temp_data=statC{indexS.scriptDreesData}.D_data(:,inds);
%     nan_idx=[];
%     for i=1:size(temp_data,1)
%         if any(isnan(double(temp_data(i,:))))~=1
%             nan_idx=[nan_idx i];
%         end
%     end
%     statC{indexS.scriptDreesData}.D_selected_data=temp_data(nan_idx,:);
else
    [index,dummy] = listdlg('PromptString','Select Variables:',...
    'SelectionMode','multiple',...
    'ListString',statC{indexS.scriptDreesData}.D_variables);
    if dummy == 0
        return;
    end
    
    inds = index;
    for i=1:length(inds)

        selected_variables{i}=statC{indexS.scriptDreesData}.D_variables{inds(i)};
    end
    
    statC{indexS.scriptDreesData}.D_selected_variables=selected_variables;
    statC{indexS.scriptDreesData}.D_selected_indices=inds;
    statC{indexS.scriptDreesData}.D_selected_data=statC{indexS.scriptDreesData}.D_data(:,inds);
    
    %non-nan data: D_selected_data
%     temp_data=statC{indexS.scriptDreesData}.D_data(:,inds);
%     nan_idx=[];
%     for i=1:size(temp_data,1)
%         if any(isnan(double(temp_data(i,:))))~=1
%             nan_idx=[nan_idx i];
%         end
%     end
%     statC{indexS.scriptDreesData}.D_selected_data=temp_data(nan_idx,:);
end

