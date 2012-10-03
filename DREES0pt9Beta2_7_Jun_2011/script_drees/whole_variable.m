function whole_variable

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

disp(sprintf('\n\nNon-numeric variable name'));
for i=1:length(statC{indexS.scriptDreesData}.D_non_numeric_variables)
    disp(sprintf('%s', statC{indexS.scriptDreesData}.D_non_numeric_variables{i}));
end


disp(sprintf('\n\nIndex\tVariable name'));
for i=1:length(statC{indexS.scriptDreesData}.D_variables)
    disp(sprintf('%d:\t%s', i,statC{indexS.scriptDreesData}.D_variables{i}));
end
