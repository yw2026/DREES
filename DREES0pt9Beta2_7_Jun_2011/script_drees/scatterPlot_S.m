function scatterPlot_S

%OHJ 07/26/2012, script-based DREES


global statC
indexS=statC{end};

%select abcissa and ordinate
[index,dummy] = listdlg('PromptString','Select Ordinate Variable:',...
    'SelectionMode','single',...
    'ListString',statC{indexS.scriptDreesData}.D_selected_variables);
if dummy == 0
    return;
end


var1=double(statC{indexS.scriptDreesData}.D_selected_data(:,index));
nvar1=statC{indexS.scriptDreesData}.D_selected_variables{index};
[index,dummy] = listdlg('PromptString','Select Abscissa Variable',...
    'SelectionMode','single',...
    'ListString',statC{indexS.scriptDreesData}.D_selected_variables);
if dummy == 0
    return;
end


var2=double(statC{indexS.scriptDreesData}.D_selected_data(:,index));
nvar2=statC{indexS.scriptDreesData}.D_selected_variables{index};

f = figure
range=[0.15 0.15 0.7 0.7];
hAxis = axes('position',range,'parent', f)
set(hAxis,'position',range)

y=statC{indexS.scriptDreesData}.D_outcome_group;

set(hAxis,'nextPlot','add')
plot(hAxis,var1,var2,'k.','MarkerSize',6);
plot(hAxis,var1(y),var2(y),'ro','MarkerSize',6);
xlabel(hAxis,nvar1,'interpreter','none','FontSize',14);
ylabel(hAxis,nvar2,'interpreter','none','FontSize',14);
legend(hAxis,'No complication','With complication','FontSize',12);
set(gcf,'color',[1 1 1]);
box on;