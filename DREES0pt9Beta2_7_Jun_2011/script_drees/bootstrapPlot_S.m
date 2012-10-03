function bootstrapPlot_S

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

if ~isfield(statC,'addset')
    button = questdlg({['No bootstrap data is available!',...
        ' Do you want to generate one?']}, 'Bootstrap Plot','NO','YES','YES');
    if strcmp(button,'NO')
        return;
    else
        prompt={'Enter number of bootstrap samples','Enter Statistica test 1:Wald, 2:Likelihood ratio test, 3: joint test)','Enter max. iterations of logistic regression:', 'Enter convergence tolerance of logistic regression:',...
            'Enter test regularization'};
        def={num2str(5*length(statC{indexS.scriptDreesData}.D_outcome_grade)),num2str(1),num2str(300),num2str(1e-6), num2str(0.5)};
        dlgTitle=['Bootstrap Plot Parameters'];
        answer=inputdlg(prompt,dlgTitle,1,def);
        if isempty(answer)
            set(hObject,'value',0)
            return;
        end
        nboot=str2num(answer{1});
        stat_tests = {'Wald', 'LRT','Wald_LRT'};
        test_method = stat_tests{str2num(answer{2})};
        logiter_param = str2num(answer{3});
        logtol_param = str2num(answer{4});
        lambda = str2num(answer{5});
        waitbar_handle = waitbar(0,'Bootstrap analysis...');
        set(waitbar_handle,'name','Bootstrap Plot');
        guiflag = 1;
        y=statC{indexS.scriptDreesData}.D_outcome_group;
        statC{indexS.scriptDreesData}.addset= drxlr_simple_bootstrap_analysis(statC{indexS.scriptDreesData}.dataX, y, nboot, test_method, logiter_param,logtol_param,lambda, guiflag, waitbar_handle);
        close(waitbar_handle);
    end
end

f = figure
range=[0.15 0.15 0.7 0.7];
hAxis = axes('position',range,'parent', f)
set(hAxis,'position',range)

plot_bootstrap(hAxis,statC{indexS.scriptDreesData}.addset);
%colorbar('peer',hAxis)
set(hAxis,'Ytick',[size(statC{indexS.scriptDreesData}.addset{1},1)/2:size(statC{indexS.scriptDreesData}.addset{1},1):prod(size(statC{indexS.scriptDreesData}.addset{1}))])

set(hAxis,'YtickLabel',statC{indexS.scriptDreesData}.D_selected_variables);
xlabel('Bootstrap Sample','FontSize',12)
set(hAxis,'Xtick',[1:10:length(statC{indexS.scriptDreesData}.addset)])
set(hAxis,'visible','on')
return
