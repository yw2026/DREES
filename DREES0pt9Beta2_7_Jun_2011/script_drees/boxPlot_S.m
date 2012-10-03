function boxPlot_S

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

for i=1:length(statC{indexS.scriptDreesData}.D_selected_variables)
    varName{i}=statC{indexS.scriptDreesData}.D_selected_variables{i};
end
[index,dummy] = listdlg('PromptString','Select Variables:',...
    'SelectionMode','multiple',...
    'ListString',varName);
if dummy == 0
    return;
end

f = figure
range=[0.15 0.15 0.7 0.7];
hAxis = axes('position',range,'parent', f)
set(hAxis,'position',range)



x=double(statC{indexS.scriptDreesData}.D_selected_data(:,index));
xname=varName(index);
drxlr_boxwhisPlot(x,xname,hAxis);
