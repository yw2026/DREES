function automated_logistic

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

y = statC{indexS.scriptDreesData}.D_outcome_group';
dataX = double(statC{indexS.scriptDreesData}.D_data(:,statC{indexS.scriptDreesData}.D_selected_indices));
outcome = statC{indexS.scriptDreesData}.D_outcome_grade';
SelectedVariableNames=statC{indexS.scriptDreesData}.D_selected_variables;

lX=size(dataX,2);
ly=length(y);
button = questdlg({['You have selected ',num2str(ly),' with ',num2str(lX),' variables'],...
    'Do you want to proceed?'}, 'Automated Logistic Regression','NO','YES','YES');
if strcmp(button,'NO')
    return;
end

prompt={'Enter model order selection method (1: LOO-CV, 2: Bootstrap, 3:M-Fold CV, 4: AIC-CV, 5: BIC-CV, 6: AIC-Boot, 7: AICS-Boot, 8: BIC-Boot)','Enter minimum model order:','Enter maximum model order:',...
    'Enter number of bootstrap samples for model order selection:','Enter Number of Folds (M):','Enter number of bootstrap samples for parameters estimation:',...
    'Enter Statistica test 1:Wald, 2:Likelihood ratio test, 3: joint test)','Enter max. iterations of logistic regression:', 'Enter convergence tolerance of logistic regression:',...
    'Enter test regularization'};
def={'1','1',num2str(min(10,lX)),num2str(10*ly), num2str(10), num2str(5*ly),num2str(1),num2str(300),num2str(1e-6), num2str(0.5)};
dlgTitle=['Automatic logistic regression parameters'];
answer=inputdlg(prompt,dlgTitle,1,def);
if isempty(answer)
    return;
end
order_sel_method = str2num(answer{1});
min_order        = str2num(answer{2});
max_order        = str2num(answer{3});
nboot_order      = str2num(answer{4});
mfolds_cv        = str2num(answer{5});
nboot_param      = str2num(answer{6});
stat_tests = {'Wald', 'LRT','Wald_LRT'};
test_method      = stat_tests{str2num(answer{7})};
logiter_param    = str2num(answer{8});
logtol_param     = str2num(answer{9});
lambda           = str2num(answer{10});

[statC{indexS.scriptDreesData}.SelectedVariableNames, statC{indexS.scriptDreesData}.dataX, statC{indexS.scriptDreesData}.addset] = apply_auto_logistic_regression(dataX,y,outcome,SelectedVariableNames,order_sel_method,min_order,max_order,nboot_order,mfolds_cv, nboot_param, test_method, logiter_param,logtol_param, lambda);

[statC{indexS.scriptDreesData}.mu, statC{indexS.scriptDreesData}.b, pval] = drxlr_apply_logistic_regression(statC{indexS.scriptDreesData}.dataX,y,logiter_param,logtol_param);

statC = displayMMModel_S(statC,pval);
% statC.outcome = statC.D_outcome_grade;
% plot self-correlations and cumulative histogram
f = figure
hAxis = axes('position',[0.2 0.2 0.6 0.6],'parent', f)

plotSelfCorrelation_S(hAxis,statC); % use original set


f = figure
hAxis = axes('position',[0.2 0.2 0.6 0.6],'parent', f)
plot_cum_hist_S(hAxis,statC{indexS.scriptDreesData}.dataX,outcome,statC{indexS.scriptDreesData}.mu,1,statC{indexS.scriptDreesData}.b,statC{indexS.scriptDreesData}.D_model_type);

