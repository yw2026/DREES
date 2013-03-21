function DREES(command,varagrin)
%function DREES(command,varagrin)
%
%Description:  Creates and updates the DREES GUI
%
%Inputs: Various callback strings, which can be found by
%looking at the switch statements below.
%
%Output:  Updates the DREES GUI.
%
%Globals:
%stateS  -- contains option and other settings.
%statC   -- patient data in DREES format.
%
%Algorithm: Standard Matlab GUI callback.
%
%extracted out of DREES_GUI which was created using GUIDE.
%
%APA, 10/25/2006
%
% Copyright 2010, Joseph O. Deasy, on behalf of the DREES development team.
% 
% This file is part of the Dose Response Explorer System (DREES).
% 
% DREES development has been led by:  Ya Wang, Issam El Naqa, Aditya Apte, Gita Suneja, and Joseph O. Deasy.
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

global stateS statC

if ~exist('command','var')
    command = 'init';
end

try
    indexS = statC{end};
end

switch upper(command)
    case 'INIT'
        format compact
        units = 'normalized';
        str1 = ['DREES 1.0 beta'];
        position = [5 40 940 620];
        hCSV = figure('name',str1,'numbertitle','off',...
            'position',position, 'doublebuffer', 'on','CloseRequestFcn',...
            'DREES(''closeRequest'')','backingstore','on','tag',...
            'DREESGUI', 'renderer', 'zbuffer','resize','on','color',[0.8 0.9 0.9]);
        set(hCSV,'menubar','none');
        figureColor = get(hCSV, 'Color');

        %create "read data" handles
        uicontrol(hCSV,'style','frame','units',units,'position',[0.03 0.85 0.25 0.12],'BackgroundColor', figureColor)
        uicontrol(hCSV,'style','text','string','Read data','units',units,'position',[0.105 0.95 0.1 0.03],'fontWeight','bold','fontSize',10,'BackgroundColor', figureColor)
        uicontrol(hCSV,'style','text','string','File Type','units',units,'position',[0.035 0.915 0.05 0.03],'BackgroundColor', figureColor)
        stateS.readData.fileType = uicontrol(hCSV,'style','popupmenu','string',{'Matlab .mat','Excel .xls'},'units',units,'position',[0.09 0.92 0.1 0.03],'value',1,'BackgroundColor', figureColor);
        stateS.readData.go       = uicontrol(hCSV,'style','pushbutton','string','Go','units',units,'position',[0.21 0.92 0.05 0.03],'callBack','DREES(''readDataFile'')','BackgroundColor', figureColor);
        stateS.saveData          = uicontrol(hCSV,'style','pushbutton','string','Save Data in Matlab format','units',units,'position',[0.04 0.87 0.15 0.03],'callBack','DREES(''saveFile'')','BackgroundColor', figureColor);

        %create "process data" handles
        uicontrol(hCSV,'style','frame','units',units,'position',[0.03 0.40 0.25 0.43],'BackgroundColor', figureColor)
        uicontrol(hCSV,'style','text','string','Process data','units',units,'position',[0.105 0.81 0.1 0.03],'fontWeight','bold','fontSize',10,'BackgroundColor', figureColor)
        uicontrol(hCSV,'style','text','string','Model Type','units',units,'position',[0.035 0.755 0.09 0.03],'horizontalAlignment','center','BackgroundColor', figureColor)
        stateS.processData.modelType  = uicontrol(hCSV,'style','popupmenu','string',{'Multi-Metric','Analytical'},'units',units,'position',[0.13 0.76 0.13 0.03],'value',1,'BackgroundColor', figureColor,'callBack','DREES(''modelTypeCall'')');
        uicontrol(hCSV,'style','text','string','Radiobiologibal Model Type','units',units,'position',[0.035 0.715 0.09 0.04],'horizontalAlignment','center','BackgroundColor', figureColor)
        stateS.processData.radbioType = uicontrol(hCSV,'style','popupmenu','string',{'TCP','NTCP'},'units',units,'position',[0.13 0.715 0.13 0.03],'value',1,'BackgroundColor', figureColor,'callback','DREES(''radbioModelTypeCall'')');
        uicontrol(hCSV,'style','text','string','Model Algorithm','units',units,'position',[0.035 0.67 0.09 0.03],'horizontalAlignment','center','BackgroundColor', figureColor)
        initAlgoOpts = {'Manual Logistic','Automated Logistic','Bagging Logistic','Manual Hazard','Automated Hazard','Principle Components','Machine Learning'};
        stateS.processData.modelAlgo  = uicontrol(hCSV,'style','popupmenu','string',initAlgoOpts,'units',units,'position',[0.13 0.67 0.13 0.03],'value',1,'BackgroundColor', figureColor);
        uicontrol(hCSV,'style','text','string','Variable List','units',units,'position',[0.035 0.62 0.09 0.03],'horizontalAlignment','center','BackgroundColor', figureColor)
        stateS.processData.exportVar  = uicontrol(hCSV,'style','pushbutton','string','Export','units',units,'position',[0.055 0.59 0.05 0.03],'horizontalAlignment','center','callBack','','BackgroundColor', figureColor,'callBack','DREES(''exportVar'')');
        stateS.processData.openList   = uicontrol(hCSV,'style','pushbutton','string','Maximize List','units',units,'position',[0.05 0.555 0.07 0.03],'horizontalAlignment','left','fontSize',7,'callBack','','BackgroundColor', figureColor,'callBack','DREES(''maximizeList'')');
        stateS.processData.listVar    = uicontrol(hCSV,'style','listbox','string',{''},'units',units,'position',[0.13 0.55 0.13 0.105],'min',1,'max',1000,'value',1,'BackgroundColor', figureColor,'callBack','DREES(''varListCall'')');
        uicontrol(hCSV,'style','text','string','DVH Level','units',units,'position',[0.035 0.505 0.07 0.03],'horizontalAlignment','center','BackgroundColor', figureColor)
        stateS.processData.dvhSelect  = uicontrol(hCSV,'style','popupmenu','string',{''},'units',units,'position',[0.11 0.51 0.08 0.03],'value',1,'BackgroundColor', figureColor,'callBack','DREES(''selectDVH'')');
        stateS.processData.dvhLevel   = uicontrol(hCSV,'style','edit','string','','units',units,'position',[0.20 0.51 0.07 0.03],'BackgroundColor', figureColor,'callBack','DREES(''selectDVHLevel'')');
        uicontrol(hCSV,'style','text','string','Event:','units',units,'position',[0.045 0.455 0.09 0.03],'horizontalAlignment','left','BackgroundColor', figureColor)
        stateS.processData.endptSign  = uicontrol(hCSV,'style','popup','string',{'>=','<='},'units',units,'position',[0.085 0.46 0.04 0.03],'BackgroundColor', figureColor);
        stateS.processData.endptSel   = uicontrol(hCSV,'style','edit','string','1','units',units,'position',[0.13 0.46 0.03 0.03],'BackgroundColor', figureColor);
        uicontrol(hCSV,'style','text','string','Data Centering','units',units,'position',[0.195 0.455 0.08 0.03],'horizontalAlignment','left','BackgroundColor', figureColor)
        stateS.processData.dataCentering   = uicontrol(hCSV,'style','checkBox','value',0,'units',units,'position',[0.175 0.46 0.02 0.03],'BackgroundColor', figureColor,'callBack','DREES(''DATACENTERCALL'')');
        uicontrol(hCSV,'style','text','string','Apply model to','units',units,'position',[0.035 0.415 0.09 0.03],'horizontalAlignment','center','BackgroundColor', figureColor)
        stateS.processData.bootSel    = uicontrol(hCSV,'style','popupmenu','string',{'Original data','Bootstrap test-set'},'units',units,'position',[0.13 0.42 0.1 0.03],'value',1,'BackgroundColor', figureColor);
        stateS.processData.applyModel = uicontrol(hCSV,'style','pushbutton','string','Go','units',units,'position',[0.24 0.415 0.03 0.035],'BackgroundColor', figureColor,'callBack','DREES(''applyModelCall'')');

        %create "model display" handles
        uicontrol(hCSV,'style','frame','units',units,'position',[0.03 0.05 0.25 0.33],'BackgroundColor', figureColor)
        uicontrol(hCSV,'style','text','string','Model','units',units,'position',[0.105 0.36 0.1 0.03],'fontWeight','bold','fontSize',10,'BackgroundColor', figureColor)
        stateS.model.sampleSiz      = uicontrol(hCSV,'style','text','string','Sample Size = ','units',units,'position',[0.04 0.33 0.1 0.03],'horizontalAlignment','left','BackgroundColor', figureColor);
        stateS.model.spearmanCorr   = uicontrol(hCSV,'style','text','string','Spearman Corr = ','units',units,'position',[0.04 0.30 0.23 0.03],'horizontalAlignment','left','BackgroundColor', figureColor);
        stateS.model.equation       = uicontrol(hCSV,'style','listbox','string',{''},'units',units,'position',[0.04 0.25 0.23 0.05],'BackgroundColor', figureColor,'callBack','DREES(''editModel'')');
        stateS.model.paramList      = uicontrol(hCSV,'style','listbox','string',{''},'units',units,'position',[0.04 0.11 0.23 0.13],'BackgroundColor', figureColor);
        stateS.model.export         = uicontrol(hCSV,'style','pushbutton','string','Export','units',units,'position',[0.07 0.06 0.05 0.03],'BackgroundColor', figureColor,'callBack','DREES(''exportModel'')');
        stateS.model.clear          = uicontrol(hCSV,'style','pushbutton','string','Clear','units',units,'position',[0.17 0.06 0.05 0.03],'BackgroundColor', figureColor,'callBack','DREES(''CLEARMODEL'')');

        %create exploratory and prediction axes
        uicontrol(hCSV,'style','text','string','Exploratory Data Analysis >>','units',units,'position',[0.35 0.92 0.2 0.04],'fontWeight','bold','fontSize',10,'BackgroundColor', figureColor,'horizontalAlignment','left')
        uicontrol(hCSV,'style','text','string','Prediction Data Analysis >>','units',units,'position',[0.35 0.45 0.2 0.04],'fontWeight','bold','fontSize',10,'BackgroundColor', figureColor,'horizontalAlignment','left')
        explorStr = {'Self Correlation','Matrix Plot','Scatter Plot','Box Plot','Principle Component Anlaysis','Actuarial Survival Analysis','Optimal Cutoff','Image Grand Tour','Support vector Machine', 'Open data in Weka'};
        predStr   = {'Cumulative Histogram','Bootstrap Plot','Contour Plot','Octile Plot','ROC Plot','Nomogram','PRCP Curve'};
        stateS.explore.options  = uicontrol(hCSV,'style','popupmenu','string',explorStr,'units',units,'position',[0.55 0.92 0.25 0.04],'fontWeight','bold','fontSize',10,'BackgroundColor', figureColor,'callBack','DREES(''exploreCall'')');
        stateS.predict.options  = uicontrol(hCSV,'style','popupmenu','string',predStr,'units',units,'position',[0.55 0.45 0.25 0.04],'fontWeight','bold','fontSize',10,'BackgroundColor', figureColor,'callBack','DREES(''predictCall'')');
        stateS.explore.axis     = axes('units',units,'position',[0.45 0.6 0.4 0.3],'Color', figureColor,'parent',hCSV,'visible','off');
        stateS.predict.CumHist  = axes('units',units,'position',[0.45 0.12 0.4 0.3],'Color', 'none','parent',hCSV,'visible','off','yAxisLocation','right');
        stateS.predict.axis     = axes('units',units,'position',[0.45 0.12 0.4 0.3],'Color', figureColor,'parent',hCSV,'visible','off');
              
        %create pushbuttons to open axes in new figure
        stateS.explore.newFig   = uicontrol(hCSV,'style','pushbutton','String','Open in new fig','units',units,'position',[0.83 0.92 0.1 0.04],'fontWeight','normal','fontSize',8,'BackgroundColor', figureColor,'callBack','DREES(''openNewFig'',''explore'')');
        stateS.predict.newFig   = uicontrol(hCSV,'style','pushbutton','String','Open in new fig','units',units,'position',[0.83 0.45 0.1 0.04],'fontWeight','normal','fontSize',8,'BackgroundColor', figureColor,'callBack','DREES(''openNewFig'',''predict'')');
        %store miscellaneous handles like colorbar, legend etc.
        stateS.explore.miscHandles = [];
        stateS.predict.miscHandles = [];

        %initialize isVarSelected flag to "not selected"
        stateS.isVarSelected = 0;

        %initialize statC
        statC = cell(1,3);
        indexS.originalData = 1;
        indexS.dreesData    = 2;
        statC{end}          = indexS;

    case 'READDATAFILE'
        
        %obtain the file format to read
        readFileType = get(stateS.readData.fileType,'value');
        if readFileType==1
            fileType = '*.mat';
            [FileName,PathName] = uigetfile(fileType,'Enter Clinical Data');
            if isnumeric(FileName) & FileName==0
                return;
            end
            load(fullfile(PathName, FileName));
            % change dBase to ddbs
            if exist('dBase')==1 & exist('ddbs')~=1
                statC{indexS.originalData} = dBase;
                clear dBase
            else
                statC{indexS.originalData} = ddbs;
                clear ddbs
            end
        elseif readFileType==2
            fileType = '*.xls';
            [FileName,PathName] = uigetfile(fileType,'Enter Clinical Data');
            if isnumeric(FileName) & FileName==0
                return;
            end
            statC{indexS.originalData} = xlsToDDBS(fullfile(PathName, FileName));
        end

        %create DREES data structure out of original data
        stateS.outcome_index = [];
        statC{indexS.dreesData} = createDREESdata(statC{indexS.originalData});

        if get(stateS.processData.modelType,'value') == 1 %multi-metric
            set(stateS.processData.listVar, 'string', statC{indexS.dreesData}.fieldnames, 'max',statC{indexS.dreesData}.n,'min',1,'value',1);
        elseif get(stateS.processData.modelType,'value') == 2 %analytical
            %% check for DVH selection
            [data, selectedfield] = get_field_data(statC{indexS.dreesData},'dvh_');
            set(stateS.processData.listVar, 'string', selectedfield, 'max',1,'min',1,'value',1);
        end
        
    case 'SAVEFILE'
        ddbs = statC{indexS.originalData};
        [fname, pname] = uiputfile({'*.mat;', 'DREES Plans (*.mat)';'*.*', 'All Files (*.*)'},['Save data as:']);
        saveFile = fullfile(pname,fname);
        save(saveFile, 'ddbs');

    case 'MODELTYPECALL'

        modelTypes = get(stateS.processData.modelType,'string');
        switch upper(modelTypes{get(stateS.processData.modelType,'value')})
            case 'MULTI-METRIC'
                if ~isempty(statC{indexS.dreesData}) && isfield(statC{indexS.dreesData},'fieldnames')
                    set(stateS.processData.listVar, 'string', statC{indexS.dreesData}.fieldnames, 'max',statC{indexS.dreesData}.n,'min',1,'value',1);
                end
                set([stateS.processData.dvhSelect stateS.processData.dvhLevel],'enable','on','string',{''})
                set(stateS.processData.bootSel,'enable','on')
                fields = fieldnames(statC{indexS.dreesData}.params);
                for i=1:length(fields)
                    statC{indexS.dreesData}.params.(fields{i}) = [];
                end
                algoOpts = {'Manual Logistic','Automated Logistic','Bagging Logistic','Manual Hazard','Automated Hazard','Principle Components','Machine Learning'};
                set(stateS.processData.modelAlgo,'string',algoOpts,'value',1)
            case 'ANALYTICAL'
                if ~isempty(statC{indexS.dreesData}) && isfield(statC{indexS.dreesData},'fieldnames')
                    [data, selectedfield]=get_field_data(statC{indexS.dreesData},'dvh_');
                    set(stateS.processData.listVar, 'string', selectedfield, 'max',1,'min',1,'value',1);
                end
                set([stateS.processData.dvhSelect stateS.processData.dvhLevel],'enable','off','string',{''})
                set(stateS.processData.bootSel,'value',1,'enable','off')
                fields = fieldnames(statC{indexS.dreesData}.params);
                for i=1:length(fields)
                    statC{indexS.dreesData}.params.(fields{i}) = [];
                end
                radbioModelTypes = get(stateS.processData.radbioType,'string');
                switch upper(radbioModelTypes{get(stateS.processData.radbioType,'value')})
                    case 'TCP'
                        set(stateS.processData.modelAlgo, 'string', {'Poisson','Linear-Quadratic'},'value',1);
                    case 'NTCP'
                        set(stateS.processData.modelAlgo, 'string', {'Lyman-Kutcher-Burman','Critical Volume'},'value',1);
                end
        end

    case 'RADBIOMODELTYPECALL'
        radbioModelTypes = get(stateS.processData.radbioType,'string');
        switch upper(radbioModelTypes{get(stateS.processData.radbioType,'value')})
            case 'TCP'
                set(stateS.processData.endptSel, 'string', '1');
                modelTypes = get(stateS.processData.modelType,'string');
                switch upper(modelTypes{get(stateS.processData.modelType,'value')})
                    case 'ANALYTICAL'
                        set(stateS.processData.modelAlgo, 'string', {'Poisson','Linear-Quadratic'});
                end

            case 'NTCP'
                set(stateS.processData.endptSel, 'string', '2');
                modelTypes = get(stateS.processData.modelType,'string');
                switch upper(modelTypes{get(stateS.processData.modelType,'value')})
                    case 'ANALYTICAL'
                        set(stateS.processData.modelAlgo, 'string', {'Lyman-Kutcher-Burman','Critical Volume'});
                end

        end

    case 'VARLISTCALL'
        if isfield(stateS,'isVarSelected') && stateS.isVarSelected==1
            buttonName = questdlg('You are about to slect new variables and will lose the currently selected variables and model. Continue?','Warning!','Yes','No','No');
            switch upper(buttonName)
                case 'YES'
                    %clear current model if variables change
                    DREES('CLEARMODEL')
                    %handles.isVarSelected = 0;
                    stateS.isVarSelected = 0;
                case 'NO'
                    return
            end
        end

        allFields   =   get(stateS.processData.listVar,'Value');
        fieldNames  =   get(stateS.processData.listVar, 'String');
        selectedFieldNames = {fieldNames{allFields}};
        set(stateS.processData.dvhSelect, 'enable', 'off', 'String', {'DVH Selection'}, 'Value', 1);
        set(stateS.processData.dvhLevel, 'enable', 'off');
        %clear bootstrap data
        if isfield(statC{indexS.dreesData},'addset')
            statC{indexS.dreesData} = rmfield(statC{indexS.dreesData},'addset');
        end
        DxString = {};
        DcString = {};
        mDXUString = {};
        mDCUString = {};
        mDXLString = {};
        VxString = {};
        VuString = {};
        GeudString= {};
        for i=1:length(selectedFieldNames)
            if findstr(selectedFieldNames{i}, 'Dx_')
                set(stateS.processData.dvhSelect, 'enable', 'on');
                set(stateS.processData.dvhLevel, 'enable', 'on');
                DxString = {DxString{:} selectedFieldNames{i}};
            end
            if findstr(selectedFieldNames{i}, 'Dc_')
                set(stateS.processData.dvhSelect, 'enable', 'on');
                set(stateS.processData.dvhLevel, 'enable', 'on');
                DcString = {DcString{:} selectedFieldNames{i}};
                %Get the field containing Tx Fraction
                if ~isfield(stateS,'TxFractionField')
                    fNames = fieldnames(statC{indexS.originalData});
                    indDVH = strmatch('dvh_',fNames);
                    fNames(indDVH) = [];
                    [sel,ok] = listdlg('PromptString','Select field containing Tx Fractions.','SelectionMode','single','ListString',fNames);
                    if ok
                        stateS.TxFractionField = fNames{sel};
                    end
                end
            end
            if findstr(selectedFieldNames{i}, 'MOHx_')
                set(stateS.processData.dvhSelect, 'enable', 'on');
                set(stateS.processData.dvhLevel, 'enable', 'on');
                mDXUString = {mDXUString{:} selectedFieldNames{i}};
            end
            if findstr(selectedFieldNames{i}, 'MOHc_')
                set(stateS.processData.dvhSelect, 'enable', 'on');
                set(stateS.processData.dvhLevel, 'enable', 'on');
                mDCUString = {mDCUString{:} selectedFieldNames{i}};
                %Get the field containing Tx Fraction
                if ~isfield(stateS,'TxFractionField')
                    fNames = fieldnames(statC{indexS.originalData});
                    indDVH = strmatch('dvh_',fNames);
                    fNames(indDVH) = [];
                    [sel,ok] = listdlg('PromptString','Select field containing Tx Fractions.','SelectionMode','single','ListString',fNames);
                    if ok
                        stateS.TxFractionField = fNames{sel};
                    end
                end                
            end            
            if findstr(selectedFieldNames{i}, 'MOCx_')
                set(stateS.processData.dvhSelect, 'enable', 'on');
                set(stateS.processData.dvhLevel, 'enable', 'on');
                mDXLString = {mDXLString{:} selectedFieldNames{i}};
            end
            if findstr(selectedFieldNames{i}, 'Vx_')
                set(stateS.processData.dvhSelect, 'enable', 'on');
                set(stateS.processData.dvhLevel, 'enable', 'on');
                VxString = {VxString{:} selectedFieldNames{i}};
            end
            if findstr(selectedFieldNames{i}, 'Vu_')
                set(stateS.processData.dvhSelect, 'enable', 'on');
                set(stateS.processData.dvhLevel, 'enable', 'on');
                VuString = {VuString{:} selectedFieldNames{i}};
            end
            if findstr(selectedFieldNames{i}, 'GEUD_')
                set(stateS.processData.dvhSelect, 'enable', 'on');
                set(stateS.processData.dvhLevel, 'enable', 'on');
                GeudString = {GeudString{:} selectedFieldNames{i}};
            end
        end
        if ~isempty({DxString{:},DcString{:},mDXUString{:},mDCUString{:},mDXLString{:},VxString{:},VuString{:},GeudString{:}})
            set(stateS.processData.dvhSelect, 'String', {DxString{:},DcString{:},mDXUString{:},mDCUString{:},mDXLString{:},VxString{:},VuString{:},GeudString{:}});
            metricNum = get(stateS.processData.dvhSelect, 'Value');
            metricStrings = get(stateS.processData.dvhSelect, 'String');
            set(stateS.processData.dvhLevel, 'String', statC{indexS.dreesData}.params.(metricStrings{metricNum}));
        end

    case 'SELECTDVHLEVEL'
        metricNum = get(stateS.processData.dvhSelect, 'Value');
        metricStrings = get(stateS.processData.dvhSelect, 'String');
        statC{indexS.dreesData}.params.(metricStrings{metricNum}) = get(stateS.processData.dvhLevel, 'String');
        if isfield(stateS,'isVarSelected') && stateS.isVarSelected==1
            DREES('CLEARMODEL')
            DREES('applyModelCall')
        end
        
    case 'SELECTDVH'
        metricNum = get(stateS.processData.dvhSelect, 'Value');
        metricStrings = get(stateS.processData.dvhSelect, 'String');
        set(stateS.processData.dvhLevel, 'String', statC{indexS.dreesData}.params.(metricStrings{metricNum}));

    case 'APPLYMODELCALL'
        allModels = get(stateS.processData.modelType,'String');
        switch upper(allModels{get(stateS.processData.modelType,'Value')})
            
            case 'MULTI-METRIC'
                
                delete(stateS.predict.miscHandles)
                cla(stateS.predict.axis);
                reset(stateS.predict.axis);
                axes(stateS.predict.axis);
                cla(stateS.predict.CumHist);
                reset(stateS.predict.CumHist);
                axes(stateS.predict.CumHist);
                set(stateS.predict.axis,'visible','off')
                set(stateS.predict.CumHist,'visible','off')
                cla([stateS.explore.axis stateS.predict.axis])
                reset(stateS.explore.axis)
                reset(stateS.predict.axis)
                
                inputData = createDREESdata(statC{indexS.originalData});
                inputData.params = statC{indexS.dreesData}.params;
                [outcome, dataX, SelectedVariableNames, isVarValid, validObs] = get_variable_list(inputData);
                %[outcome, dataX, SelectedVariableNames, isVarValid] = get_variable_list(statC{indexS.dreesData});
                if ~isVarValid
                    return;
                end
                % original set
                statC{indexS.dreesData}.outcome=outcome;
                statC{indexS.dreesData}.dataX=dataX;
                statC{indexS.dreesData}.SelectedVariableNames=SelectedVariableNames;
                statC{indexS.dreesData}.validObs = validObs;
                statC{indexS.dreesData}.AllVariableNames = SelectedVariableNames;
                statC{indexS.dreesData}.data_model_param=[];
                statC{indexS.dreesData}.mu=[];
                statC{indexS.dreesData}.b=[];
                % check the data set for bootstraping
                if get(stateS.processData.bootSel,'value')==2 % bootstrap test set
                    index=drxlr_pseudo_sample(length(outcome),1,length(outcome));
                    outcome=outcome(index);  %  selected test set
                    dataX=dataX(index,:);
                end
                % apply grade cutoff
                grade_cutoff = str2num(get(stateS.processData.endptSel,'String'));
                greater_than_flag_val = get(stateS.processData.endptSign,'value');
                if (sum(outcome(:)>=grade_cutoff)==0 && greater_than_flag_val==1) || (sum(outcome(:)<=grade_cutoff)==0 && greater_than_flag_val==2) % grade cutoff larger than any value?
                    button = questdlg('Grade cut off is larger than any outcome! Do you want to proceed?', 'Apply Model','YES','NO','NO');
                    if strcmp(button,'NO')
                        return;
                    end
                end
                % apply the selected algorithm
                allAlgos = get(stateS.processData.modelAlgo,'String');
                switch upper(allAlgos{get(stateS.processData.modelAlgo,'Value')})
                    case 'MANUAL LOGISTIC'
                        if greater_than_flag_val==1
                            y = outcome(:)>=grade_cutoff;
                        else
                            y = outcome(:)<=grade_cutoff;
                        end
                        [statC{indexS.dreesData}.mu, statC{indexS.dreesData}.b, pval] = drxlr_apply_logistic_regression(dataX,y);
                        %statC{indexS.dreesData}.isVarSelected = 1;
                        stateS.isVarSelected = 1;
                        statC = displayMMModel(statC,pval);
                        % plot self-correlations and cumulative histogram
                        plotSelfCorrelation(stateS.explore.axis,statC{indexS.dreesData}); % use original set
                        allRadBioModels = get(stateS.processData.radbioType,'String');
                        plot_cum_hist(stateS.predict.axis,dataX,outcome,statC{indexS.dreesData}.mu,1,statC{indexS.dreesData}.b,allRadBioModels{get(stateS.processData.radbioType,'Value')});
                        [rs, pm] = spearman(statC{indexS.dreesData}.mu,outcome);
                        rstext = ['Spearman Corr = ',num2str(rs,'%0.3g'), ' (p=',num2str(pm,'%0.3g'),')'];
                        set(stateS.model.spearmanCorr,'String',rstext);

                    case 'AUTOMATED LOGISTIC'
                        if greater_than_flag_val==1
                            y = outcome(:)>=grade_cutoff;
                        else
                            y = outcome(:)<=grade_cutoff;
                        end
                        lX=size(dataX,2);
                        ly=length(y);
                        button = questdlg({['You have selected ',num2str(ly),' with ',num2str(lX),' variables'],...
                            'Do you want to proceed?'}, 'Automated Logistic Regression','NO','YES','YES');
                        if strcmp(button,'NO')
                            return;
                        end

                        prompt={'Enter model order selection method (1: LOO-CV, 2: Bootstrap, 3:M-Fold CV, 4: AIC-CV, 5: BIC-CV, 6: AIC-Boot, 7: AICS-Boot, 8: BIC-Boot)','Enter minimum model order:','Enter maximum model order:',...
                            'Enter number of bootstrap samples for model order selection:','Enter Number of Folds (M):','Enter number of bootstrap samples for parameters estimation:',...
                            'Enter Statistica test 1:Wald, 2:Likelihood ratio test, 3: joint test)','Enter max. iterations of logistic regression:', 'Enter convergence tolerance of logistic regression:',...
                            'Enter test regularization'};
                        def={'1','1',num2str(min(10,lX)),num2str(10*ly), num2str(10), num2str(5*ly),num2str(1),num2str(300),num2str(1e-6), num2str(0.5)};
                        dlgTitle=['Automatic logistic regression parameters'];
                        answer=inputdlg(prompt,dlgTitle,1,def);
                        if isempty(answer)
                            return;
                        end
                        order_sel_method = str2num(answer{1});
                        min_order        = str2num(answer{2});
                        max_order        = str2num(answer{3});
                        nboot_order      = str2num(answer{4});
                        mfolds_cv        = str2num(answer{5});
                        nboot_param      = str2num(answer{6});
                        stat_tests = {'Wald', 'LRT','Wald_LRT'};
                        test_method      = stat_tests{str2num(answer{7})};
                        logiter_param    = str2num(answer{8});
                        logtol_param     = str2num(answer{9});
                        lambda           = str2num(answer{10});
                        %%%% QUESTION!!!
                        [statC{indexS.dreesData}.SelectedVariableNames, statC{indexS.dreesData}.dataX, statC{indexS.dreesData}.addset] = apply_auto_logistic_regression(dataX,y,outcome,SelectedVariableNames,order_sel_method,min_order,max_order,nboot_order,mfolds_cv, nboot_param, test_method, logiter_param,logtol_param, lambda);
                        statC{indexS.dreesData}.AllVariableNames = SelectedVariableNames;
                        [statC{indexS.dreesData}.mu, statC{indexS.dreesData}.b, pval] = drxlr_apply_logistic_regression(statC{indexS.dreesData}.dataX,y,logiter_param,logtol_param);
                        %statC{indexS.dreesData}.isVarSelected = 1;
                        stateS.isVarSelected = 1;
                        statC = displayMMModel(statC,pval);
                        % plot self-correlations and cumulative histogram
                        plotSelfCorrelation(stateS.explore.axis,statC{indexS.dreesData}); % use original set
                        allRadBioModels = get(stateS.processData.radbioType,'String');
                        plot_cum_hist(stateS.predict.axis,statC{indexS.dreesData}.dataX,outcome,statC{indexS.dreesData}.mu,1,statC{indexS.dreesData}.b,allRadBioModels{get(stateS.processData.radbioType,'Value')});
                        [rs, pm] = spearman(statC{indexS.dreesData}.mu,statC{indexS.dreesData}.outcome);
                        rstext = ['Spearman Corr = ',num2str(rs,'%0.3g'), ' (p=',num2str(pm,'%0.3g'),')'];
                        set(stateS.model.spearmanCorr,'String',rstext);

                    case 'BAGGING LOGISTIC'

                        if greater_than_flag_val==1
                            y = outcome(:)>=grade_cutoff;
                        else
                            y = outcome(:)<=grade_cutoff;
                        end
                        lX = size(dataX,2);
                        ly = length(y);
                        numTopModels = 10;
                        weighting_criteria = 2;  % weighting criteria: 1: uniform, 2: by frequency
                        model_order = 3;
                        prompt={'Enter models order:', 'Enter number of top models:','Enter number of bootstraps',...
                            'Enter Statistica test 1:Wald, 2:Likelihood ratio test, 3: joint test)','Enter max. iterations of logistic regression:', 'Enter convergence tolerance of logistic regression:',...
                            'Enter test regularization'};
                        def = {num2str(model_order),num2str(numTopModels),...
                            num2str(5*ly),num2str(1),num2str(300),num2str(1e-6), num2str(0.5)};
                        dlgTitle = ['Bagging Logistic'];
                        answer = inputdlg(prompt,dlgTitle,1,def);
                        model_order = str2num(answer{1});
                        numTopModels = str2num(answer{2});
                        nboot = str2num(answer{3});
                        stat_tests = {'Wald', 'LRT','Wald_LRT'};
                        test_method = stat_tests{str2num(answer{4})};
                        logiter_param = str2num(answer{5});
                        logtol_param = str2num(answer{6});
                        lambda = str2num(answer{7});
                        statC{indexS.dreesData}.mu = drxlr_gui_get_bagging_model(dataX,y,outcome,model_order,nboot,numTopModels,SelectedVariableNames, test_method, logiter_param,logtol_param, lambda);
                        %                         set(handles.ModelText,'String','Bagging Model','fontsize',12,'fontweight','normal')
                        %                         handles.data_model_param{1}='Parameter      Value';
                        %                         handles.data_model_param{2}='-----------------------------------';
                        %                         handles.data_model_param{3}=['Model order','  ',num2str(model_order)];
                        [data, selectedfield]=get_field_data(statC{indexS.dreesData},'dvh_');
                        if length(selectedfield)>1
                            [index,dummy] = listdlg('PromptString','Select a dvh for calculating mean dose:',...
                                'SelectionMode','single',...
                                'ListString',selectedfield);
                            if dummy==0
                                return;
                            end
                        else
                            index=1;
                        end
                        dvh=data{index};
                        for i = 1:length(dvh)
                            mean_dose(i)=calc_meanDose(dvh{i}(1,:), dvh{i}(2,:)); % select mdose as the X-variable
                        end
                        statC{indexS.dreesData}.dataX=mean_dose(:);
                        %statC{indexS.dreesData}.SelectedVariableNames = {'Mean dose','Bagging Model'};
                        statC{indexS.dreesData}.SelectedVariableNames = {'Mean dose'};

                    case 'MANUAL HAZARD'

                        if greater_than_flag_val==1
                            y = outcome(:)>=grade_cutoff;
                        else
                            y = outcome(:)<=grade_cutoff;
                        end
                        prompt={'Enter Time-axis variable','Model (Cox, Breslow, Efron)','Normalization Method (mean, median or none)','Enter Maximum iterations for N-R','Enter tolerance for N-R'};
                        %obtain the name of time-variable
                        timeIndex = strmatch('Time',statC{indexS.dreesData}.fieldnames);
                        if isempty(timeIndex)
                            timeStr = 'TimeAxis';
                        else
                            timeStr = statC{indexS.dreesData}.fieldnames{timeIndex(1)};
                        end
                        def={timeStr,'Breslow','median','100','1e-6'};
                        dlgTitle=['Select Model Data'];
                        answer=inputdlg(prompt,dlgTitle,1,def);
                        survivalTime = statC{indexS.dreesData}.(answer{1});
                        % no standardization. mean, median
                        % ties : no, Breslow, Efron

                        %obtain model from user
                        if strcmpi(answer{2},'Cox')
                            fun = 'cox_no_ties';
                        elseif strcmpi(answer{2},'Breslow')
                            fun = 'breslow';
                        elseif strcmpi(answer{2},'Efron')
                            fun = 'efron';
                        else
                            errordlg('Unknown Model type.')
                            return
                        end

                        statC{indexS.dreesData}.dataX = dataX;

                        %condition data
                        if strcmpi(answer{3},'median')
                            dataX = dataX - repmat(median(dataX),size(dataX,1),1); % centered covariates
                        elseif strcmpi(answer{3},'mean')
                            dataX = dataX - repmat(mean(dataX),size(dataX,1),1); % centered covariates
                        elseif isempty(answer{3}) | strcmpi(answer{2},'mean')
                            % do nothing
                        else
                            errordlg('Unknown Normalization method.')
                            return
                        end

                        % order data by time
                        [survivalTime,ind] = sort(survivalTime); % should be in ascending order
                        %y = ~y(ind);
                        y = y(ind);
                        y = y(:);
                        dataX = dataX(ind,:);

                        %solve for model coefficients : b
                        [bMax,LL,g,H] = fmin_NR(fun,zeros([size(dataX,2) 1]),str2num(answer{4}),str2num(answer{5}),survivalTime',dataX,y);
                        %%%fmincon check
                        %bMax = fmincon(fun,zeros([size(dataX,2) 1]),[],[],[],[],-5,5,[],[],survivalTime',dataX,y)

                        statC{indexS.dreesData}.b = bMax;

                        %compure statistics
                        stats = drxlr_getHazardStats(bMax,LL,H);

                        [S0, t_uniq, jnk, t_all] = drxlr_getSurvivalFun(bMax,survivalTime',dataX,y);
                        statC{indexS.dreesData}.mu = S0(t_all);
                        statC{indexS.dreesData}.S0 = S0;
                        statC{indexS.dreesData}.t_uniq = t_uniq;

                        plotSelfCorrelation(stateS.explore.axis,statC{indexS.dreesData}); % use original set
                        plot_survivalCurve(stateS.predict.axis,statC{indexS.dreesData});

                        pval = stats.p;

                        statC = displaySurvModel(statC,pval);


                    case 'AUTOMATED HAZARD'

                        if greater_than_flag_val==1
                            y = outcome(:)>=grade_cutoff;
                        else
                            y = outcome(:)<=grade_cutoff;
                        end
                        lX=size(dataX,2);
                        ly=length(y);
                        button = questdlg({['You have selected ',num2str(ly),' with ',num2str(lX),' variables'],...
                            'Do you want to proceed?'}, 'Automated Hazard Regression','NO','YES','YES');
                        if strcmp(button,'NO')
                            return;
                        end

                        %obtain the name of time-variable
                        timeIndex = strmatch('Time',statC{indexS.dreesData}.fieldnames);
                        if isempty(timeIndex)
                            timeStr = 'TimeAxis';
                        else
                            timeStr = statC{indexS.dreesData}.fieldnames{timeIndex(1)};
                        end

                        prompt={'Enter minimum model order:','Enter maximum model order:',...
                            'Enter number of bootstrap samples for model order selection:','Enter Number of Folds (M):','Enter number of bootstrap samples for parameters estimation:',...
                            'Enter Statistica test 1:Wald, 2:Likelihood ratio test, 3: joint test)','Enter max. N-R iterations of Hazard Modeling:', 'Enter convergence tolerance for N-R:',...
                            'Enter test regularization', 'time Axis'};
                        def={'1',num2str(min(10,lX)),num2str(10*ly), num2str(10), num2str(5*ly),num2str(1),num2str(300),num2str(1e-6), num2str(0.5), timeStr};

                        dlgTitle=['Automatic hazard regression parameters'];
                        answer=inputdlg(prompt,dlgTitle,1,def);
                        min_order=str2num(answer{1});
                        max_order=str2num(answer{2});
                        nboot_order=str2num(answer{3});
                        mfolds_cv=str2num(answer{4});
                        nboot_param=str2num(answer{5});
                        stat_tests = {'Wald', 'LRT','Wald_LRT'};
                        test_method = stat_tests{str2num(answer{6})};
                        coxiter_param=str2num(answer{7});
                        coxtol_param=str2num(answer{8});
                        lambda=str2num(answer{9});
                        survivalTime = statC{indexS.dreesData}.(answer{10});

                        %%%% QUESTION!!!
                        [SelectedVariableNames, dataX]=apply_auto_hazard_regression(survivalTime,dataX,y,outcome,SelectedVariableNames,min_order,max_order,nboot_order,nboot_param, test_method, coxiter_param,coxtol_param, lambda,1,[]);
                        Z0 = dataX - repmat(median(dataX),[size(dataX,1) 1]);
                        [statC{indexS.dreesData}.b, stats_f]=drxlr_apply_coxphreg(survivalTime, y, dataX, zeros(size(dataX,2),1), Z0, 100,1e-5);
                        pval = stats_f.p;

                        [S0, t_uniq, jnk, t_all] = drxlr_getSurvivalFun(statC{indexS.dreesData}.b,survivalTime',dataX,y);
                        statC{indexS.dreesData}.mu = S0(t_all);
                        statC{indexS.dreesData}.S0 = S0;
                        statC{indexS.dreesData}.t_uniq = t_uniq;

                        plotSelfCorrelation(stateS.explore.axis,statC{indexS.dreesData}); % use original set
                        plot_survivalCurve(stateS.predict.axis,statC{indexS.dreesData});

                        statC = displaySurvModel(statC,pval,SelectedVariableNames);

                end

            case 'ANALYTICAL'
                
                delete(stateS.predict.miscHandles)
                cla(stateS.predict.axis);
                reset(stateS.predict.axis);
                axes(stateS.predict.axis);
                cla(stateS.predict.CumHist);
                reset(stateS.predict.CumHist);
                axes(stateS.predict.CumHist);
                set(stateS.predict.axis,'visible','off')
                set(stateS.predict.CumHist,'visible','off')
                cla([stateS.explore.axis stateS.predict.axis])
                reset(stateS.explore.axis)
                reset(stateS.predict.axis)
                
                % apply the selected algorithm
                allAlgos = get(stateS.processData.modelAlgo,'String');
                inputData = createDREESdata(statC{indexS.originalData});
                inputData.params = statC{indexS.dreesData}.params;
                [outcome, dataX, SelectedVariableNames, isVarValid, validObs] = get_variable_list(inputData);
                %[outcome, dataX, SelectedVariableNames, isVarValid] = get_variable_list(statC{indexS.dreesData});
                if ~isVarValid
                    return;
                end
                %reset axes
                cla([stateS.explore.axis stateS.predict.axis])
                reset(stateS.explore.axis)
                reset(stateS.predict.axis)
                % original set
                statC{indexS.dreesData}.outcome=outcome;
                statC{indexS.dreesData}.dataX=dataX;
                statC{indexS.dreesData}.SelectedVariableNames=SelectedVariableNames;
                statC{indexS.dreesData}.validObs = validObs;
                statC{indexS.dreesData}.AllVariableNames = SelectedVariableNames;
                statC{indexS.dreesData}.data_model_param=[];
                statC{indexS.dreesData}.mu=[];
                statC{indexS.dreesData}.b=[];                
                switch upper(allAlgos{get(stateS.processData.modelAlgo,'Value')})
                    case 'LYMAN-KUTCHER-BURMAN'
                        [statC{indexS.dreesData}.mu,statC{indexS.dreesData}.ParamVar,ParamList,statC{indexS.dreesData}.SelectedVariableNames,statC{indexS.dreesData}.dataX,indEmpty]=ntcp_analytical_models(statC{indexS.dreesData},'LKB');
                        set(stateS.model.equation,'String',{'Lyman-Kutcher-Burman NTCP model (geud)'},'fontsize',10,'fontweight','normal')
                        %statC{indexS.dreesData}.ParamList{1} = 'a';
                        %statC{indexS.dreesData}.ParamList{2} = 'm';
                        
                    case 'CRITICAL VOLUME'
                        [statC{indexS.dreesData}.mu,statC{indexS.dreesData}.ParamVar,ParamList,statC{indexS.dreesData}.SelectedVariableNames,statC{indexS.dreesData}.dataX,indEmpty]=ntcp_analytical_models(statC{indexS.dreesData},'CV');
                        set(stateS.model.equation,'String',{'Critical Volume NTCP model (%damage)'},'fontsize',10,'fontweight','normal')
                        %statC{indexS.dreesData}.ParamList{1} = 'mu_cr';
                        %statC{indexS.dreesData}.ParamList{2} = 'sigma';
                        %statC{indexS.dreesData}.ParamList{3} = 'D50';
                        %statC{indexS.dreesData}.ParamList{4} = 'gamma50';                        
                    case 'POISSON'
                        [statC{indexS.dreesData}.mu,statC{indexS.dreesData}.ParamVar,ParamList,statC{indexS.dreesData}.SelectedVariableNames,statC{indexS.dreesData}.dataX,indEmpty]=tcp_analytical_models(statC{indexS.dreesData},'POISSON');
                        set(stateS.model.equation,'String','Poisson TCP model (mean dose)','fontsize',10)
                        %statC{indexS.dreesData}.ParamList{1} = 'D50';
                        %statC{indexS.dreesData}.ParamList{2} = 'gamma50';
                    case 'LINEAR-QUADRATIC'
                        [statC{indexS.dreesData}.mu,statC{indexS.dreesData}.ParamVar,ParamList,statC{indexS.dreesData}.SelectedVariableNames,statC{indexS.dreesData}.dataX,indEmpty]=tcp_analytical_models(statC{indexS.dreesData},'LQ');
                        set(stateS.model.equation,'String','Linear-quadratic TCP model (mean dose)','fontsize',10)
                        %statC{indexS.dreesData}.ParamList{1} = '# cells';
                        %statC{indexS.dreesData}.ParamList{2} = 'alpha';
                        %statC{indexS.dreesData}.ParamList{3} = 'beta';
                        %statC{indexS.dreesData}.ParamList{4} = 'doubl-days';                        
                end
                statC{indexS.dreesData}.ParamList = ParamList;
                outcome = statC{indexS.dreesData}.outcome;
                grade_cutoff = str2num(get(stateS.processData.endptSel,'String'));
                greater_than_flag_val = get(stateS.processData.endptSign,'value');                
                if greater_than_flag_val == 1
                    outcome = outcome >= grade_cutoff;
                else
                    outcome = outcome <= grade_cutoff;
                end                
                outcome(indEmpty) = [];
                statC{indexS.dreesData}.outcome = outcome;
                statC{indexS.dreesData}.b=[];
                [rs, pm] = spearman(statC{indexS.dreesData}.mu,outcome);
                rstext = ['Spearman Corr = ',num2str(rs,'%0.3g'), ' (p=',num2str(pm,'%0.3g'),')'];
                set(stateS.model.spearmanCorr,'String',rstext);
                set(stateS.model.sampleSiz,'String',['Sample Size = ',num2str(length(outcome))]);
                statC = displayAnalyticalModel(statC);
                plotSelfCorrelation(stateS.explore.axis,statC{indexS.dreesData}); % use original set
                allRadBioModels = get(stateS.processData.radbioType,'String');
                plot_cum_hist(stateS.predict.axis,statC{indexS.dreesData}.dataX,outcome,statC{indexS.dreesData}.mu,2,statC{indexS.dreesData}.b,allRadBioModels{get(stateS.processData.radbioType,'Value')});

        end
        %Reset the popupmenu values
        set(stateS.explore.options,'value',1)
        set(stateS.predict.options,'value',1)

    case 'EXPLORECALL'
        allExploreOpts = get(stateS.explore.options,'String');
        
        %populate selected variables in statC if not present
        inputData = createDREESdata(statC{indexS.originalData});       
        inputData.params = statC{indexS.dreesData}.params;
        [outcome, dataX, SelectedVariableNames, isVarValid, validObs] = get_variable_list(inputData);
        %[outcome, dataX, SelectedVariableNames, isVarValid] = get_variable_list(statC{indexS.dreesData});
        if ~isVarValid
            return;
        else
            % original set
            statC{indexS.dreesData}.outcome=outcome;
            statC{indexS.dreesData}.dataX=dataX;
            statC{indexS.dreesData}.SelectedVariableNames=SelectedVariableNames;
            statC{indexS.dreesData}.validObs=validObs;
            stateS.isVarSelected = 1;
        end
        
%         [dreesData,isVarValid] = populateData(inputData);
%         if ~isVarValid            
%             return;
%         else
%             %set isVarSelected flag to 1 (1: selected, 0: not yet selected)
%             statC{indexS.dreesData} = dreesData;
%             %statC{indexS.dreesData}.isVarSelected = 1;
%             stateS.isVarSelected = 1;
%         end

        switch upper(allExploreOpts{get(stateS.explore.options,'value')})
            case 'MATRIX PLOT'
                matrixPlot('init')
            case 'SELF CORRELATION'
                plotSelfCorrelation(stateS.explore.axis,statC{indexS.dreesData});
            case 'SCATTER PLOT'
                scatterPlot(stateS.explore.axis,statC{indexS.dreesData});
            case 'BOX PLOT'
                boxPlot(stateS.explore.axis,statC{indexS.dreesData});
            case 'PRINCIPLE COMPONENT ANLAYSIS'
                plotPC(stateS.explore.axis,statC{indexS.dreesData});
            case 'ACTUARIAL SURVIVAL ANALYSIS'
                actuarialPlot(stateS.explore.axis,statC{indexS.dreesData});
            case 'OPTIMAL CUTOFF'
                nomogramPlot(stateS.explore.axis,statC{indexS.dreesData});
            case 'IMAGE GRAND TOUR'
                imageGT('init',stateS.explore.axis,statC{indexS.dreesData})
            case 'SUPPORT VECTOR MACHINE'
                libSVM('init',stateS.explore.axis,statC{indexS.dreesData})
            case 'OPEN DATA IN WEKA'
                callWeka()
        end

    case 'PREDICTCALL'
        allPredictOpts = get(stateS.predict.options,'String');

        delete(stateS.predict.miscHandles)
        cla(stateS.predict.axis);
        reset(stateS.predict.axis);
        axes(stateS.predict.axis);
        cla(stateS.predict.CumHist);
        reset(stateS.predict.CumHist);
        axes(stateS.predict.CumHist);        
        stateS.predict.miscHandles = [];
        set(stateS.predict.axis,'visible','off')
        set(stateS.predict.CumHist,'visible','off')
        %get type of model (1:multimetric, 2:analytical)
        model_flag = get(stateS.processData.modelType,'value');

        switch upper(allPredictOpts{get(stateS.predict.options,'value')})
            case 'CUMULATIVE HISTOGRAM'
                dataX = statC{indexS.dreesData}.dataX;
                outcome = statC{indexS.dreesData}.outcome;
                allRadBioModels = get(stateS.processData.radbioType,'String');
                plot_cum_hist(stateS.predict.axis,dataX,outcome,statC{indexS.dreesData}.mu,model_flag,statC{indexS.dreesData}.b,allRadBioModels{get(stateS.processData.radbioType,'Value')});
            case 'BOOTSTRAP PLOT'
                statC{indexS.dreesData} = bootstrapPlot(stateS.predict.axis,statC{indexS.dreesData});
            case 'CONTOUR PLOT'
                statC{indexS.dreesData} = contourPlot(stateS.predict.axis,statC{indexS.dreesData});
            case 'OCTILE PLOT'
                greater_than_flag_val = get(stateS.processData.endptSign,'value');
                if greater_than_flag_val==1
                    y = statC{indexS.dreesData}.outcome(:) >= str2num(get(stateS.processData.endptSel,'String'));                    
                else
                    y = statC{indexS.dreesData}.outcome(:) <= str2num(get(stateS.processData.endptSel,'String'));
                end                
                mu = statC{indexS.dreesData}.mu;
                [hAxis,hError1,hError2,hPlot] = plot_predict_octile(stateS.predict.axis,y,mu);
                stateS.predict.miscHandles = [stateS.predict.miscHandles legend(hAxis,[hError1(1) hError2(1) hPlot], 'Original','Prediction model','Squared-Residual Error')];
                set(stateS.predict.axis,'visible','on')
            case 'ROC PLOT'
                statC{indexS.dreesData} = rocPlot(stateS.predict.axis,statC{indexS.dreesData});
            case 'SURVIVAL CURVE'
                plot_survivalCurve(stateS.predict.axis,statC{indexS.dreesData});
            case 'NOMOGRAM'
                plotNomogram('init')
            case 'PRCP CURVE'
                greater_than_flag_val = get(stateS.processData.endptSign,'value');
                if greater_than_flag_val==1
                    y = statC{indexS.dreesData}.outcome(:) >= str2num(get(stateS.processData.endptSel,'String'));                    
                else
                    y = statC{indexS.dreesData}.outcome(:) <= str2num(get(stateS.processData.endptSel,'String'));
                end                
                vars = statC{indexS.dreesData}.mu;
                [avgpr, pr, cr] = drxlr_plot_prcr_class(stateS.predict.axis, vars, y, 0.05);
        end

    case 'OPENNEWFIG'
        f = figure;
        axisType = varagrin;
        switch upper(axisType)
            case 'EXPLORE'
                copyobj([stateS.explore.axis],f)
            case 'PREDICT'
                copyobj([stateS.predict.axis],f)
                copyobj([stateS.predict.CumHist],f)
        end
        set(gca,'outerPosition',[0.01 0.01 0.98 0.98],'color',[1 1 1])

    case 'EXPORTMODEL'

        fid=fopen('DREXLER.out','w');
        fprintf(fid,'Modelling Summary\n');
        fprintf(fid,'======================\n');
        allRadBioModels = get(stateS.processData.radbioType,'String');
        radiol_model = allRadBioModels{get(stateS.processData.radbioType,'value')};
        allModelTypes = get(stateS.processData.modelAlgo,'String');
        model_type = allModelTypes{get(stateS.processData.modelAlgo,'Value')};
        fprintf(fid,'%s radiobilogiocal model is: %s\n\n',radiol_model,model_type);
        for i=1:length(statC{indexS.dreesData}.data_model_param)
            fprintf(fid,'%s\n',statC{indexS.dreesData}.data_model_param{i});
        end
        fclose(fid);
        pathDREXLERout = which('DREXLER.out');
        msgbox(['Successfully exported to ',pathDREXLERout],'Export Successful')
        return


    case 'EXPORTVAR'

        % obtain variables if not present in handles
        if ~isfield(statC{indexS.dreesData},'dataX')
            [outcome, x, variables, isVarValid]=get_variable_list(statC{indexS.dreesData});
        else
            outcome = statC{indexS.dreesData}.outcome;
            x = statC{indexS.dreesData}.dataX;
            variables = statC{indexS.dreesData}.SelectedVariableNames;
        end

        % apply grade cutoff
        grade_cutoff = str2num(get(stateS.processData.endptSel,'String'));
        if isempty(grade_cutoff)
            msgbox('Grade cutoff cannot be empty')
            return;
        end
        greater_than_flag_val = get(stateS.processData.endptSign,'value');
        if greater_than_flag_val==1
            y = outcome(:)>=grade_cutoff;
        else
            y = outcome(:)<=grade_cutoff;
        end

        % get filename and pathname from the user
        [fname, pname] = uiputfile({'*.mat'},'Save the variables as:','DREES_var_export.mat');
        if isnumeric(fname) && ~fname  %cancel operation
            return;
        end

        % save
        save(fullfile(pname,fname), 'x', 'y', 'outcome', 'variables', '-v6')

        %inform user about the successful export
        msgbox(['Successfully exported to ',fullfile(pname,fname)],'Export Successful')

        return;

    case 'MAXIMIZELIST'
        [selection,OK] = listdlg('ListString',statC{indexS.dreesData}.fieldnames,'InitialValue',get(stateS.processData.listVar,'value'),'name','Select Variables','ListSize',[160 500]);
        if OK
            set(stateS.processData.listVar,'value',selection)
            DREES('varListCall')
        end           
        
    case 'CLEARMODEL'
        set(stateS.model.equation,'String','Model');
        set(stateS.model.spearmanCorr,'String','Spearman Correlation');
        set(stateS.model.sampleSiz,'String','Sample Size');
        set(stateS.model.paramList,'String','');
        delete(stateS.explore.miscHandles)
        stateS.explore.miscHandles = [];
        delete(stateS.predict.miscHandles)
        stateS.predict.miscHandles = [];        
        axes(stateS.explore.axis), cla reset
        axes(stateS.predict.axis), cla reset
        set([stateS.explore.axis stateS.predict.axis],'visible','off')
        statC{indexS.dreesData}.dataX = [];
        statC{indexS.dreesData}.SelectedVariableNames = [];
        statC{indexS.dreesData}.data_model_param = [];
        statC{indexS.dreesData}.mu=[];
        statC{indexS.dreesData}.b=[];
        %clear bootstrap data
        if isfield(statC{indexS.dreesData},'addset')
            statC{indexS.dreesData} = rmfield(statC{indexS.dreesData},'addset');
        end       
        
    case 'DATACENTERCALL'
        if isfield(stateS,'isVarSelected') && stateS.isVarSelected==1
            buttonName = questdlg('You are about to toggle centering state and will lose the current model. Continue?','Warning!','Yes','No','No');
            switch upper(buttonName)
                case 'YES'
                    %clear current model if variables change
                    DREES('CLEARMODEL')
                    %handles.isVarSelected = 0;
                    stateS.isVarSelected = 0;
                case 'NO'
                    centerValue = get(gcbo,'value');
                    set(gcbo,'value',~centerValue)
                    return
            end
        end

    case 'EDITMODEL'
        %not implemented yet
        
    case 'CLOSEREQUEST'
        closereq

end
