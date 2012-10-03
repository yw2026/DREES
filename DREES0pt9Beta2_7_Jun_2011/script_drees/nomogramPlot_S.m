function nomogramPlot_S(comm,varargin)

%OHJ 07/26/2012, script-based DREES


global statC 
indexS=statC{end};

if ~exist('comm')
    comm = 'init';
end

% f = figure
% range=[0.15 0.15 0.7 0.7];
% hAxis = axes('position',range,'parent', f)
% set(hAxis,'position',range)
        
switch upper(comm)
    case 'INIT'       

        if ~isempty(varargin)
            X1              = varargin{1};
            X2              = varargin{2};
            b               = varargin{3};
            varName1        = varargin{4};
            varName2        = varargin{5};
            radModelType    = varargin{6};
        else %get the data from statC and stateS
            if ~isfield(statC{indexS.scriptDreesData},'dataX') || isempty(statC{indexS.scriptDreesData}.dataX)
                errordlg('Logistic Regression model must be run before plotting Nomogram')
                return;
            end            
            X1              = statC{indexS.scriptDreesData}.dataX(:,1);
            X2              = statC{indexS.scriptDreesData}.dataX(:,2);
            b               = statC{indexS.scriptDreesData}.b;
            varName1        = statC{indexS.scriptDreesData}.SelectedVariableNames{1};
            varName2        = statC{indexS.scriptDreesData}.SelectedVariableNames{2};
            
            %radModelType    = statC.D_model_type;    
            radModelType    = '';   
        end
        
        %number of data points to display on scale
        numPts  = 11;
        
        %create uniformly increasing scale.
        X1v     = round(linspace(min(X1),max(X1),numPts));
        X2vTmp     = linspace(min(X2),max(X2),numPts);
        X1v     = round(linspace(0,32,numPts));
        X2v     = linspace(0,1,numPts);

        %correct for signs
        if sign(b(1))<0
            X1v=X1v(end:-1:1);
        end
        if  sign(b(2))<0
           X2v=X2v(end:-1:1);
        end

        %obtain Response at these points
        MU0v    = logit3(X1v,X2v,b);
        deltaMU = (max(MU0v) - min(MU0v))/(numPts-1);
        MU0v    = MU0v(1):deltaMU:MU0v(end);
        %Round the scale
        %MU0v = [0.01 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.89];
        MU0v = [MU0v(1) 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 MU0v(end)];
        MUv     = b(end) - log(MU0v./(1-MU0v));
               
        %scale between 0 and 1
        X1plotV     = b(1)*X1v;
        X2plotV     = b(2)*X2v;        
        u2DIVu1     = (max(X2plotV) - min(X2plotV))/(max(X1plotV) - min(X1plotV));
        d2          = 1;
        d1          = d2*u2DIVu1;        
        [As1,Bs1]   = scalex(min(X1plotV),max(X1plotV));
        [As2,Bs2]   = scalex(min(X2plotV),max(X2plotV));
        [Asm,Bsm]   = scalex(min(MUv),max(MUv));
        X1plotVs    = getxs(X1plotV,As1,Bs1);
        X2plotVs    = getxs(X2plotV,As2,Bs2);   
        MUvs        = getxs(MUv,Asm,Bsm);
        if MUv(2)-MUv(1) < 0
            ud.reverseScale = 1;
            MUvs            = 1-MUvs;
        else
            ud.reverseScale = 0;
        end
        
        %initialize nomogram figure
        hFig = figure('color',[1 1 1],'name','Nomogram','numbertitle','off');
        plot(-d1*ones(numPts,1),X1plotVs,'linewidth',2)
        hold on, plot(d2*ones(numPts,1),X2plotVs,'linewidth',2)
        hold on, plot(0*ones(numPts,1),MUvs,'linewidth',2)
        set(gca,'xTick',[],'yTick',[],'box','off','tag','nomoAxis','XColor',[1 1 1],'YColor',[1 1 1])
        axis([-d1-0.1 d2+0.1 0 1])
        set(hFig,'WindowButtonDownFcn','nomogramPlot_S(''axisclicked'')','WindowButtonUpFcn','nomogramPlot_S(''buttonup'')')
        
        for i=1:numPts
            plot([-d1 -d1-0.02],[X1plotVs(i) X1plotVs(i)],'k')
            plot([d2 d2+0.02],[X2plotVs(i) X2plotVs(i)],'k')
            plot([0 0.02],[MUvs(i) MUvs(i)],'k')
            text(-d1-0.18,X1plotVs(i),sprintf('%0.4g',X1v(i)),'interpreter','none')
            text(d2+0.05,X2plotVs(i),sprintf('%0.4g',X2v(i)),'interpreter','none')
            text(0.05,MUvs(i),sprintf('%0.4g',MU0v(i)),'interpreter','none')
        end
        text(-d1-0.10,-0.05,varName1,'interpreter','none')
        text(d2-0.05,-0.05,varName2,'interpreter','none')
        text(-0.02,-0.05,radModelType,'interpreter','none')
        
        %set userdata
        ud.As1      = As1;
        ud.Bs1      = Bs1;
        ud.As2      = As2;
        ud.Bs2      = Bs2;
        ud.Asm      = Asm;
        ud.Bsm      = Bsm;
        ud.b        = b;
        ud.X1       = [];
        ud.X2       = [];
        ud.hAxis    = gca;
        ud.d1       = d1;
        ud.d2       = d2;
        set(hFig,'userdata',ud);
            
    case 'AXISCLICKED'
        
        %get userdata
        ud      = get(gcbo,'userdata');
        As1     = ud.As1;
        Bs1     = ud.Bs1;
        As2     = ud.As2;
        Bs2     = ud.Bs2;
        Asm     = ud.Asm;
        Bsm     = ud.Bsm;
        X1      = ud.X1;
        X2      = ud.X2;
        b       = ud.b;
        hAxis   = ud.hAxis;
        d1      = ud.d1;
        d2      = ud.d2;
                
        %return if right click
        clicktype = get(gcbo, 'selectiontype');
        if strcmpi(clicktype,'alt')
            set(gcbo,'WindowButtonMotionFcn','')
            hRefPt = findobj(hAxis,'tag','refPt');
            delete(hRefPt)
            ud.X1 = [];
            ud.X2 = [];
            set(gcbo,'userdata',ud)
            return;
        end

        currentPt = get(hAxis,'currentPoint');
        hRefPt = findobj(hAxis,'tag','refPt');
        delete(hRefPt)
        if currentPt(1,1) < 0 % i.e. 1st variable
            ud.X1 = getx(currentPt(1,2),As1,Bs1);
            plot(hAxis,-d1,currentPt(1,2),'ro','linewidth',2,'tag','refPt')
            plot(hAxis,[-d1 currentPt(1,1)],[currentPt(1,2) currentPt(1,2)],'color',[0.9 0.9 0.9],'linewidth',0.5,'tag','refPt')
            if ~isempty(X2)
                X2s = getxs(ud.X2,ud.As2,ud.Bs2);
                plot(hAxis,[-d1 d2],[currentPt(1,2) X2s],'color','r','linewidth',2,'tag','refPt')
                text(d1-0.18,X2s+0.02,sprintf('%0.4g',ud.X2/ud.b(2)),'color','b','fontSize',10,'interpreter','none','tag','refPt')
                p = logit3(ud.X1/b(1),ud.X2/b(2),b);
                pToScale = b(end) - log(p./(1-p));
                ps = getxs(pToScale,Asm,Bsm);
                if ud.reverseScale
                    ps = 1-ps;
                end
                text(-0.15,ps+0.02,sprintf('%0.4g',p),'color','b','fontSize',10,'interpreter','none','tag','refPt')
            end
            text(-d1+0.02,currentPt(1,2)+0.02,sprintf('%0.4g',ud.X1/ud.b(1)),'color','b','fontSize',10,'interpreter','none','tag','refPt')
        else
            ud.X2 = getx(currentPt(1,2),As2,Bs2);
            plot(hAxis,d2,currentPt(1,2),'ro','linewidth',2,'tag','refPt')
            plot(hAxis,[d2 currentPt(1,1)],[currentPt(1,2) currentPt(1,2)],'color',[0.9 0.9 0.9],'linewidth',0.5,'tag','refPt')
            if ~isempty(X1)
                X1s = getxs(ud.X1,ud.As1,ud.Bs1);
                plot(hAxis,[d2 -d1],[currentPt(1,2) X1s],'color','r','linewidth',2,'tag','refPt')
                text(-d1+0.02,X1s+0.02,sprintf('%0.4g',ud.X1/ud.b(1)),'color','b','fontSize',10,'interpreter','none','tag','refPt')
                p = logit3(ud.X1/b(1),ud.X2/b(2),b);
                pToScale = b(end) - log(p./(1-p));
                ps = getxs(pToScale,Asm,Bsm);
                if ud.reverseScale
                    ps = 1-ps;
                end
                text(-0.18,ps+0.02,sprintf('%0.4g',p),'color','b','fontSize',10,'interpreter','none','tag','refPt')
            end
            text(d2-0.18,currentPt(1,2)+0.02,sprintf('%0.4g',ud.X2/ud.b(2)),'color','b','fontSize',10,'interpreter','none','tag','refPt')
        end           
        set(gcbo,'userdata',ud)
        set(gcbo,'WindowButtonMotionFcn','nomogramPlot_S(''axisclicked'')')
        
    case 'BUTTONUP'
        set(gcbo,'WindowButtonMotionFcn','')
        ud = get(gcbo,'userdata');
        d1 = ud.d1;
        d2 = ud.d2;
        hAxis = ud.hAxis;
        hRefPt = findobj(hAxis,'tag','refPt');
        delete(hRefPt)        
        if ~isempty(ud.X1) && ~isempty(ud.X2)
            X1s = getxs(ud.X1,ud.As1,ud.Bs1);
            X2s = getxs(ud.X2,ud.As2,ud.Bs2);
            plot(hAxis,[-d1 d2],[X1s X2s],'color','r','linewidth',2,'tag','refPt')
            text(-d1+0.02,X1s+0.02,sprintf('%0.4g',ud.X1/ud.b(1)),'color','b','fontSize',10,'interpreter','none','tag','refPt')
            text(d2-0.18,X2s+0.02,sprintf('%0.4g',ud.X2/ud.b(2)),'color','b','fontSize',10,'interpreter','none','tag','refPt')
            p = logit3(ud.X1/ud.b(1),ud.X2/ud.b(2),ud.b);
            pToScale = ud.b(end) - log(p./(1-p));
            ps = getxs(pToScale,ud.Asm,ud.Bsm);
            if ud.reverseScale
                ps = 1-ps;
            end
            text(-0.18,ps+0.02,sprintf('%0.4g',p),'color','b','fontSize',10,'interpreter','none','tag','refPt')
        end
        
end

return;


function p=logit3(x,y,z)
% the three variable logit
g=x*z(1) + y*z(2) + z(end);
p = 1 ./ (1 + exp(-g));
return

function [As,Bs]=scalex(XL,XU)
%------------------------       Scale x-data from to 0 to 1
%
%   xs=a+x*b
%  %0=a+XL*b
%  %1=a+XU*b
% for i=1:length(XData(1,:)) % number of variables
%     bs(i)=1/(max(XData(:,i))-min(XData(:,i)));
%     as(i)=1-bs(i)*max(XData(:,i));
% end
%Matrix Form
Bs=1./(XU-XL);
As=1-Bs.*XU;
return;

function Xs=getxs(X,As,Bs)
%GetXs.m : Compute scaled data , given a,b and x
Ndata=length(X(:,1));
E=ones(Ndata,1);
Xs=X.*(E*Bs)+(E*As);
return;

function X = getx(Xs,As,Bs)
%  Ndata=length(X(:,1));
%  E=ones(Ndata,1);
%  Xs=X.*(E*Bs)+(E*As);
%---------------------------------------
%Compute data in physical units
Ndata = length(Xs(:,1));
E = ones(Ndata,1);
X = (Xs-E*As)./(E*Bs);
