function plotSelfCorrelation_S

%OHJ 07/26/2012, script-based DREES

% global statC
% indexS=handles{end};
% set(hAxis,'position',[0.2 0.2 0.7 0.7])

global statC
indexS=statC{end};

f = figure
hAxis = axes('position',[0.2 0.2 0.7 0.7],'parent', f)

xt=[statC{indexS.scriptDreesData}.D_outcome_grade',double(statC{indexS.scriptDreesData}.D_data(:,statC{indexS.scriptDreesData}.D_selected_indices))];
lx=size(xt,2);
for i=1:lx
    for j=1:lx
        [rs(i,j),prob(i,j)] = spearman(xt(:,i),xt(:,j));
    end
end
variables{1} = statC{indexS.scriptDreesData}.D_model_type;

data=statC{indexS.scriptDreesData}.D_data(:,statC{indexS.scriptDreesData}.D_selected_indices);
labels = data.Properties.VarNames;


for i=2:lx
    variables{i}=labels{i-1};
    
end
for i=1:length(rs)
    rs(i,i) = NaN;
    for j=i:lx
        rs(i,j) = NaN;
    end    
end

imagesc(abs(rs));

set(hAxis,'nextPlot','add')
for i=1:lx
    for j=i:lx
        yV = [i-0.5 i-0.5 i+0.5 i+0.5 i-0.5];
        xV = [j-0.5 j+0.5 j+0.5 j-0.5 j-0.5];
        patch(xV,yV,'w','parent',hAxis,'EdgeColor','w')
    end    
    for j=1:i
        if sign(rs(i,j))==-1
            yV = [i-0.5 i-0.5 i+0.5 i+0.5 i-0.5];
            xV = [j-0.5 j+0.5 j+0.5 j-0.5 j-0.5];
            plot(xV,yV,'k--','linewidth',3,'parent',hAxis)
        end
    end
end
axis(hAxis,'image')
colormap(hAxis,'jet');
colorbar('peer',hAxis);

set(hAxis,'Ytick',[1:size(rs,2)])
set(hAxis,'YtickLabel',variables);
if length(variables) < 6
    rot = 25;
else
    rot = 90;
end
for i=1:length(variables)    
    text(i,length(variables)+0.8,variables{i},'Rotation',rot,'parent',hAxis,'horizontalAlignment','right','fontSize',10,'interpreter','none')
end
set(hAxis,'XtickLabel','')
set(hAxis,'visible','on')
return
