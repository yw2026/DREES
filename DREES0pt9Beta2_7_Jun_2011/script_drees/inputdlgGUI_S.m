function answerC = inputdlgGUI_S(comm,varargin)

%OHJ 07/26/2012, script-based DREES

switch upper(comm)
    case 'INIT'
        prompt      = varargin{1};
        dlgTitle    = varargin{2};
        inputTypeC  = varargin{3};
        inputQuestC = varargin{4};
        def         = varargin{5};
        handles     = varargin{6};
        x           = varargin{7};
        xname       = varargin{8};
        
        indexS=handles{end};
        

        hDLG = figure('name',dlgTitle,'numbertitle','off',...
            'position',[200 150 350 250], 'doublebuffer', 'on','CloseRequestFcn',...
            'DREES(''closeRequest'')','backingstore','on','tag',...
            'DREESGUI', 'renderer', 'zbuffer','resize','on','color',[0.8 0.9 0.9],'menubar','none','windowStyle','modal');        
        units = 'normalized';
        
        f = figure
        range=[0.15 0.15 0.7 0.7];
        hAxis = axes('position',range,'parent', f)
        set(hAxis,'position',range)
        
        %uicontrol(hDLG,'style','text','string',prompt,'position',[0.05,0.92,0.9,0.07])
        for i = 1:length(inputTypeC)
            if strcmpi(inputTypeC{i},'edit')
                uicontrol(hDLG,'style','text','string',prompt{i},'units',units,'position',[0.05,0.92-i*0.1,0.55,0.07],'horizontalAlignment','right');
                ud.handles(i) = uicontrol(hDLG,'style',inputTypeC{i},'string',def{i},'units',units,'position',[0.63,0.92-i*0.1,0.32,0.07],'horizontalAlignment','left');
            elseif strcmpi(inputTypeC{i},'popup')
                uicontrol(hDLG,'style','text','string',prompt{i},'units',units,'position',[0.05,0.92-i*0.1,0.55,0.07],'units',units,'horizontalAlignment','right');
                ud.handles(i) = uicontrol(hDLG,'style',inputTypeC{i},'string',inputQuestC{i},'value',def{i},'units',units,'position',[0.63,0.92-i*0.1,0.32,0.07],'horizontalAlignment','left');
            end
        end
        uicontrol(hDLG,'style','push','string','Done','CallBack','inputdlgGUI_S(''setVals'');','units',units,'position',[0.45,0.92-(i+1)*0.1,0.1,0.07],'horizontalAlignment','center')
        ud.dreesHandles = handles;
        ud.x            = x;
        ud.xname        = xname;
        ud.hAxis        = hAxis;
        set(hDLG,'userdata',ud)
        answerC = {};
        uiwait(hDLG)

    case 'SETVALS'
        ud = get(gcf,'userdata');
        handles = ud.dreesHandles;
        x       = ud.x;
        xname   = ud.xname;
        hAxis   = ud.hAxis;
        
        indexS=handles{end};
        
        for i=1:length(ud.handles)
            style = get(ud.handles(i),'style');
            value = get(ud.handles(i),'value');
            string = get(ud.handles(i),'string');
            if strcmpi(style,'edit')
                answerC{i} = get(ud.handles(i),'string');
            elseif strcmpi(style,'popupmenu')
                answerC{i} = string{value};
            end
        end       
        delete(gcf)
        if ~isempty(answerC)
            if ~any(ismember(handles{indexS.scriptDreesData}.D_variables,answerC{1})) | ~any(ismember(handles{indexS.scriptDreesData}.D_variables,answerC{2}))
                errordlg('Undefined Time axis or Event variables','Actuarial Survival');
            else
                
                time = double(handles{indexS.scriptDreesData}.D_data(:,ismember(handles{indexS.scriptDreesData}.D_variables,answerC{1})));  
                event = double(handles{indexS.scriptDreesData}.D_data(:,ismember(handles{indexS.scriptDreesData}.D_variables,answerC{2})));
                time=time';
                dp=str2num(answerC{3});
                bp=str2num(answerC{4});
                cens=event(:)==dp;
                plot_actuarial_survival(hAxis,x,bp,cens,time,xname);
                if ~isempty(bp)
                    legend(hAxis,[xname,'>',num2str(bp)],[xname,'<=',num2str(bp)]);
                end
            end
        end
        return
end
