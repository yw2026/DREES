function extract_var(drees_filename,dvhName,cutoff,flag,type)

% Extract variables from a drees file
% written By J.H. Oh, 2012
%  
% Usage:  extract_var(drees_filename)
% drees_filename: drees format file
% dvhName: dvh name of interest
% cutoff: grade cutoff
% flag: greater than symbol(1 (>=cutoff), 0 (<=cutoff))
% type: 1 (NTCP), 0(TCP)

% example: extract_var('PneumonitisData_drees.mat','dvh_lung',2,1,1)

greater_than_flag_val=flag;
if type == 1
    model_type='NTCP';
else
    model_type='TCP';
end

global statC stateS
stateS.outcome_index = [];
statC = cell(1,4);
indexS.originalData       = 1;
indexS.dreesData          = 2;
indexS.scriptDreesData    = 3;
statC{end}                = indexS;

load(drees_filename);
% change dBase to ddbs
if exist('dBase')==1 & exist('ddbs')~=1
    statC{indexS.originalData} = dBase;
    clear dBase
else
    statC{indexS.originalData} = ddbs;
    clear ddbs
end

statC{indexS.dreesData} = createDREESdata(statC{indexS.originalData});

no_of_patients = length(statC{indexS.originalData});

arrayDxx = 5:5:100;
arrayVxx = 5:5:100;
arrayMOHxx = 5:5:100;
arrayMOCxx = 5:5:100;
arrayEUDxx = 1:1:10;

%get parameter names
fNames=fieldnames(statC{indexS.originalData}(1,1));

statC{indexS.scriptDreesData}.originlVariable=fNames;

if ~(length(dvhName) > 4 & strcmp(dvhName(1:4),'dvh_')==1)
   warning('Please input a correct DVH name.');
   return;
end
    
all_clinical_names={};
for i=1:length(fNames)
    if length(fNames{i}) > 4 & strcmp(fNames{i}(1:4),'dvh_')~=1
        all_clinical_names{length(all_clinical_names)+1}=fNames{i};
    elseif length(fNames{i}) <= 4
        all_clinical_names{length(all_clinical_names)+1}=fNames{i};
    end
end

[clinical_data,clinical_names,non_numeric_clinical_data,non_numeric_clinical_names]=extract_clinical(statC{indexS.originalData},all_clinical_names);
[dx,vx,mohx,mocx,geud,meandose,maxdose,mindose,outcome]=extract_dvh(statC{indexS.originalData}, dvhName, arrayDxx, arrayVxx, arrayMOHxx, arrayMOCxx, arrayEUDxx);


variable_names={};

idx=1;
for j=arrayDxx
    eval(sprintf('D%d_%s=dx(:,%d)',j,dvhName(5:end),idx));
    variable_names{length(variable_names)+1}=sprintf('D%d_%s',j,dvhName(5:end));
    
    idx=idx+1;
end


idx=1;
for j=arrayVxx
    eval(sprintf('V%d_%s=vx(:,%d)',j,dvhName(5:end),idx));
    variable_names{length(variable_names)+1}=sprintf('V%d_%s',j,dvhName(5:end));
    idx=idx+1;
end

idx=1;
for j=arrayMOHxx
    eval(sprintf('Moh%d_%s=mohx(:,%d)',j,dvhName(5:end),idx));
    variable_names{length(variable_names)+1}=sprintf('Moh%d_%s',j,dvhName(5:end));
    idx=idx+1;
end

idx=1;
for j=arrayMOCxx
    eval(sprintf('Moc%d_%s=mocx(:,%d)',j,dvhName(5:end),idx));
    variable_names{length(variable_names)+1}=sprintf('Moc%d_%s',j,dvhName(5:end));
    idx=idx+1;
end

idx=1;
for j=arrayEUDxx
    eval(sprintf('Geud%d_%s=geud(:,%d)',j,dvhName(5:end),idx));
    variable_names{length(variable_names)+1}=sprintf('Geud%d_%s',j,dvhName(5:end));
    idx=idx+1;
end

eval(sprintf('Meandose_%s=meandose',dvhName(5:end)));
variable_names{length(variable_names)+1}=sprintf('Meandose_%s',dvhName(5:end));
eval(sprintf('Maxdose_%s=maxdose',dvhName(5:end)));
variable_names{length(variable_names)+1}=sprintf('Maxdose_%s',dvhName(5:end));
eval(sprintf('Mindose_%s=mindose',dvhName(5:end)));
variable_names{length(variable_names)+1}=sprintf('Mindose_%s',dvhName(5:end));

clear dx vx mohx mocx geud meandose maxdose mindose


for i=1:no_of_patients
   sample_name{i}=sprintf('S%d', i);
end

%dosimetric data
for i=1:length(variable_names)
    val_temp=eval(sprintf('%s',variable_names{i}));
    %ds_temp=dataset(val_temp,'VarNames',variable_names{i});
    if i==1
        ds_temp=dataset(val_temp,'VarNames',variable_names{i},'ObsNames',sample_name);
        statC{indexS.scriptDreesData}.D_data=ds_temp;
    else
        ds_temp=dataset(val_temp,'VarNames',variable_names{i});
        statC{indexS.scriptDreesData}.D_data=cat(2,statC{indexS.scriptDreesData}.D_data,ds_temp);
    end
    eval(sprintf('clear %s',variable_names{i}));
end

%clinical data - numeric
for i=1:length(clinical_names)
    val_temp=clinical_data(:,i);
    ds_temp=dataset(val_temp,'VarNames',clinical_names{i});
    statC{indexS.scriptDreesData}.D_data=cat(2,statC{indexS.scriptDreesData}.D_data,ds_temp);
   
end

%clinical data - non-numeric
for i=1:length(non_numeric_clinical_names)
    val_temp=non_numeric_clinical_data(:,i);
    
    if i==1
        ds_temp=dataset(val_temp,'VarNames',non_numeric_clinical_names{i},'ObsNames',sample_name);
        statC{indexS.scriptDreesData}.D_nonnumeric_data=ds_temp;
    else
        ds_temp=dataset(val_temp,'VarNames',non_numeric_clinical_names{i});
        statC{indexS.scriptDreesData}.D_nonnumeric_data=cat(2,statC{indexS.scriptDreesData}.D_nonnumeric_data,ds_temp);
    end
   
end

statC{indexS.scriptDreesData}.D_variables=[variable_names clinical_names];
statC{indexS.scriptDreesData}.D_non_numeric_variables=non_numeric_clinical_names;
statC{indexS.scriptDreesData}.D_outcome_grade=outcome;

if greater_than_flag_val==1
    statC{indexS.scriptDreesData}.D_outcome_group = statC{indexS.scriptDreesData}.D_outcome_grade >=cutoff;
else
    statC{indexS.scriptDreesData}.D_outcome_group = statC{indexS.scriptDreesData}.D_outcome_grade <=cutoff;
end
statC{indexS.scriptDreesData}.D_grade_cutoff=cutoff;
statC{indexS.scriptDreesData}.D_greater_than_flag_val=greater_than_flag_val;
statC{indexS.scriptDreesData}.D_model_type=model_type;

for i=1:length(statC{indexS.scriptDreesData}.D_variables)
    statC{indexS.scriptDreesData}.D_variables{i}=strrep(statC{indexS.scriptDreesData}.D_variables{i},'_','-')
end

clear variable_names outcome ds_temp val_temp sample_name i j idx
clear arrayDxx arrayVxx arrayMOHxx arrayMOCxx arrayEUDxx dvhName

statC{indexS.scriptDreesData}.validObs=1:length(statC{indexS.originalData});  %%%%%%%%%%%%%%%%need to remove nan


