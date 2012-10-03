function actuarialPlot_S

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

for i=1:length(statC{indexS.scriptDreesData}.D_selected_variables) 
    varName{i}=statC{indexS.scriptDreesData}.D_selected_variables{i};
end
[index,dummy] = listdlg('PromptString','Select a Variable:',...
    'SelectionMode','single',...
    'ListString',varName);

if dummy == 0
    return;
end
x=double(statC{indexS.scriptDreesData}.D_selected_data(:,index));
xname=varName{index};
prompt={'Enter Time-axis variable', 'Enter Event variable',  'Enter event identifier','Enter variable break point(s):'};
%obtain the name of time-variable
timeIndex = strmatch('Time',statC{indexS.scriptDreesData}.D_variables);
if isempty(timeIndex)
    timeStr = 'TimeAxis';
else
    timeStr = statC{indexS.scriptDreesData}.D_variables{timeIndex(1)};
end
def={1,1,'4',num2str(median(x))};
dlgTitle=['Survival break points for ',xname];
%answer=inputdlg(prompt,dlgTitle,1,def);
inputTypeC = {'popup','popup','edit','edit'};
varNamesC = statC{indexS.scriptDreesData}.originlVariable;
inputQuestC = {varNamesC,varNamesC,'',''};




answer = inputdlgGUI_S('init',prompt,dlgTitle,inputTypeC,inputQuestC,def,statC,x,xname);
% if ~isempty(answer)
% if ~isfield(handles,answer{1}) | ~isfield(handles,answer{2})
%     errordlg('Undefined Time axis or Event variables','Actuarial Survival');
% else
%     time=handles.(answer{1});
%     event=handles.(answer{2});
%     dp=str2num(answer{3});
%     bp=str2num(answer{4});
%     cens=event(:)==dp;
%     stateS.explore.axis = plot_actuarial_survival(stateS.explore.axis,x,bp,cens,time,xname);
%     stateS.explore.miscHandles = [stateS.explore.miscHandles legend(hAxis,[xname,'>',num2str(bp)],[xname,'<=',num2str(bp)])];
% end
% end
return;



