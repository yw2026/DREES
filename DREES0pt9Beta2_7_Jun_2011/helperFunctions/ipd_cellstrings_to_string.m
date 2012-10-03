function [string]= ipd_cellstrings_to_string(cell)
%  Display function
%  usage:
%  function []= ipd_display_results(cell)

string = [];

for i = 1:length(cell)
    string = [ string ' ' cell{i}];
end

