function prcrPlot_S

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};


g=statC{indexS.scriptDreesData}.mu;
y = statC{indexS.scriptDreesData}.D_outcome_group;
Tstep=0.05;

if ~exist('Tstep')
    Tstep=0.1;
end
T=[1:-Tstep:0];
npos=sum(y);
nneg=sum(~y);
for i=1:length(T);
    muc=g>=T(i);
    TP=sum(y(:).*muc(:));
    FP=sum(~y(:).*muc(:));
    cr(i)=TP/npos;
    if TP+FP == 0
        pr(i)=1;
    else
        pr(i)=TP/(TP+FP);
    end
end  % need still interpolation?

f = figure
range=[0.15 0.15 0.7 0.7];
hAxis = axes('position',range,'parent', f)
set(hAxis,'position',range)


avgpr=mean(pr);
plot(hAxis,cr,pr,'k-','LineWidth',1.5,'MarkerSize',12)
xlabel(hAxis,'Recall','FontSize',12), ylabel(hAxis,'Precision','FontSize',12)
axis(hAxis,[0 1 0 1])
str=['Average precision=',num2str(avgpr,2)];
text(0.45,0.8,str,'Color','k','parent',hAxis,'FontSize',12);
return


