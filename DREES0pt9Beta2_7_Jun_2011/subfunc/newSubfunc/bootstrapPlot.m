function handles = bootstrapPlot(hAxis,handles)
%function bootstrapPlot(hAxis,handles)
%
%this function plots bootstrap analysis on the passed hAxis
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

if ~isfield(handles,'addset')
    button = questdlg({['No bootstrap data is available!',...
        ' Do you want to generate one?']}, 'Bootstrap Plot','NO','YES','YES');
    if strcmp(button,'NO')
        return;
    else
        prompt={'Enter number of bootstrap samples','Enter Statistica test 1:Wald, 2:Likelihood ratio test, 3: joint test)','Enter max. iterations of logistic regression:', 'Enter convergence tolerance of logistic regression:',...
            'Enter test regularization'};
        def={num2str(5*length(handles.outcome(:))),num2str(1),num2str(300),num2str(1e-6), num2str(0.5)};
        dlgTitle=['Bootstrap Plot Parameters'];
        answer=inputdlg(prompt,dlgTitle,1,def);
        if isempty(answer)
            set(hObject,'value',0)
            return;
        end
        nboot=str2num(answer{1});
        stat_tests = {'Wald', 'LRT','Wald_LRT'};
        test_method = stat_tests{str2num(answer{2})};
        logiter_param = str2num(answer{3});
        logtol_param = str2num(answer{4});
        lambda = str2num(answer{5});
        waitbar_handle = waitbar(0,'Bootstrap analysis...');
        set(waitbar_handle,'name','Bootstrap Plot');
        guiflag = 1;
        y=handles.outcome(:)>=str2num(get(stateS.processData.endptSel,'String'));
        handles.addset= drxlr_simple_bootstrap_analysis(handles.dataX, y, nboot, test_method, logiter_param,logtol_param,lambda, guiflag, waitbar_handle);
        close(waitbar_handle);
    end
end
plot_bootstrap(hAxis,handles.addset);
%colorbar('peer',hAxis)
set(hAxis,'Ytick',[size(handles.addset{1},1)/2:size(handles.addset{1},1):prod(size(handles.addset{1}))])
%set(hAxis,'YtickLabel',handles.SelectedVariableNames);
set(hAxis,'YtickLabel',handles.AllVariableNames);
xlabel('Bootstrap Sample')
set(hAxis,'Xtick',[1:10:length(handles.addset)])
set(hAxis,'visible','on')
return
