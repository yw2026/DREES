function nomogramPlot(hAxis,handles)
%function nomogramPlot(hAxis,handles)
%
%this function plots nomogram on the passed hAxis
%
%APA 10/27/2006, extracted from DREES_GUI
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

delete(stateS.explore.miscHandles)
cla(hAxis);
reset(hAxis);
axes(hAxis);
stateS.explore.miscHandles = [];
set(hAxis,'visible','off')

for i=1:length(handles.SelectedVariableNames)
    varName{i}=handles.SelectedVariableNames{i};
end

[index,dummy] = listdlg('PromptString','Select Variables:',...
    'SelectionMode','single',...
    'ListString',varName);
if dummy == 0
    return;
end

x=handles.dataX(:,index);
xname = varName{index};

% regression or survival analysis?
[index,dummy] = listdlg('PromptString','Select Type of Analysis',...
    'SelectionMode','single',...
    'ListString',{'Regression (ROC)','Survival (logrank)'});
if dummy == 0
    return;
end
set(stateS.explore.axis,'nextPlot','add')
switch num2str(index)
    case '1' % ROC
        y = handles.outcome(:)>=str2num(get(stateS.processData.endptSel,'String'));
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
        [cutoff_roc,TPF,FPF] = drxlr_get_cutoff_roc(x,handles.outcome(:),T);
        TPF = TPF{1};
        FPF = FPF{1};
        Az=trapz(FPF,TPF);
        stateS.explore.miscHandles = [stateS.explore.miscHandles plot(FPF,TPF,'k-','LineWidth',1.5,'MarkerSize',12)];
        stateS.explore.miscHandles = [stateS.explore.miscHandles xlabel('False positive rate (1-Specificity)'), ylabel('True positive rate (Sensitivity)')];
        axis(hAxis,[0 1 0 1])
        str=['Az=',num2str(Az,2)];
        stateS.explore.miscHandles = [stateS.explore.miscHandles text(0.65,0.5,str,'Color','k','parent',hAxis,'interpreter','none')];
        stateS.explore.miscHandles = [stateS.explore.miscHandles text(0.65,0.4,[xname, ' cutoff = ',num2str(cutoff_roc)],'Color','k','parent',hAxis,'interpreter','none')];

    case '2' % logrank
        %x=handles.dataX(:,index);
        %         xname = varName{index};
        prompt = {'Enter Time-axis variable', 'Enter Event variable',  'Enter event identifier','Enter Number of Percentiles','Enter Percentile-limits'};
        %obtain the name of time-variable
        timeIndex = strmatch('Time',handles.fieldnames);
        if isempty(timeIndex)
            timeStr = 'TimeAxis';
        else
            timeStr = handles.fieldnames{timeIndex(1)};
        end
        def={timeStr,'PatientStatus','4','100','[0.25 0.75]'};
        dlgTitle=['Survival break points for ',xname];
        answer=inputdlg(prompt,dlgTitle,1,def);
        if ~isfield(handles,answer{1}) | ~isfield(handles,answer{2})
            errordlg('Undefined Time axis or Event variables','Actuarial Survival');
        else
            time = handles.(answer{1});
            event = handles.(answer{2});
            nprc = str2num(answer{4});
            prclimit = str2num(answer{5});
            if max(prclimit)>1 | length(prclimit)~=2
                return;
            end
            dp = str2num(answer{3});
            cens = event(:)==dp;
            [cutoff_logrank, p_adjusted] = drxlr_get_cutoff_logrank(x,time,cens,nprc,prclimit);
            bp = cutoff_logrank;            
            stateS.explore.axis = plot_actuarial_survival(stateS.explore.axis,x,bp,cens,time,xname);
            stateS.explore.miscHandles = [stateS.explore.miscHandles legend(hAxis,[xname,'>',num2str(bp)],[xname,'<=',num2str(bp)])];
            %display cutoff on the plot
            xLim = get(gca,'xLim');
            xTxt = xLim(1) + diff(xLim)*0.65;
            stateS.explore.miscHandles = [stateS.explore.miscHandles text(xTxt,0.65,['cutoff = ',num2str(cutoff_logrank)],'Color','k','parent',hAxis,'interpreter','none')];
        end
end

set(hAxis,'visible','on')
