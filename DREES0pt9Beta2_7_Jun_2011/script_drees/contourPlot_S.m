function contourPlot_S

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

[index,dummy] = listdlg('PromptString','Select Ordinate Variable(s):',...
    'SelectionMode','single',...
    'ListString',statC{indexS.scriptDreesData}.SelectedVariableNames);
if dummy == 0
    return;
end
var1=statC{indexS.scriptDreesData}.dataX(:,index);
[index,dummy] = listdlg('PromptString','Select Abscissa Variable(s):',...
    'SelectionMode','single',...
    'ListString',statC{indexS.scriptDreesData}.SelectedVariableNames);
if dummy == 0
    return;
end
var2=statC{indexS.scriptDreesData}.dataX(:,index);

f = figure
range=[0.15 0.15 0.7 0.7];
hAxis = axes('position',range,'parent', f)
set(hAxis,'position',range)

plot_contour(hAxis,var1,var2,statC{indexS.scriptDreesData}.b);
colorbar('peer',hAxis);
xlabel(hAxis,'Linear Combination of Abscissa  Variables','FontSize',12);
ylabel(hAxis,'Linear Combination of  Ordinate Variables','FontSize',12);
set(hAxis,'visible','on')
