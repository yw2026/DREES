function callWeka()
%function callWeka()
%
%JOH, APA, 01/06/2010
%
% Copyright 2010, Joseph O. Deasy, on behalf of the DREES development team.
% 
% This file is part of the Dose Response Explorer System (DREES).
% 
% DREES development has been led by:  Issam El Naqa, Aditya Apte, Gita Suneja, and Joseph O. Deasy.
% 
% DREES has been financially supported by the US National Institutes of Health under multiple grants.
% 
% DREES is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of DREES is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% DREES is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with DREES.  If not, see <http://www.gnu.org/licenses/>.

global statC stateS
indexS = statC{end};

%Each column in Xdata represents a covariate.
%Each row in Xdata represents a sample.
greater_than_flag_val = get(stateS.processData.endptSign,'value');
if greater_than_flag_val==1
    y = statC{indexS.dreesData}.outcome(:) >= str2num(get(stateS.processData.endptSel,'String'));
else
    y = statC{indexS.dreesData}.outcome(:) <= str2num(get(stateS.processData.endptSel,'String'));
end
Xdata = [statC{indexS.dreesData}.dataX, y];

%Variable names
varNameC = statC{indexS.dreesData}.SelectedVariableNames;

%Create .arff file using Xdata

%Save .arff file under Weka directory

% pop-up message telling user about the location of .arff file

%Get DREES path
dreesPath = fileparts(which('DREES.m'));

% %Open Weka GUI
% Xdata = rand(50,4);
% Xdata = [Xdata Xdata(:,1).^0];

%Weka Format
fileName='temp.arff';
fileName = fullfile(dreesPath,'Weka',fileName);
fid_prep = fopen(fileName,'w');

str='@RELATION DATA';
fprintf(fid_prep,'%s\n',str);

str='@ATTRIBUTE';
for i=1:size(Xdata,2)-1
    fprintf(fid_prep,'%s %s REAL\n',str,varNameC{i});
end

str='@ATTRIBUTE class {1, 0}';
fprintf(fid_prep,'%s\n',str);

str='@DATA';
fprintf(fid_prep,'%s\n',str);

for i=1:size(Xdata,1)
    for j=1:size(Xdata,2)-1
        fprintf(fid_prep,'%6.4f,',Xdata(i,j));
    end
    fprintf(fid_prep,'%d\n',Xdata(i,end));
end
fclose(fid_prep);

pause(0.5);
if ispc
    str = ['java -cp "',dreesPath,'\Weka\Win\weka.jar" weka.gui.explorer.Explorer "' fileName, '"'];
else
    str = ['java -cp "',dreesPath,'/Weka/Linux/weka.jar" weka.gui.explorer.Explorer "' fileName, '"'];
end
system(str);
