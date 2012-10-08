function comm_drees(varagrin)

%OHJ 07/26/2012, script-based DREES

command_name={'automated_logistic',...
'manual_logistic',...
'select_variable',...
'extract_var',...
'seq_feature_selection',...
'scatterPlot_S',...
'prin_comp',...
'plotSelfCorrelation_S',...
'opt_cutoffPlot_S',...
'matrixPlot_S',...
'k_means',...
'imageGT_S',...
'hier_clustering',...
'boxPlot_S',...
'actuarialPlot_S',...
'rocPlot_S',...
'prcrPlot_S',...
'octilePlot_S',...
'nomogramPlot_S',...
'contourPlot_S',...
'bootstrapPlot_S',...
'whole_variable'
};

if nargin==0 || strcmp(varagrin,'-help')==1 
    disp(' ');
    disp(' ');
    disp('------------------------------------------');
    disp('TCP or NTCP modeling');
    disp(['1. ', command_name{1}]);
    disp(['2. ', command_name{2}]);
    disp(['3. ', command_name{3}]);
    disp(['4. ', command_name{4}]);
    
    disp('------------------------------------------');
    disp('Data analysis without TCP or NTCP modeling');
    disp(['5. ', command_name{5}]);
    disp(['6. ', command_name{6}]);
    disp(['7. ', command_name{7}]);
    disp(['8. ', command_name{8}]);
    disp(['9. ', command_name{9}]);
    disp(['10. ', command_name{10}]);
    disp(['11. ', command_name{11}]);
    disp(['12. ', command_name{12}]);
    disp(['13. ', command_name{13}]);
    disp(['14. ', command_name{14}]);
    disp(['15. ', command_name{15}]);
    
    disp('------------------------------------------');
    disp('Data analysis after TCP or NTCP modeling');
    disp(['16. ', command_name{16}]);
    disp(['17. ', command_name{17}]);
    %disp(['18. ', command_name{18}]);
    disp(['18. ', command_name{18}]);
    disp(['19. ', command_name{19}]);
    disp(['20. ', command_name{20}]);
    disp(['21. ', command_name{21}]);
    
    disp('------------------------------------------');
    disp('Other commands');
    disp(['22. ', command_name{22}]);
    disp(' ');
    disp('USAGE: >> comm_drees(command number)');
    disp(' ');
elseif isnumeric(varagrin)
    eval(sprintf('%s',command_name{varagrin}))
end