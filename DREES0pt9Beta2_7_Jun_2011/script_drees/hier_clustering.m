function hier_clustering

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};


data=statC{indexS.scriptDreesData}.D_data(:,statC{indexS.scriptDreesData}.D_selected_indices);
labels = data.Properties.VarNames;

X = double(data)';

%% Calculate pairwise distances
Y = pdist(X,'correlation');

%% Calculate linkages
Z = linkage(Y,'single');

%% View hierarchical tree
figure
dendrogram(Z)
%  Get the numeric axis labels & convert them to text labels
idx = str2num(get(gca,'xticklabel'));
set(gca,'xticklabel',labels(idx))
set(gcf,'color',[1 1 1]);
title('Hierarchical Clustering','fontSize',14);
box on;