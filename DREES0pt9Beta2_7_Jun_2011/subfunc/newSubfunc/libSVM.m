function libSVM(command,hAxis,dreesDataS)
%function libSVM(command,hAxis,dreesDataS)
%
%This is a callback function for libSVM.
%INPUT: command     - represents callback action
%       hAxis       - handle on which to display the Image Grand tour
%       dreesDataS  - structure array of data stored in DREES
%
%APA 07/30/2009, based on inputs from Dr. Jung Oh
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

        %create GUI for input

        % define margin constraints
        leftMarginWidth = 300;
        topMarginHeight = 50;
        stateS.leftMarginWidth = leftMarginWidth;
        stateS.topMarginHeight = topMarginHeight;

        str1 = 'Parameters for SVM';
        position = [5 40 350 350];

        defaultColor = [0.8 0.9 0.9];

        if isempty(findobj('tag','SVMFig'))
            % initialize main GUI figure
            hFig = figure('tag','SVMFig','name',str1,'numbertitle','off','position',position,...
                'CloseRequestFcn', 'libSVM(''closeRequest'')','menubar','none','resize','off','color',defaultColor);

            figureWidth = position(3); figureHeight = position(4);
            posTop = figureHeight-topMarginHeight;

            % create title handles
            %         handle(1) = uicontrol(hFig,'tag','titleFrame','units','pixels','Position',[90 figureHeight-topMarginHeight+5 200 40 ],'Style','frame','backgroundColor',defaultColor);
            %         handle(2) = uicontrol(hFig,'tag','title','units','pixels','Position',[91 figureHeight-topMarginHeight+10 198 30 ], 'String','Parameters for SVM','Style','text', 'fontSize',10,'FontWeight','Bold','HorizontalAlignment','center','backgroundColor',defaultColor);

            % CV
            handle(3) = uicontrol(hFig,'tag','cvStatic','units','pixels','Position',[20 posTop-10 120 20], 'String','Cross Validation','Style','text', 'fontSize',10,'FontWeight','normal','BackgroundColor',defaultColor,'HorizontalAlignment','right');
            handle(4) = uicontrol(hFig,'tag','cvEdit','units','pixels','Position',[150 posTop-10 120 20], 'String','10','Style','edit', 'fontSize',10,'FontWeight','normal','BackgroundColor',[1 1 1],'HorizontalAlignment','left');

            % Kernel
            handle(5) = uicontrol(hFig,'tag','kernelStatic','units','pixels','Position',[20 posTop-45 120 20], 'String','Kernel','Style','text', 'fontSize',10,'FontWeight','normal','BackgroundColor',defaultColor,'HorizontalAlignment','right');
            kernelStr = {'Radial basis function: exp(-gamma x |u-v|^2)','Polynomial: (gamma x u'' x v + coef)^degree','Linear: u'' x v'};
            handle(6) = uicontrol(hFig,'tag','kernelSelect','units','pixels','Position',[150 posTop-40 120 20], 'String',kernelStr,'Style','popup', 'fontSize',10,'FontWeight','normal','BackgroundColor',[1 1 1],'HorizontalAlignment','left','callback', 'libSVM(''kernelSelected'')');

            % C
            handle(7) = uicontrol(hFig,'tag','CStatic','units','pixels','Position',[20 posTop-70 120 20], 'String','C','Style','text', 'fontSize',10,'FontWeight','normal','BackgroundColor',defaultColor,'HorizontalAlignment','right');
            handle(8) = uicontrol(hFig,'tag','CEdit','units','pixels','Position',[150 posTop-70 120 20], 'String','100','Style','edit', 'fontSize',10,'FontWeight','normal','BackgroundColor',[1 1 1],'HorizontalAlignment','left');

            % weights
            handle(11) = uicontrol(hFig,'tag','weightsStatic','units','pixels','Position',[20 posTop-100 120 20], 'String','Weight','Style','text', 'fontSize',10,'FontWeight','normal','BackgroundColor',defaultColor,'HorizontalAlignment','right');
            handle(12) = uicontrol(hFig,'tag','weightsEdit','units','pixels','Position',[150 posTop-100 120 20], 'String','1','Style','edit', 'fontSize',10,'FontWeight','normal','BackgroundColor',[1 1 1],'HorizontalAlignment','left');

            % gamma
            handle(9) = uicontrol(hFig,'tag','gammaStatic','units','pixels','Position',[20 posTop-130 120 20], 'String','Gamma','Style','text', 'fontSize',10,'FontWeight','normal','BackgroundColor',defaultColor,'HorizontalAlignment','right');
            handle(10) = uicontrol(hFig,'tag','gammaEdit','units','pixels','Position',[150 posTop-130 120 20], 'String','0.2','Style','edit', 'fontSize',10,'FontWeight','normal','BackgroundColor',[1 1 1],'HorizontalAlignment','left');

            % degree
            handle(13) = uicontrol(hFig,'tag','degreeStatic','units','pixels','Position',[20 posTop-160 120 20], 'String','degree','Style','text', 'fontSize',10,'FontWeight','normal','BackgroundColor',defaultColor,'HorizontalAlignment','right');
            handle(14) = uicontrol(hFig,'tag','degreeEdit','units','pixels','Position',[150 posTop-160 120 20], 'String','2','Style','edit', 'fontSize',10,'FontWeight','normal','BackgroundColor',[1 1 1],'HorizontalAlignment','left');

            % coef
            handle(15) = uicontrol(hFig,'tag','coefStatic','units','pixels','Position',[20 posTop-190 120 20], 'String','coef','Style','text', 'fontSize',10,'FontWeight','normal','BackgroundColor',defaultColor,'HorizontalAlignment','right');
            handle(16) = uicontrol(hFig,'tag','coefEdit','units','pixels','Position',[150 posTop-190 120 20], 'String','1','Style','edit', 'fontSize',10,'FontWeight','normal','BackgroundColor',[1 1 1],'HorizontalAlignment','left');

            %Call libSVM
            handle(17) = uicontrol(hFig,'tag','solvePush','units','pixels','Position',[150 posTop-260 120 30], 'String','Run','Style','push', 'fontSize',10,'FontWeight','bold','BackgroundColor',[1 1 1],'HorizontalAlignment','left','callback', 'libSVM(''runLibSVM'')');

        else
            hFig = findobj('tag','SVMFig');
            figure(hFig)
            %return
        end

        libSVM('KERNELSELECTED')

        dataX = dreesDataS.dataX;
        y     = dreesDataS.outcome(:)>=str2num(get(stateS.processData.endptSel,'String'));

        ud.hFig  = hFig;
        ud.hAxis = hAxis;
        ud.dataX = dataX;
        ud.y     = y;

        set(hFig,'userdata',ud)

    case 'KERNELSELECTED'

        hKernel = findobj('tag','kernelSelect');
        kernelVal = get(hKernel,'value');

        hC       = findobj('tag','CEdit');
        hCS = findobj('tag','CStatic');
        hweights = findobj('tag','weightsEdit');
        hweightsS = findobj('tag','weightsStatic');
        hgamma   = findobj('tag','gammaEdit');
        hgammaS   = findobj('tag','gammaStatic');
        hdegree  = findobj('tag','degreeEdit');
        hdegreeS  = findobj('tag','degreeStatic');
        hcoef    = findobj('tag','coefEdit');
        hcoefS    = findobj('tag','coefStatic');

        set([hC hweights hgamma hdegree hcoef hCS hweightsS hgammaS hdegreeS hcoefS],'visible','on')

        if kernelVal == 1
            set([hdegree hcoef hdegreeS hcoefS],'visible','off')
        elseif kernelVal == 3
            set([hgamma hdegree hcoef hgammaS hdegreeS hcoefS],'visible','off')
        end


    case 'RUNLIBSVM'
        
        if ~exist('svmpredict','file')==3
            mgsStrC = {'1> libSVM library is required. Please follow these steps to obtain it:',...
                '2> Download libSVM from http://www.csie.ntu.edu.tw/~cjlin/libsvm/#matlab (Zip)',...
                '3> Unzip and add it to Matlab Path.',...
                '4> Then compile it by following README file under libSVM'};
            msgbox(mgsStrC,'libSVM not found','modal')
            return;
        end

        hCV      = findobj('tag','cvEdit');
        hC       = findobj('tag','CEdit');
        hweights = findobj('tag','weightsEdit');
        hgamma   = findobj('tag','gammaEdit');
        hdegree  = findobj('tag','degreeEdit');
        hcoef    = findobj('tag','coefEdit');
        hKernel = findobj('tag','kernelSelect');

        CViter      = str2num(get(hCV,'string'));
        kernelIndex = get(hKernel,'value');
        C           = str2num(get(hC,'string'));
        weights     = str2num(get(hweights,'string'));
        gamma       = str2num(get(hgamma,'string'));
        degree      = str2num(get(hdegree,'string'));
        coef        = str2num(get(hcoef,'string'));

        if kernelIndex == 2 && (isempty(CViter) || isempty(C) || isempty(gamma) || isempty(degree) || isempty(coef))
            disp('Incorrect input parameters')
            return;
        elseif kernelIndex == 1 && (isempty(CViter) || isempty(C) || isempty(gamma))
            disp('Incorrect input parameters')
            return;
        elseif kernelIndex == 3 && (isempty(CViter) || isempty(C))
            disp('Incorrect input parameters')
            return;
        end

        hFig = findobj('tag','SVMFig');
        ud = get(hFig,'userdata');

        dataX = ud.dataX;
        y     = ud.y;
        hAxis = ud.hAxis;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Call libSVM using dataX, y and parameters
        %Written by Jung Hun
        option='';
        if kernelIndex == 2
            option = ['-c ', num2str(C),' -g ', num2str(gamma),' -d ', num2str(degree),' -r ', num2str(coef), ' -w1 ', num2str(weights)];
        elseif kernelIndex == 1
            option = ['-c ',num2str(C),' -g ', num2str(gamma), ' -w1 ', num2str(weights)];
        elseif kernelIndex == 3
            option = ['-c ', num2str(C), ' -w1 ', num2str(weights)];
        end

        Class = y;
        Data = dataX;
        CV= CViter;

        %Normalization
        Data = DataSt(Data);

        k = 2; %The number of classes: 2
        [n,m] = size(Data);

        [sort_Data, sort_Class, each_class_no] = sortData(Data, Class,k);

        Data1 = zeros(each_class_no(1),m);
        Data2 = zeros(each_class_no(2),m);

        Data1 = sort_Data(1:each_class_no(1),:);
        Data2 = sort_Data(1+each_class_no(1):each_class_no(1)+each_class_no(2),:);


        %Random permutation
        Data1_rand = zeros(each_class_no(1),m);
        Data2_rand = zeros(each_class_no(2),m);


        [not, p] = sort(rand(1, each_class_no(1)));
        for i=1:each_class_no(1)
            Data1_rand(i,:) = Data1(p(i),:);
        end

        [not, p] = sort(rand(1, each_class_no(2)));
        for i=1:each_class_no(2)
            Data2_rand(i,:) = Data2(p(i),:);
        end


        start_pos1 = 0;
        end_pos1 = 0;
        start_pos2 = 0;
        end_pos2 = 0;

        acc=0;
        sen=0;
        spe=0;
        mcc=0;
        %10-Cross validation
        for j=1:CV
            [Train, Test, start_pos1, end_pos1] = crossV(Data1_rand, j, start_pos1, end_pos1, CV);
            sr1 = size(Train,1);
            st1 = size(Test,1);

            [Train_temp, Test_temp, start_pos2, end_pos2] = crossV(Data2_rand, j, start_pos2, end_pos2, CV);
            Train = [Train' Train_temp']';
            Test = [Test' Test_temp']';
            sr2 = size(Train_temp,1);
            st2 = size(Test_temp,1);


            Train_class = zeros(sr1+sr2,1);
            Test_class = zeros(st1+st2,1);

            for i=1:sr1+sr2
                if i>=1 && i<=sr1
                    Train_class(i) = 1;
                elseif i>sr1 && i<=sr1+sr2
                    Train_class(i) = -1;

                end
            end

            for i=1:st1+st2
                if i>=1 && i<=st1
                    Test_class(i) = 1;
                elseif i>st1 && i<=st1+st2
                    Test_class(i) = -1;

                end
            end


            %testing
            cor1 = 0;
            incor1 = 0;
            tot1 = 0;
            cor2 = 0;
            incor2 = 0;
            tot2 = 0;

            %%%%%%%%%%%%%%% training %%%%%%%%%%%%%%%%%%%
            model = svmtrain(Train_class, Train, option);
            %%%%%%%%%%%%%%% prediction %%%%%%%%%%%%%%%%%
            [predict_label, accuracy, prob_estimates] = svmpredict(Test_class, Test, model);


            for i=1:st1+st2

                %Count total samples in each class
                if Test_class(i) == 1
                    tot1 = tot1+1;
                elseif Test_class(i) == -1
                    tot2 = tot2+1;

                end

                %Count correctedly classified samples in each class
                if predict_label(i) == Test_class(i)
                    if Test_class(i) == 1
                        cor1 = cor1+1;
                    elseif Test_class(i) == -1
                        cor2 = cor2+1;

                    end
                else %Count incorrectedly classified samples in each class
                    if Test_class(i) == 1
                        incor1 = incor1+1;
                    elseif Test_class(i) == -1
                        incor2 = incor2+1;

                    end
                end
            end

            tp=cor1;
            tn=cor2;
            fp=incor2;
            fn=incor1;

            acc= acc+(tp+tn)/(tp+tn+fp+fn);
            sen=sen+(tp)/(tp+fn);
            spe=spe+(tn)/(tn+fp);
            if(sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn))==0)
                mcc=mcc+0;
            else
                mcc=mcc+(tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
            end
        end

        acc=acc/CV;
        sen=sen/CV;
        spe=spe/CV;
        mcc=mcc/CV;

        disp('------------------------------------');
        disp(['Total samples: ' num2str(size(Data,1))]);
        disp(['0 class samples: ' num2str(size(Data1,1))]);
        disp(['1 class samples: ' num2str(size(Data2,1))]);
        disp(['accuracy: ' num2str(acc)]);
        disp(['sensitivity: ' num2str(sen)]);
        disp(['specificity: ' num2str(spe)]);
        disp(['mcc: ' num2str(mcc)]);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if(m>2)
            warning('Could not start visualization for number of variables greater than 2')
        end

        if(m==2) %plot contour only for two variables
            model = svmtrain(sort_Class, sort_Data, option);
            bias = -model.rho;

            SVs=[model.SVs];
            p=1;
            for i=1:size(sort_Data,1)
                val=sort_Data(i);
                isexist=0;
                for j=1:size(SVs,1)
                    val1=SVs(j,1);
                    if(val==val1)
                        alpha(i)=abs(model.sv_coef(p));
                        isexist=1;
                        p=p+1;
                        break;
                    end
                end
                if(isexist==0)
                    alpha(i)=0;
                end

            end
            alpha=alpha';

            %alpha = abs(model.sv_coef);
            p1=0;
            p2=0; %useless
            Xscale = [1 1];
            if kernelIndex == 2
                p1= num2str(degree);
                ker = 'poly';
            elseif kernelIndex == 1
                p1= sqrt(1/(2*gamma));%sigma
                ker = 'rbf';
            elseif kernelIndex == 3
                ker = 'linear';
            end
            plot_svm_binary_output_contour2(hAxis, sort_Data, sort_Class,Xscale, 50,ker,p1,p2,alpha,bias)
        end

    case 'CLOSEREQUEST'
        closereq

end

