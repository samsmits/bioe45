%% summaryStatsContinuous
% Takes in a fresh column of data, and converts each datum into a double (so
% that calculations can be run on them). Removes all instances where cells
% was not a valid number, to avoid running into any errors. If specified by
% the removeZeroes argument, the function will also remove all instances of
% 0's in the data. The program then finds the mean and variance of the
% data, and plots the data in a histogram.
% 
% input: 
% data - column of data, e.g. from getColumnData
% removeZeroes - set to true if the user wants to remove zeroes, and false
% if not
% dataName - used when labeling the titles of the graphs
% units - used when labeling the axes of the graphs

function [N, avg, variance] = summaryStatsContinuous(data, removeZeroes, dataName, units)
    if ~exist('dataName', 'var')
        dataName = 'UNPSECIFIED DATA';
    end
    if ~exist('units', 'var')
        units = 'UNSPECIFIED UNITS';
    end
    data = str2double(data);
    indNaN = isnan(data);
    data(indNaN) = [];
    if removeZeroes
        indZero = data == 0;
        data(indZero) = [];
    end
    N = size(data, 1);
    avg = mean(data);
    variance = var(data);
    
    a = subplot(3,1,1);
    hist(data);
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',[27 250 194]/250,'EdgeColor','w');
    b = subplot(3,1,2);
    bar(data, 1);
    c = subplot(3,1,3);
    boxplot(data, 'colors', [27 250 194]/250);
    
    set(gcf,'NextPlot','add');
    axes;
    title(a, strcat('Histogram of:    ',dataName));
    xlabel(a, units);
    ylabel(a, 'frequency');
    title(b, strcat('Bar Graph of:     ',dataName));
    xlabel(b, 'sample');
    ylabel(b, units);
    title(c, strcat('Boxplot of:     ',dataName));
    ylabel(c, units);
    set(gca,'Visible','off');
    set(h,'Visible','on');
    hold off;
end