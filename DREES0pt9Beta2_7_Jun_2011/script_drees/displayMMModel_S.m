function statC = displayMMModel_S(statC,pval)

%OHJ 07/26/2012, script-based DREES

indexS=statC{end};

y = statC{indexS.scriptDreesData}.D_outcome_group';

strmodel2={};
temp='Y = ';
for q=1:length(statC{indexS.scriptDreesData}.b)-1;
    temp=[temp,num2str(statC{indexS.scriptDreesData}.b(q),'%0.3g'),'*X',num2str(q),' ','+',' '];
    if mod(q,6)==0
        strmodel2={strmodel2{:},temp};
        temp='';
    end
end
temp=[temp,num2str(statC{indexS.scriptDreesData}.b(end),'%0.3g')];

strmodel = statC{indexS.scriptDreesData}.D_model_type;

[rs, pm] = spearman(statC{indexS.scriptDreesData}.mu,y);
rstext = ['Spearman Corr = ',num2str(rs,'%0.3g'), ' (p=',num2str(pm,'%0.3g'),')'];


strmodel3={[strmodel,' model'],[strmodel2{:},temp],[rstext],[' ']};
strmodel3 = chopString(strmodel3,60);

%set(stateS.model.equation,'String',strmodel3,'fontsize',8,'fontweight','normal')
statC{indexS.scriptDreesData}.data_model_param{1}='Var.       Name      p-value';
strmodel3{length(strmodel3)+1}=statC{indexS.scriptDreesData}.data_model_param{1};
statC{indexS.scriptDreesData}.data_model_param{2}='-----------------------------';
strmodel3{length(strmodel3)+1}=statC{indexS.scriptDreesData}.data_model_param{2};
for i=1:length(statC{indexS.scriptDreesData}.b)-1
    statC{indexS.scriptDreesData}.data_model_param{i+2}=sprintf('X%d %s     %0.2g',i,statC{indexS.scriptDreesData}.SelectedVariableNames{i},pval(i));
    strmodel3{length(strmodel3)+1}=statC{indexS.scriptDreesData}.data_model_param{i+2};
end

showinfowindow(strmodel3,'Results')
%set(stateS.model.paramList,'string',statC.data_model_param, 'fontname', 'courier new', 'fontsize',8);
