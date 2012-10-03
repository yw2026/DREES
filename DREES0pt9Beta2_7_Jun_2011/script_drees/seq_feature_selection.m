function seq_feature_selection

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

data=statC{indexS.scriptDreesData}.D_data(:,statC{indexS.scriptDreesData}.D_selected_indices);
%data=statC{indexS.scriptDreesData}.D_selected_data(:,statC{indexS.scriptDreesData}.D_selected_indices);

labels = data.Properties.VarNames;

X = double(data);
y = statC{indexS.scriptDreesData}.D_outcome_group';
%% Define model error function
f = @(X,Y,Xtest,Ytest) norm(Ytest - Xtest*(X\Y))^2;
c = cvpartition(y,'k',10);

%% Perform sequential feature selection
opt = statset('display','iter');
[fs,history] = sequentialfs(f,X,y,'cv',c,'options',opt)

disp(sprintf('Selected variables:'))
disp(labels(fs))