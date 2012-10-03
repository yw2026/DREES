function hAxis = plot_actuarial_survival(hAxis,x,bp,cens,time,xname)
%function hAxis = plot_actuarial_survival(hAxis,x,bp)
%
%This function plots the actuarial survival plots on the passed axis.
%INPUT:
%     hAxis
%     x
%     bp
%     cens
%     time
%     xname
%OUTPUT
%     hAxis
%
%APA 10/11/2006, extracted from DREES_GUI
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

if ~isempty(bp)
    x_ind=x>bp;
    ts=time(x_ind);
    cs=cens(x_ind);
    tm=time(~x_ind);
    cm=cens(~x_ind);
    [fs,xs]= drxlr_surv_rate(ts,cs);
    [fm,xm] = drxlr_surv_rate(tm,cm);
    p=drxlr_logrank(ts,cs,tm,cm);
    [xxs,yys] = stairs(xs,fs,'k-');
    [xxm,yym] = stairs(xm,fm,'k:');
    plot(xxs,yys,'color',[0 0 0],'parent',hAxis,'linewidth',2,'linestyle','-')
    plot(xxm,yym,'color',[0 0 0],'parent',hAxis,'linewidth',2,'linestyle',':')    
    xlabel('Time (days)')
    ylabel('Survival rate')
    % legend(hAxis,[xname,'>',num2str(bp)],[xname,'<=',num2str(bp)])
    str=['p=',num2str(p)];
    text(max(mean(xs),mean(xm)),0.5,str,'Color','k','parent',hAxis,'interpreter','none');
else
    [f,x]= drxlr_surv_rate(time,cens);
    [xx,yy] = stairs(x,f);
    plot(xx,yy,'color',[0 0 0],'parent',hAxis,'linewidth',2,'linestyle','-')
    xlabel('Time (days)')
    ylabel('Survival rate')
end
