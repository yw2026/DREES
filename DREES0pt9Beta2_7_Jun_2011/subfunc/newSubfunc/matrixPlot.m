function matrixPlot(command,varargin)
%function matrixPlot(command,varargin)
%
%matrix plot GUI
%
%APA, 01/10/07
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
global statC
indexS = statC{end};

if ~ischar(command) && isnumeric(command)
    dataX = command;
    command = 'init';
end

switch upper(command)

    case 'INIT'
        
        allRadBioModels = get(stateS.processData.radbioType,'String');
        dataX = [statC{indexS.dreesData}.outcome(:),statC{indexS.dreesData}.dataX];
        lx=size(dataX,2);
        for i=1:lx
            for j=1:lx
                [rs(i,j),prob(i,j)] = spearman(dataX(:,i),dataX(:,j));
            end
        end
        variables{1} = allRadBioModels{get(stateS.processData.radbioType,'Value')};
        for i=2:lx
            variables{i}=statC{indexS.dreesData}.SelectedVariableNames{i-1};
        end

% Out of commission: take variable names as an input from user
%         varNames = '';
%         if ~isempty(varargin)
%             SelectedVariableNames = varargin{1};
%             varNames = {'Y'};
%             for i=1:length(SelectedVariableNames)
%                 varNames{i+1} = SelectedVariableNames{i};
%             end
%         end    
        
        position = [5 40 940 620];
        hFig = figure('name','Matrix Plot','numbertitle','off',...
            'position',position, 'doublebuffer', 'on','CloseRequestFcn',...
            'matrixPlot(''closeRequest'')','backingstore','on','tag',...
            'matrixPlotGUI', 'renderer', 'zbuffer','resize','on','color',[1 1 1]);

        %create axes to draw scatter plots
        units = 'normalized';
        nAxis = size(dataX,2);
        allAxes = [];
        delta = 1/(nAxis+1) - 1/(nAxis+1)/10;
        for i=1:nAxis            
            for j=1:nAxis
                allAxes(j,i) = axes('units',units,'position',[1/2/(nAxis+1)+(i-1)/(nAxis+1) 1/1.5/(nAxis+1)+(j-1)/(nAxis+1) delta delta],'box','on','xTick',[],'yTick',[]);
            end
        end
        allAxes = flipud(allAxes);
        hPlot = [];
        %draw plots
        for i=1:nAxis
            for j=1:nAxis

                hPlot = [hPlot plot(allAxes(i,j),dataX(:,j),dataX(:,i),'k+','hittest','off')];
                xLim = [min(dataX(:,j))-0.05*abs(max(dataX(:,j))-min(dataX(:,j))) max(dataX(:,j))+0.15*abs(max(dataX(:,j))-min(dataX(:,j)))];
                yLim = [min(dataX(:,i))-0.05*abs(max(dataX(:,i))-min(dataX(:,i))) max(dataX(:,i))+0.05*abs(max(dataX(:,i))-min(dataX(:,i)))];
                set(allAxes(i,j),'ButtonDownFcn',['matrixPlot(''axisClicked'',',num2str(i),',',num2str(j),')'],'xLim',xLim,'yLim',yLim,'xTick',[],'yTick',[],'nextPlot','add')
                if i>j
                    deltaX = 0.15*abs(max(dataX(:,j))-min(dataX(:,j)));
                    xFillV = [xLim(2)-deltaX*1/4 xLim(2)-deltaX*1/3 xLim(2)-deltaX*1/3 xLim(2)-deltaX*1/4];
                    deltaY = (yLim(2)-yLim(1))/2;
                    midY = (yLim(2)+yLim(1))/2;
                    yFillV = [midY midY midY+rs(i,j)*deltaY midY+rs(i,j)*deltaY];
                    fill(xFillV,yFillV,'b','parent',allAxes(i,j))
                    plot(allAxes(i,j),[xLim(2)-deltaX/2 xLim(2)],[midY midY])
                end
                if i==nAxis
                    set(allAxes(i,j),'xTick',[min(dataX(:,j)) max(dataX(:,j))])    
                    xticklabel_rotate(allAxes(i,j),[min(dataX(:,j)) max(dataX(:,j))]);
                end
                if j==nAxis
                    set(allAxes(i,j),'YAxisLocation','right')
                    set(allAxes(i,j),'yTick',[min(dataX(:,i)) max(dataX(:,i))],'fontSize',8)                    
                end
                if i==1
                    set(allAxes(i,j),'XAxisLocation','top')
                    xlabel(allAxes(i,j),variables{j},'fontSize',8,'interpreter','none')
                end
                if j==1                    
                    ylabel(allAxes(i,j),variables{i},'fontSize',8,'interpreter','none')
                end
                
            end
        end
        
        ud.dataX = dataX;
        ud.allAxes = allAxes;
        ud.hPlot = hPlot;
        set(hFig,'userData',ud)
        
    case 'AXISCLICKED'
        hFig = findobj('tag','matrixPlotGUI');
        ud = get(hFig,'userData');
        dataX = ud.dataX;
        allAxes = ud.allAxes;
        xyz = get(gcbo,'CurrentPoint');
        xy = xyz(1,1:2);
        hPlot = ud.hPlot;
        delete(hPlot)
        hPlot = [];
        I = varargin{1};
        J = varargin{2};
        %distSquaredV = (dataX(:,J)-xy(1)).^2 +  (dataX(:,I)-xy(2)).^2;
        %[jnk,ind] = min(distSquaredV);
        ind = getClosestInd(dataX(:,[J I]),xy);
        set(allAxes,'nextPlot','add')
        nAxis = size(allAxes,1);
        for i=1:nAxis
            for j=1:nAxis
                hPlot = [hPlot plot(allAxes(i,j),dataX(:,j),dataX(:,i),'k+','hittest','off')];
                hPlot = [hPlot plot(allAxes(i,j),dataX(ind,j),dataX(ind,i),'ro','hittest','off')];
                hPlot = [hPlot text(dataX(ind,j)+(max(dataX(:))-min(dataX(:)))/15,dataX(ind,i),num2str(statC{indexS.dreesData}.validObs(ind)),'parent',allAxes(i,j),'color','r')];
            end
        end
        ud.hPlot = hPlot;
        set(hFig,'userData',ud)
        
    case 'CLOSEREQUEST'
        closereq
        
end

function ind = getClosestInd(dataX,pt)
%This function returns the closest point in dataX to pt
XL = min(dataX);
XU = max(dataX);
[As,Bs]=scalex(XL,XU);
dataXs = getxs(dataX,As,Bs);
pts = getxs(pt,As,Bs);
distSquaredV = (dataXs(:,1)-pts(1)).^2 +  (dataXs(:,2)-pts(2)).^2;
[jnk,ind] = min(distSquaredV);

return;

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

