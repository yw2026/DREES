function percentNotConverged = drxlr_writeConvergHistToFile(convergeState,filename)
% function percentNotConverged = drxlr_writeConvergHistToFile(filename,convergeState)
% 
% This function writes the convergence history to a file.
% INPUT:
%     convergeState - convergence History cell array
%     filename (optional) - specify the fileName to write convergence history to. It
%       may include path as well. If only file name is specified, the file is
%       written to current working directory. If not specified, history is
%       not written to file.
% OUTPUT:
%     percentNotConverged - percentage of samples that did not converge
%
% APA 7/19/2006
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

if exist('filename')
    writeFlag = 1;
else
    writeFlag = 0;
end

FileStr{1} = ['Newton Ralphson Convergence history ',date,'\n'];
FileStr{2} = ['   ============= Summary ========= \n'];
FileStr{3} = [' Percent Samples did not Converge. \n'];
FileStr{4} = ['\n'];

convStr = {'Converged','Not Converged'};
for b=1:length(convergeState)
    sampleNotConverged = 0; % assume sample converged
    FileStr{end+1} = ['Sample # ',num2str(b),'\n'];
    for i=1:size(convergeState{b},1)-1
        FileStr{end+1} = ['   Var # ',num2str(i),'\n'];
        for j=i:size(convergeState{b},2)
            if ~isempty(convergeState{b}{i,j})
                sampleNotConverged = sampleNotConverged | convergeState{b}{i,j}(1)-1;
                FileStr{end+1} = ['      Var # ',num2str(j),' ',convStr{convergeState{b}{i,j}(1)},' in ', num2str(convergeState{b}{i,j}(2)), ' iterations with criteria ',num2str(convergeState{b}{i,j}(3)),'\n'];
            end
        end
    end
    samplesNotConvergedV(b) = sampleNotConverged;
end

percentNotConverged = sum(samplesNotConvergedV)/length(samplesNotConvergedV)*100;

disp('========================================')
if percentNotConverged > 0    
    disp([num2str(percentNotConverged),'% samples did not converge.'])
    disp('Please relax the tolerance or increase number of iterations')
    warndlg([num2str(percentNotConverged), '% Bootstrap samples did not converge. Click OK to proceed.'],'Bootstrap Warning','modal')
else
    disp('All samples converged.')
end
disp('========================================')

% write history to file if writeFlag=1
if writeFlag
    try
        delete(filename)
    end
    fid = fopen(filename,'w');
    FileStr{3} = ['   ',num2str(percentNotConverged),' percent samples did not converge. \n'];
    for i = 1:length(FileStr) 
        fprintf(fid,FileStr{i});
    end
    fclose(fid);
end
