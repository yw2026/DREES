function k_means

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

if length(statC{indexS.scriptDreesData}.D_selected_indices) ~= 2
    error_variable_selection1;
    return;
end

X=double(statC{indexS.scriptDreesData}.D_data(:,statC{indexS.scriptDreesData}.D_selected_indices));

[idx,ctrs] = kmeans(X,2);


figure; 
hold on;
plot(X(idx==1,1),X(idx==1,2),'ko','LineWidth',3,'MarkerSize',10)
plot(X(idx==2,1),X(idx==2,2),'gs','LineWidth',3,'MarkerSize',10)

plot(X(statC{indexS.scriptDreesData}.D_outcome_group,1),X(statC{indexS.scriptDreesData}.D_outcome_group,2),'ro','MarkerSize',3,'LineWidth',3)
plot(X(~statC{indexS.scriptDreesData}.D_outcome_group,1),X(~statC{indexS.scriptDreesData}.D_outcome_group,2),'bo','MarkerSize',3,'LineWidth',3)
% plot(ctrs(:,1),ctrs(:,2),'kx',...
%      'MarkerSize',12,'LineWidth',2)
% plot(ctrs(:,1),ctrs(:,2),'ko',...
%      'MarkerSize',12,'LineWidth',2)
legend('Cluster 1','Cluster 2','Toxicity','Non-toxicity')
   
title('K-means','fontSize',14);
set(gcf,'color',[1 1 1]);
xlabel(sprintf('%s',strrep(statC{indexS.scriptDreesData}.D_variables{statC{indexS.scriptDreesData}.D_selected_indices(1)},'_','-')),'fontSize',14);
ylabel(sprintf('%s',strrep(statC{indexS.scriptDreesData}.D_variables{statC{indexS.scriptDreesData}.D_selected_indices(2)},'_','-')),'fontSize',14);
box on;

%boundary
xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
[ww,ss] = meshgrid(xLimits(1):xLimits(2),yLimits(1):yLimits(2));
ww=ww(:); ss=ss(:);
[predgrp,~,~,~,c] = classify([ww,ss],[X(:,1),X(:,2)],idx-1);


%  Define boundary
ws = [ww,ss];
K = c(1,2).const;
L = c(1,2).linear; 

%linear
sline = [yLimits(1);yLimits(2)];
wline = -(K + L(2)*sline)/L(1);
line(wline,sline,'color','m','linewidth',2)

% quadratic
%[predgrp,~,~,~,c] = classify([ww,ss],[X(:,1),X(:,2)],idx-1,'quadratic');
% Q = c(1,2).quadratic;
% f = K + ws*L + sum((ws*Q) .* ws, 2);
% contour(xLimits(1):xLimits(2),yLimits(1):yLimits(2),reshape(f,yLimits(2)-yLimits(1)+1,xLimits(2)-xLimits(1)+1),[0 0],'color','m','linewidth',2)


hold off;

