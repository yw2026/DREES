function [numeric_clinical_data,numeric_clinical_names,non_numeric_clinical_data,non_numeric_clinical_names] = extract_clinical(dBase,clinical_name)

%OHJ 07/26/2012, script-based DREES

numeric_clinical_data=[];
numeric_clinical_names={};
non_numeric_clinical_data={};
non_numeric_clinical_names={};

%check if the variable is numeric with the first sample
numeric_flag=[];
for i = 1:length(clinical_name) 
    var = dBase(1).(clinical_name{i});
    if isnumeric(var)==1
        numeric_flag(i)=1;
    else
        if length(var) > 0 & length(str2num(var))==1 %'11' type
            numeric_flag(i)=2;
        else
            numeric_flag(i)=0;
        end
    end
end

numeric_clinical_names=clinical_name(find(numeric_flag>=1));
non_numeric_clinical_names=clinical_name(find(numeric_flag==0));

idx_numeric=0;
idx_non_numeric=0;
for i = 1:length(clinical_name) 
    if numeric_flag(i)==1 | numeric_flag(i)==2
        idx_numeric=idx_numeric+1;
    else
        idx_non_numeric=idx_non_numeric+1;
    end
     for j = 1:length(dBase) 
        var = dBase(j).(clinical_name{i});
        if numeric_flag(i)==1
            if length(var)~=0
               numeric_clinical_data(idx_numeric,j)= var;
            else
                numeric_clinical_data(idx_numeric,j)= NaN;
            end
        elseif numeric_flag(i)==2
            if length(str2num(var))==1 
               numeric_clinical_data(idx_numeric,j)= str2num(var);
            else
                numeric_clinical_data(idx_numeric,j)= NaN;
            end
        else
            if length(var)~=0
                non_numeric_clinical_data{idx_non_numeric,j}= var;
            else
                nnon_umeric_clinical_data{idx_non_numeric,j}= '';
            end
        end
     end
end
numeric_clinical_data=numeric_clinical_data';
non_numeric_clinical_data=non_numeric_clinical_data';