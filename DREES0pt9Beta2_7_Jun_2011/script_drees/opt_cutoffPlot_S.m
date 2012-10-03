function opt_cutoffPlot_S

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};


for i=1:length(statC{indexS.scriptDreesData}.D_selected_variables)
    varName{i}=statC{indexS.scriptDreesData}.D_selected_variables{i};
end

[index,dummy] = listdlg('PromptString','Select Variables:',...
    'SelectionMode','single',...
    'ListString',varName);
if dummy == 0
    return;
end

x=double(statC{indexS.scriptDreesData}.D_selected_data(:,index));
xname = varName{index};

% regression or survival analysis?
[index,dummy] = listdlg('PromptString','Select Type of Analysis',...
    'SelectionMode','single',...
    'ListString',{'Regression (ROC)','Survival (logrank)'});
if dummy == 0
    return;
end

switch num2str(index)
    case '1' % ROC
        y = statC{indexS.scriptDreesData}.D_outcome_group;
        prompt={'Enter the threshold step value:'};
        Tstep=0.1;
        def={num2str(Tstep)};
        dlgTitle='ROC Analysis';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
        if isempty(answer)
            set(hObject,'value',0)
            return;
        end
        Tstep=str2num(answer{1});
        T=[1:-Tstep:0];
        nprc = [];
        cens = [];
        [cutoff_roc,TPF,FPF] = drxlr_get_cutoff_roc(x,statC{indexS.scriptDreesData}.D_outcome_grade,T);
        TPF = TPF{1};
        FPF = FPF{1};
        Az=trapz(FPF,TPF);
        
        f = figure
        range=[0.15 0.15 0.7 0.7];
        hAxis = axes('position',range,'parent', f)
        set(hAxis,'position',range)

        
        plot(FPF,TPF,'k-','LineWidth',1.5,'MarkerSize',12);
        xlabel('False positive rate (1-Specificity)','FontSize',12), ylabel('True positive rate (Sensitivity)','FontSize',12);
        

        str=['Az=',num2str(Az,2)];
        text(0.65,0.5,str,'Color','k','parent',hAxis,'interpreter','none');
        text(0.65,0.4,[xname, ' cutoff = ',num2str(cutoff_roc)],'Color','k','parent',hAxis,'interpreter','none');

    case '2' % logrank
        %x=handles.dataX(:,index);
        %         xname = varName{index};
        prompt = {'Enter Time-axis variable', 'Enter Event variable',  'Enter event identifier','Enter Number of Percentiles','Enter Percentile-limits'};
        %obtain the name of time-variable
        timeIndex = strmatch('Time',statC{indexS.scriptDreesData}.D_variables);
        if isempty(timeIndex)
            timeStr = 'TimeAxis';
        else
            timeStr = statC{indexS.scriptDreesData}.D_variables{timeIndex(1)};
        end
        def={timeStr,'PatientStatus','4','100','[0.25 0.75]'};
        dlgTitle=['Survival break points for ',xname];
        answer=inputdlg(prompt,dlgTitle,1,def);
        if ~any(ismember(statC{indexS.scriptDreesData}.D_variables,answer{1})) | ~any(ismember(statC{indexS.scriptDreesData}.D_variables,answer{2}))
            errordlg('Undefined Time axis or Event variables','Actuarial Survival');
        else
            time = double(statC{indexS.scriptDreesData}.D_data(:,ismember(statC{indexS.scriptDreesData}.D_variables,answer{1})));  
            event = double(statC{indexS.scriptDreesData}.D_data(:,ismember(statC{indexS.scriptDreesData}.D_variables,answer{2})));
            nprc = str2num(answer{4});
            prclimit = str2num(answer{5});
            if max(prclimit)>1 | length(prclimit)~=2
                return;
            end
            dp = str2num(answer{3});
            cens = event(:)==dp;
            time=time';
            [cutoff_logrank, p_adjusted] = drxlr_get_cutoff_logrank(x,time,cens,nprc,prclimit);
            bp = cutoff_logrank;     
            
            f = figure
            range=[0.15 0.15 0.7 0.7];
            hAxis = axes('position',range,'parent', f)
            set(hAxis,'position',range)
            hold on;
            plot_actuarial_survival(hAxis,x,bp,cens,time,xname);%%%%%%%%%%%%%%%
            legend(hAxis,[xname,'>',num2str(bp)],[xname,'<=',num2str(bp)]);
            %display cutoff on the plot
            xLim = get(gca,'xLim');
            xTxt = xLim(1) + diff(xLim)*0.65;
            text(xTxt,0.65,['cutoff = ',num2str(cutoff_logrank)],'Color','k','parent',hAxis,'interpreter','none');
            hold off
        end
end

set(hAxis,'visible','on')
