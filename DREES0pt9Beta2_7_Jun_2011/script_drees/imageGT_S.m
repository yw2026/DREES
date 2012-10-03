function imageGT_S(comm)

%OHJ 07/26/2012, script-based DREES

global statC
global stateS

indexS=statC{end};

if ~exist('comm')
    comm = 'init';
end


switch upper(comm)

    case 'INIT'

       
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
        dataX = double(statC{indexS.scriptDreesData}.D_selected_data);
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

        y = statC{indexS.scriptDreesData}.D_outcome_group;
   
        f = figure
        range=[0.15 0.15 0.7 0.7];
        hAxis = axes('position',range,'parent', f)
        set(hAxis,'position',range)


        stateS.IGT.run      = 1;
        stateS.IGT.runNum   = 0;
        stateS.IGT.numIter  = numIter;
        stateS.IGT.combX    = combX;
        stateS.IGT.combY    = combY;
        stateS.IGT.dataX    = dataX;
        stateS.IGT.y        = y;
        stateS.IGT.hAxis    = hAxis;
        stateS.IGT.varNames = statC{indexS.scriptDreesData}.D_selected_variables;
        
        %create play, pause, explore controls
        %hfig = findobj('tag','DREESGUI');
        units = 'normalized';
        stateS.IGT.playH    = uicontrol('style','pushbutton','string','Play','units',units,'position',[0.87 0.80 0.12 0.05],'callBack','imageGT_S(''play'')');
        stateS.IGT.pauseH   = uicontrol('style','pushbutton','string','Pause','units',units,'position',[0.87 0.75 0.12 0.05],'callBack','imageGT_S(''pause'')');
        stateS.IGT.sliderH  = uicontrol('style','slider','min',1,'max',numIter,'SliderStep',[1/numIter 5/numIter],'value',1,'units',units,'position',[0.87 0.70 0.12 0.05],'callBack','imageGT_S(''sliderCall'')');
        stateS.IGT.viewH    = uicontrol('style','pushbutton','units',units,'position',[0.87 0.65 0.12 0.05],'string','view Vars','callBack','imageGT_S(''viewInfo'')');        
        
        %add thses handles to misc. explore handles
        %stateS.explore.miscHandles = [ stateS.IGT.playH stateS.IGT.pauseH stateS.IGT.sliderH stateS.IGT.viewH];
        
        %show movie on explore-axis
        imageGT_S('showMovie')

    case 'PLAY'
        stateS.IGT.run = 1;
        imageGT_S('showmovie')
        
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
