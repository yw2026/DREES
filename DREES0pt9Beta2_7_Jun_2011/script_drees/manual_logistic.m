function manual_logistic

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

y = statC{indexS.scriptDreesData}.D_outcome_group';
dataX = double(statC{indexS.scriptDreesData}.D_data(:,statC{indexS.scriptDreesData}.D_selected_indices));
outcome = statC{indexS.scriptDreesData}.D_outcome_grade';

statC{indexS.scriptDreesData}.SelectedVariableNames = statC{indexS.scriptDreesData}.D_selected_variables;
statC{indexS.scriptDreesData}.dataX = double(statC{indexS.scriptDreesData}.D_selected_data);

[statC{indexS.scriptDreesData}.mu, statC{indexS.scriptDreesData}.b, pval] = drxlr_apply_logistic_regression(dataX,y);

statC = displayMMModel_S(statC,pval);
% statC.outcome = statC.D_outcome_grade;
% plot self-correlations and cumulative histogram
f = figure
hAxis = axes('position',[0.2 0.2 0.6 0.6],'parent', f)

plotSelfCorrelation_S(hAxis,statC); % use original set


f = figure
hAxis = axes('position',[0.2 0.2 0.6 0.6],'parent', f)
plot_cum_hist_S(hAxis,statC{indexS.scriptDreesData}.dataX,outcome,statC{indexS.scriptDreesData}.mu,1,statC{indexS.scriptDreesData}.b,statC{indexS.scriptDreesData}.D_model_type);

