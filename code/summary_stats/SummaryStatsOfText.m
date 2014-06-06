function SummaryStatsOfText( metadata, categories, visible, save, ...
    fullscreen, tickUp )
% This function loops through categories inputted and creates bar charts.
% metadata is a file passed in, categories can be one or more categories
% saved as an array of strings, while visible, save and fulscreen must be
% 'on' or 'off'
for i=1:length(categories) % loops to create separate bar charts
    f = figure('Visible', visible);
    column = strmatch(categories{i}, metadata(1,:), 'exact');
    uppercaseData = metadata(2:end,column); % to avoid case inconsistencies
    [u,~,n] = unique(uppercaseData);
    n(n==1) = []; % removes blank entries
    n = n - 1; % adjusts answers because blank entries have been removed
    u = u(2:end); % removes blank category
    B = histc(n,1:max(n));
    bar(B)
    set(gca,'XTickLabel',u(:))
    title(categories{i})
    
    % fullscreen
    if strcmp(fullscreen, 'on')
        set(figure(i),'Units','Normalized','OuterPosition',[0 0 1 1])
    end
    
    % moves labels upwards by a certain number of pixels (may move labels into
    % figure), but at least prevents long labels from hanging off the bottom of
    % the figure
    xlabh = get(gca,'XLabel');
    
    set(xlabh,'Position',get(xlabh,'Position') + [0 tickUp 0])
    
    % rotates xtick labels 90 degrees to avoid label overlap
    % charts with too many labels will not rotate to avoid display errors
    if length(u) <= 15
        XTickLabel = get(gca,'XTickLabel');
        set(gca,'XTickLabel',' ');
        hxLabel = get(gca,'XLabel');
        set(hxLabel,'Units','data');
        xLabelPosition = get(hxLabel,'Position');
        y = xLabelPosition(2);
        XTick = get(gca,'XTick');
        y=repmat(y,length(XTick),1);
        fs = get(gca,'fontsize');
        hText = text(XTick, y, XTickLabel,'fontsize',fs);
        set(hText,'Rotation',90,'HorizontalAlignment','right');
    end
    
    if strcmp(save,'on')
        filename = sprintf('bar-%d',i);
        print('-dpdf', filename);
    end
end
end