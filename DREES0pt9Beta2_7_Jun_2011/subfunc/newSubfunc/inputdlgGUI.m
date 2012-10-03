function answerC = inputdlgGUI(command,varargin)
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
        prompt      = varargin{1};
        dlgTitle    = varargin{2};
        inputTypeC  = varargin{3};
        inputQuestC = varargin{4};
        def         = varargin{5};
        handles     = varargin{6};
        x           = varargin{7};
        xname       = varargin{8};
        hAxis       = varargin{9};
        hDLG = figure('name',dlgTitle,'numbertitle','off',...
            'position',[200 150 350 250], 'doublebuffer', 'on','CloseRequestFcn',...
            'DREES(''closeRequest'')','backingstore','on','tag',...
            'DREESGUI', 'renderer', 'zbuffer','resize','on','color',[0.8 0.9 0.9],'menubar','none','windowStyle','modal');        
        units = 'normalized';
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
        uicontrol(hDLG,'style','push','string','Done','CallBack','inputdlgGUI(''setVals'');','units',units,'position',[0.45,0.92-(i+1)*0.1,0.1,0.07],'horizontalAlignment','center')
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
            if ~isfield(handles,answerC{1}) | ~isfield(handles,answerC{2})
                errordlg('Undefined Time axis or Event variables','Actuarial Survival');
            else
                time=handles.(answerC{1});
                event=handles.(answerC{2});
                dp=str2num(answerC{3});
                bp=str2num(answerC{4});
                cens=event(:)==dp;
                stateS.explore.axis = plot_actuarial_survival(stateS.explore.axis,x,bp,cens,time,xname);
                if ~isempty(bp)
                    stateS.explore.miscHandles = [stateS.explore.miscHandles legend(hAxis,[xname,'>',num2str(bp)],[xname,'<=',num2str(bp)])];
                end
            end
        end
        return
end
