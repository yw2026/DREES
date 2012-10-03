function plot_svm_binary_output_contour2(hAxis, X,Y,Xscale, step,ker,p1,p2,alpha,bias)  
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

global stateS statC
indexS = statC{end};
varNamC = statC{indexS.dreesData}.SelectedVariableNames;

delete(stateS.explore.miscHandles)
cla(hAxis);
reset(hAxis);
axes(hAxis);
stateS.explore.miscHandles = [];
set(hAxis,'visible','off')

% Plot function value
[ln, p]=size(X);
if p>2
    error('Cannot plot more than two variables');
end
xmin=[0 0];
xmax=[max(X(:,2)) 1];

[x1,x2] = meshgrid(xmin(1):(xmax(1)-xmin(1))/step:xmax(1),xmin(2):(xmax(2)-xmin(2))/step:xmax(2)); 

       
tstX=[x1(:),x2(:)];
lt=size(x1,1);
trnYY=ones(size(tstX,1),1)*Y(:)';
H=trnYY .* mysvkernel(ker,tstX,X,p1,p2);
predictedY=H*alpha+bias;  
predictedYprob= sigmoid(predictedY);
z=reshape(predictedYprob,lt,lt);
%contour(x1,x2,z,[-1 -1],'g:')
%contour(x1,x2,z,[1 1],'r:')


        
% normalize axis...
%zn=normminmax(z);
x1o=x1*Xscale(1);
x2o=x2*Xscale(2);
Xorig1=X(:,1)*Xscale(1);
Xorig2=X(:,2)*Xscale(2);
indy=find(Y>0);
set(hAxis,'nextPlot','add')
set(hAxis,'visible','on','box','on')
plot(Xorig1,Xorig2,'k.','MarkerSize',6,'parent',hAxis)
plot(Xorig1(indy),Xorig2(indy),'ro','MarkerSize',6,'parent',hAxis)
[C,h] = contour(x1o,x2o,z,20,'parent',hAxis);
cc=clabel(C,h, 'FontSize',11,'LabelSpacing',144);
contour(x1o,x2o,z,sigmoid([0 0]),'color',[0.5 0.5 0.5],'Linewidth',4,'parent',hAxis)
contour(x1o,x2o,z,sigmoid([-1 -1]),'g:','Linewidth',3,'parent',hAxis)
contour(x1o,x2o,z,sigmoid([1 1]),'r:', 'Linewidth',3,'parent',hAxis)
xlabel(hAxis,varNamC{1},'fontSize',8,'interpreter','none')
ylabel(hAxis,varNamC{2},'fontSize',8,'interpreter','none')
return


function y=sigmoid(x)
y=1./(1+exp(-x));
return

