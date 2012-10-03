function hout=boxplot(x,varargin)
%BOXPLOT Display boxplots of a data sample.
% This is modified from Matlab
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

whissw = 0; % don't plot whisker inside the box.

if isvector(x)
   % Might have one box, or might have a grouping variable. n will be properly
   % set later for the latter.
   x = x(:);
   n = 1; %
else
   % Have a data matrix, use as many boxes as columns.
   n = size(x,2);
end

% Detect if there is a grouping variable by looking at the second input
nargs = nargin;
if nargin < 2
   g = [];
else
   g = varargin{1};
   if isempty(g) || isequal(g,1) || isequal(g,0) || (ischar(g) && size(g,1)==1)
      % It's a NOTCH value or a parameter name
      g = [];
   else
      % It's a grouping variable
      if ~isvector(x)
         error('stats:boxplot:VectorRequired',...
               'X must be a vector when there is a grouping variable.');
      end
      varargin(1) = [];
      nargs = nargin - 1;
   end
end

% Set defaults
notch  = 0;
sym    = 'r+';
vert   = 1;
whis   = 1.5;
labels = {};
colors = []; % default is blue box, red median, black whiskers
posns  =1:n;
widths = 0.5; % default is 0.5, smaller for three or fewer boxes
order  = 1:n;






if isempty(widths)
   widths = repmat(min(0.15*n,0.5),n,1);
elseif ~isvector(widths) || ~isnumeric(widths) || any(widths<=0)
   error('stats:boxplot:BadWidths', ...
         'The ''widths'' parameter value must be a numeric vector of positive values.');
elseif length(widths) < n
   % Recycle the widths if necessary.
   widths = repmat(widths(:),ceil(n/length(widths)),1);
end

if isempty(colors)
   % Empty colors tells boxutil to use defaults.
   colors = char(zeros(n,0));
elseif ischar(colors) && isvector(colors)
   colors = colors(:); % color spec string, make it a column
elseif isnumeric(colors) && (ndims(colors)==2) && (size(colors,2)==3)
   % RGB matrix, that's ok
else
   error('stats:boxplot:BadColors',...
         'The ''colors'' parameter value must be a string or a three-column numeric matrix.');
end
if size(colors,1) < n
   % Recycle the colors if necessary.
   colors = repmat(colors,ceil(n/size(colors,1)),1);
end

if isempty(posns)
   posns = 1:n;
elseif ~isvector(posns) || ~isnumeric(posns)
   error('stats:boxplot:BadPositions', ...
         'The ''positions'' parameter value must be a numeric vector.');
elseif length(posns) ~= n
   % Must have one position for each box
   error('stats:boxplot:BadPositions', ...
         'The ''positions'' parameter value must have one element for each box.');
else
   if isempty(g) && isempty(labels)
      % If we have matrix data and the positions are not 1:n, we need to
      % force the default 1:n tick labels.
      labels = cellstr(num2str((1:n)'));
   end
end

%
% Done processing inputs
%

% Put at least the widest box or half narrowest spacing at each margin
if n > 1
    wmax = max(max(widths), 0.5*min(diff(posns)));
else
    wmax = 0.5;
end
xlims = [min(posns)-wmax, max(posns)+wmax];

ymin = nanmin(x(:));
ymax = nanmax(x(:));
if ymax > ymin
   dy = (ymax-ymin)/20;
else
   dy = 0.5;  % no data range, just use a y axis range of 1
end
ylims = [(ymin-dy) (ymax+dy)];

% Scale axis for vertical or horizontal boxes.
newplot
oldstate = get(gca,'NextPlot');
set(gca,'NextPlot','add','Box','on');
if isempty(xlims)
    xlims = [0 1];
end
if isempty(ylims)
    ylims = [0 1];
end
if vert
    axis([xlims ylims]);
    set(gca,'XTick',posns,'Units','normalized');
    drawnow;
    setappdata(gca,'NormalizedOuterPosition',get(gca,'OuterPosition'));
    ylabel(gca,'Values');
    if dfltLabs, xlabel(gca, 'Column Number'); end
else
    axis([ylims xlims]);
    set(gca,'YTick',posns);
    xlabel(gca,'Values');
    if dfltLabs, ylabel(gca,'Column Number'); end
end
if nargout>0
   hout = [];
end

xvisible = NaN(size(x));
notnans = ~isnan(x);
for i= 1:n
   if ~isempty(g)
      thisgrp = find((g==i) & notnans);
   else
      thisgrp = find(notnans(:,i)) + (i-1)*size(x,1);
   end
   [outliers,hh] = boxutil(x(thisgrp),notch,posns(i),widths(i), ...
                           colors(i,:),sym,vert,whis,whissw);
   outliers = thisgrp(outliers);
   xvisible(outliers) = x(outliers);
   if nargout>0
      hout = [hout, hh(:)];
   end
end

if ~isempty(labels)
   if multiline && vert
      % Turn off tick labels and axis label
      set(gca, 'XTickLabel','');
      setappdata(gca,'NLines',size(gname,2));
      xlabel(gca,'');
      ylim = get(gca, 'YLim');
      
      % Place multi-line text approximately where tick labels belong
      ypos = repmat(ylim(1),size(posns));
      text(posns,ypos,labels,'HorizontalAlignment','center', ...
                             'VerticalAlignment','top', 'UserData','xtick');

      % Resize function will position text more accurately
      set(gcf, 'ResizeFcn', @resizefcn, ...
               'Interruptible','off', 'PaperPositionMode','auto');
      resizefcn(gcf);
   elseif vert
      set(gca, 'XTickLabel',labels);
   else
      set(gca, 'YTickLabel',labels);
   end
end
set(gca,'NextPlot',oldstate);

% Store information for gname function
set(gca, 'UserData', {'boxplot' xvisible g vert});


%=============================================================================

function [outlier,hout] = boxutil(x,notch,lb,lf,clr,sym,vert,whis,whissw)
%BOXUTIL Produces a single box plot.

% define the median and the quantiles
pctiles = prctile(x,[25;50;75]);
q1 = pctiles(1,:);
med = pctiles(2,:);
q3 = pctiles(3,:);

% find the extreme values (to determine where whiskers appear)
vhi = q3+whis*(q3-q1);
upadj = max(x(x<=vhi));
if (isempty(upadj)), upadj = q3; end

vlo = q1-whis*(q3-q1);
loadj = min(x(x>=vlo));
if (isempty(loadj)), loadj = q1; end

x1 = repmat(lb,1,2);
x2 = x1+[-0.25*lf,0.25*lf];
outlier = x<loadj | x > upadj;
yy = x(outlier);

xx = repmat(lb,1,length(yy));
lbp = lb + 0.5*lf;
lbm = lb - 0.5*lf;

if whissw == 0
   upadj = max(upadj,q3);
   loadj = min(loadj,q1);
end

% Set up (X,Y) data for notches if desired.
if ~notch
    xx2 = [lbm lbp lbp lbm lbm];
    yy2 = [q3 q3 q1 q1 q3];
    xx3 = [lbm lbp];
else
    n1 = med + 1.57*(q3-q1)/sqrt(length(x));
    n2 = med - 1.57*(q3-q1)/sqrt(length(x));
    if n1>q3, n1 = q3; end
    if n2<q1, n2 = q1; end
    lnm = lb-0.25*lf;
    lnp = lb+0.25*lf;
    xx2 = [lnm lbm lbm lbp lbp lnp lbp lbp lbm lbm lnm];
    yy2 = [med n1 q3 q3 n1 med n2 q1 q1 n2 med];
    xx3 = [lnm lnp];
end
yy3 = [med med];

    
% Determine if the boxes are vertical or horizontal.
% The difference is the choice of x and y in the plot command.
if vert
    hout = plot(x1,[q3 upadj],'k--', x1,[loadj q1],'k--',...
                x2,[upadj upadj],'k-', x2,[loadj loadj],'k-', ...
                xx2,yy2,'b-', xx3,yy3,'r-', xx,yy,sym);
else
    hout = plot([q3 upadj],x1,'k--', [loadj q1],x1,'k--',...
                [upadj upadj],x2,'k-', [loadj loadj],x2,'k-', ...
                yy2,xx2,'b-', yy3,xx3,'r-', yy,xx,sym);
end

% If there's a color given, show everything in that color.  If the outlier
% symbol has a color in it, leave those alone.
if ~isempty(clr)
   if any(ismember(sym,'bgrcmyk'))
      set(hout(1:6),'Color',clr);
   else
      set(hout,'Color',clr);
   end
end

set(hout(1),'Tag','Upper Whisker');
set(hout(2),'Tag','Lower Whisker');
set(hout(3),'Tag','Upper Adjacent Value');
set(hout(4),'Tag','Lower Adjacent Value');
set(hout(5),'Tag','Box');
set(hout(6),'Tag','Median');
if length(hout)>=7
   set(hout(7),'Tag','Outliers');
else
   hout(7) = NaN;
end


%=============================================================================

function resizefcn(f,dum)

% Adjust figure layout to make sure labels remain visible
h = findobj(f, 'UserData','xtick');
if (isempty(h))
   set(f, 'ResizeFcn', '');
   return;
end

% Loop over all axes
allax = findall(f,'Type','Axes');
for j=1:length(allax)
    ax = allax(j);
    nlines = getappdata(ax, 'NLines');
    
    if ~isempty(nlines)
        % Try to retain the original normalized outer position
        nop = getappdata(ax,'NormalizedOuterPosition');
        set(ax,'Units','normalized');
        if isempty(nop)
            nop = get(ax,'OuterPosition');
        end
        set(ax,'OuterPosition',nop);
        
        % Adjust position so the fake X tick labels have room to display
        temp = hgconvertunits(f,[0 0 1 1],'character','normalized',f);
        charheight = temp(4);
        li = get(ax,'LooseInset');
        tickheight = min((nlines+1)*charheight, nop(4)/2);
        p = [nop(1)+li(1)*nop(3),    nop(2)+tickheight, ...
             nop(3)*(1-li(1)-li(3)), nop(4)*(1-li(4))-tickheight];
        p = max(p,0.0001);
        set(ax, 'Position', p);
        
        % The following lines do not change the position, but they leave
        % the axes in a state such that MATLAB will try to preserve the
        % outerposition rather than the ordinary position
        op = get(ax,'OuterPosition');
        set(ax, 'OuterPosition', op);
    end
end


% Position the labels at the proper place
xl = get(ax, 'XLabel');
set(xl, 'Units', 'data');
p = get(xl, 'Position');
ylim = get(ax, 'YLim');
p2 = (p(2)+ylim(1))/2;
for j=1:length(h)
   p = get(h(j), 'Position') ;
   p(2) = p2;
   set(h(j), 'Position', p);
end
