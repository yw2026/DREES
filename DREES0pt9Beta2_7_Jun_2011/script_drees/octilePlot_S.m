function octilePlot_S

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

mu=statC{indexS.scriptDreesData}.mu;
y=statC{indexS.scriptDreesData}.D_outcome_group;

ls=length(mu);
ln=8;
[xs,rx]=sort(mu);
ys=y(rx);
nBins=round(ls/ln);
for i=1:ln
    vec=(i-1)*nBins+[1:nBins];
    vec=vec(find(vec<=ls));
    yh(i)=mean(ys(vec));
    syh(i)=sqrt(yh(i)*(1-yh(i)))/sqrt(length(ys(vec)));
    xh(i)=mean(xs(vec));
    sxh(i)=sqrt(xh(i)*(1-xh(i)))/sqrt(length(xs(vec)));
    rxh(i)=(yh(i)-xh(i))/sqrt(xh(i)*(1-xh(i)));
end

f = figure
range=[0.15 0.15 0.7 0.7];
hAxis = axes('position',range,'parent', f)
set(hAxis,'position',range)

rxh2=rxh.^2;
nextPlot = get(hAxis,'nextPlot');
set(hAxis,'nextPlot','add');
hError1 = errorbar(hAxis,[1:ln],yh,syh,'rx-');%'LineWidth',2.5,'MarkerSize',12);
hError2 = errorbar(hAxis,[1:ln],xh,sxh,'bo--');%'LineWidth',2.5,'MarkerSize',12);
plot(hAxis,[1:ln],xh+rxh2,'k:');%'LineWidth',2.5,'MarkerSize',12);
hPlot = plot(hAxis,[1:ln],xh-rxh2,'k:');%'LineWidth',2.5,'MarkerSize',12);
xlabel(hAxis,'Patient Group','FontSize',12)
ylabel(hAxis,'Prediction','FontSize',12)
legend(hAxis,[hError1(1) hError2(1) hPlot], 'Original','Prediction model','Squared-Residual Error')
axis(hAxis,[1 ln 0 1])
set(hAxis,'nextPlot',nextPlot);
