function hAxis = plot_cum_hist_S(hAxis,x,y,mu,model_flag,b,radBioModelStr)

%OHJ 07/26/2012, script-based DREES


range=[0.15 0.15 0.7 0.7];
set(hAxis,'position',range)
hCumHist  = axes('units','normalized','position',range,'Color', 'none','visible','off','yAxisLocation','right');


if exist('radBioModelStr') && ischar(radBioModelStr)
else
    radBioModelStr = '';
end
if model_flag==1 %% multimetric
    sx=size(x,2);
    lastb=b(end);
    GX=(x*b(1:sx))+lastb;
elseif model_flag==2 | model_flag==3 % analytical
    GX=x;
else
    errordlg('No field found','get_field_data');
end
%Create Bins
[SortedGX,indexGX]=sort(GX);
SortedY=y(indexGX);
SortedMu=mu(indexGX);
[numelements,binlocation]=hist(SortedGX,8);
boundary=[-Inf (diff(binlocation)/2)+binlocation(1:end-1) Inf];
%bin Y (observations)
SortedY2=[];
for i=2:length(boundary)
    SortedY1=SortedY(boundary(i-1)<SortedGX & SortedGX<=boundary(i));
    if isempty(SortedY1)
        SortedY1=0;
    end
    SortedY2=[SortedY2,length(find(SortedY1))];
end
%bin mu (predictions)
SortedMuBin=[];
for i=2:length(boundary)
    SortedMuBin1 = SortedMu(boundary(i-1)<SortedGX & SortedGX<=boundary(i));
    if isempty(SortedMuBin1)
        SortedMuBin1 = 0;
    end
    SortedMuBin=[SortedMuBin,mean(SortedMuBin1)];
end

set(hAxis,'visible','on')
SortedMu1=cumsum(SortedMu);
nextPlot = get(hAxis,'nextPlot');
set(hAxis,'nextPlot','add');
%Plot histogram for Observations
set(bar(hAxis,binlocation,cumsum(SortedY2)/length(SortedY),1),'FaceColor','w','LineWidth',1.5)
%Plot histogram for Predictions
plot(hAxis,SortedGX,SortedMu1/length(SortedMu),'b-','LineWidth',1.5,'MarkerSize',9,'parent',hAxis)
% Ep = cumsum(SortedY)/sum(SortedY);
% O = cumsum(SortedMu1)/sum(SortedMu1);
Ep = SortedY2/length(SortedY);
O = SortedMuBin;
chi2 = sum((O(:)-Ep(:)).^2 ./ (Ep(:)+1e-3));
np = length(O)-length(b);
p = 1-drxlr_get_p_chi2(chi2,np);
legend(hAxis,'Actual',['Prediction, p = ',num2str(p)],'Location','NorthWest')
axis(hAxis,'tight')
axis(hCumHist,'tight')
%Create Axis Tick Labels
yTick = get(hAxis,'YTick');
for i=1:length(yTick)
    yTickLabel{i} = sprintf('%0.3g',length(SortedY)*yTick(i));
    yTickLabelhAxis{i} = sprintf('%0.3g',yTick(i)*100);
end
maxLeftAxis = max([cumsum(SortedY2)/length(SortedY) SortedMu1'/length(SortedMu)]);
set(hAxis,'yTicklabel',yTickLabelhAxis)
set(hCumHist,'visible','on','yTicklabel',yTickLabel,'yAxisLocation','right','yTick',yTick/maxLeftAxis,'xTicklabel',{},'color','none','yLim',[0 1])
ylabel(hCumHist,'Number of Complications','FontSize',12);

xlabel(hAxis,'g(x)', 'units', 'normalized','FontWeight','normal','FontSize',12);
%ylabel(hAxis,['Cumulative ', radBioModelStr], 'units', 'normalized','FontWeight','normal');
ylabel(hAxis,'Complication rate (%)', 'units', 'normalized','FontWeight','normal','FontSize',12);
set(hAxis,'nextPlot',nextPlot);
set(hAxis,'FontSize',12)
set(hCumHist,'FontSize',12)

return
