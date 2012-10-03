function rocPlot_S

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

y = statC{indexS.scriptDreesData}.D_outcome_group;
prompt={'Enter the threshold step value:'};
Tstep=0.1;
def={num2str(Tstep)};
dlgTitle='ROC Analysis';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
if isempty(answer)
    return;
end
Tstep=str2num(answer{1});

f = figure
range=[0.15 0.15 0.7 0.7];
hAxis = axes('position',range,'parent', f)
set(hAxis,'position',range)

plot_roc(hAxis,y,Tstep,statC{indexS.scriptDreesData}.mu);
set(hAxis,'visible','on')
