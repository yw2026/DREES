function prin_comp

%OHJ 07/26/2012, script-based DREES

global statC
indexS=statC{end};

if isempty(statC{indexS.scriptDreesData}.D_selected_indices) || length(statC{indexS.scriptDreesData}.D_selected_indices) < 2
    error_variable_selection
    return;
end


data=double(statC{indexS.scriptDreesData}.D_data(:,statC{indexS.scriptDreesData}.D_selected_indices));
%data=double(statC{indexS.scriptDreesData}.D_selected_data(:,statC{indexS.scriptDreesData}.D_selected_indices));

[pc,score,latent,tsquare] = princomp(data);
figure;
hold on;
scatter(score(statC{indexS.scriptDreesData}.D_outcome_group,1),score(statC{indexS.scriptDreesData}.D_outcome_group,2),'r');
scatter(score(~statC{indexS.scriptDreesData}.D_outcome_group,1),score(~statC{indexS.scriptDreesData}.D_outcome_group,2),'b');

title('Principle component analysis','fontSize',14);
set(gcf,'color',[1 1 1]);
xlabel('First principle component','fontSize',14);
ylabel('Second principle component','fontSize',14);
legend('Toxicity','Non-toxicity');
box on;
hold off;