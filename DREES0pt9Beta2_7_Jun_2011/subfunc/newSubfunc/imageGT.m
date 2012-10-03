function imageGT(command,hAxis,dreesDataS)
%function imageGT(command,hAxis,dreesDataS)
%
%This is a callback function for Image Grand Tour.
%INPUT: command     - represents callback action
%       hAxis       - handle on which to display the Image Grand tour
%       dreesDataS  - structure array of data stored in DREES
%
%APA 12/08/2006, based on inputs from Dr. Drasy and Dr. El naqa
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

switch upper(command)

    case 'INIT'

        delete(stateS.explore.miscHandles)
        cla(hAxis);
        reset(hAxis);
        axes(hAxis);
        stateS.explore.miscHandles = [];
        set(hAxis,'visible','off')

        %get parameters from the user
        prompt={'Number of linear combs. on x-axis (numX)','Number of linear combs. on y-axis (numY)','Number of iterations (numIter)'};
        def={'1','1','10'};
        dlgTitle=['IGT parameters'];
        answer=inputdlg(prompt,dlgTitle,1,def);
        if isempty(answer)
            return;
        end
        numX    = str2num(answer{1});
        numY    = str2num(answer{2});
        numIter = str2num(answer{3});

        %center data
        dataX = dreesDataS.dataX;
        numData   = size(dataX,1);
        numVar    = size(dataX,2);
        mean_data = repmat(mean(dataX,1),numData,1);
        std_data  = repmat(std(dataX,1),numData,1);
        dataX     = (dataX-mean_data)./(std_data+eps);

        %store numIter combinations
        for i=1:numIter
            combX(i,:) = randsample(numVar,numX)';
            combY(i,:) = randsample(numVar,numY)';
        end

        y = dreesDataS.outcome(:)>=str2num(get(stateS.processData.endptSel,'String'));

        stateS.IGT.run      = 1;
        stateS.IGT.runNum   = 0;
        stateS.IGT.numIter  = numIter;
        stateS.IGT.combX    = combX;
        stateS.IGT.combY    = combY;
        stateS.IGT.dataX    = dataX;
        stateS.IGT.y        = y;
        stateS.IGT.hAxis    = hAxis;
        stateS.IGT.varNames = dreesDataS.SelectedVariableNames;
        
        %create play, pause, explore controls
        hfig = findobj('tag','DREESGUI');
        units = 'normalized';
        stateS.IGT.playH    = uicontrol(hfig,'style','pushbutton','string','Play','units',units,'position',[0.9 0.85 0.05 0.03],'callBack','imageGT(''play'')');
        stateS.IGT.pauseH   = uicontrol(hfig,'style','pushbutton','string','Pause','units',units,'position',[0.9 0.80 0.05 0.03],'callBack','imageGT(''pause'')');
        stateS.IGT.sliderH  = uicontrol(hfig,'style','slider','min',1,'max',numIter,'SliderStep',[1/numIter 5/numIter],'value',1,'units',units,'position',[0.87 0.75 0.11 0.03],'callBack','imageGT(''sliderCall'')');
        stateS.IGT.viewH    = uicontrol(hfig,'style','pushbutton','units',units,'position',[0.89 0.70 0.07 0.03],'string','view Vars','callBack','imageGT(''viewInfo'')');        
        
        %add thses handles to misc. explore handles
        stateS.explore.miscHandles = [stateS.explore.miscHandles stateS.IGT.playH stateS.IGT.pauseH stateS.IGT.sliderH stateS.IGT.viewH];
        
        %show movie on explore-axis
        imageGT('showMovie')

    case 'PLAY'
        stateS.IGT.run = 1;
        imageGT('showmovie')
        
    case 'PAUSE'
        stateS.IGT.run = 0;
        drawnow
        
    case 'SLIDERCALL'
        stateS.IGT.run = 0;
        drawnow
        stateS.IGT.runNum = round(get(gcbo,'value'));
        combX   = stateS.IGT.combX;
        combY   = stateS.IGT.combY;
        dataX   = stateS.IGT.dataX;
        y       = stateS.IGT.y;
        hAxis   = stateS.IGT.hAxis;
        i       = stateS.IGT.runNum;
        var1    = sum(dataX(:,combX(i,:)),2);
        var2    = sum(dataX(:,combY(i,:)),2);
        set(hAxis,'visible','on','nextPlot','replace')
        plot(hAxis,var1,var2,'k.','MarkerSize',6);
        set(hAxis,'visible','on','nextPlot','add')
        plot(hAxis,var1(y),var2(y),'ro','MarkerSize',6);
        set(hAxis,'visible','on','nextPlot','replace')
        drawnow
        
    case 'VIEWINFO'
        combX   = stateS.IGT.combX;
        combY   = stateS.IGT.combY;
        index   = stateS.IGT.runNum;
        disp('-------------------------------')
        disp('x-Variables:')
        disp(stateS.IGT.varNames(combX(index,:)))
        disp('-------------------------------')
        disp('y-Variables:')
        disp(stateS.IGT.varNames(combY(index,:)))        
        
    case 'SHOWMOVIE'
        
        combX   = stateS.IGT.combX;
        combY   = stateS.IGT.combY;
        dataX   = stateS.IGT.dataX;
        y       = stateS.IGT.y;
        hAxis   = stateS.IGT.hAxis;

        if stateS.IGT.runNum==size(combX,1)
            stateS.IGT.runNum = 0;
        end

        %plot scatter-plots iterating 
        while stateS.IGT.run
            stateS.IGT.runNum = stateS.IGT.runNum + 1;
            i = stateS.IGT.runNum;
            var1 = sum(dataX(:,combX(i,:)),2);
            var2 = sum(dataX(:,combY(i,:)),2);
            plot(hAxis,var1,var2,'k.','MarkerSize',6);
            set(hAxis,'visible','on','nextPlot','add')
            plot(hAxis,var1(y),var2(y),'ro','MarkerSize',6);
            pause(0.5)
            set(hAxis,'visible','on','nextPlot','replace')
            set(stateS.IGT.sliderH,'value',i)
            if stateS.IGT.runNum==size(combX,1)
                stateS.IGT.runNum = 0;
            end
        end

end
