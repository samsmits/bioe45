%% multiHostAntiBio_kmeans
% built to run on the data gathered form multiHostAntiBio.m
%
% runs kmeans clustering on the GH profiles for the samples gathered from
% multiHostAntiBio.m
%% load data
load('multiHostAntiBio.mat');

%% get GH profiles for each category and establish group sizes
% category 1
week_ind = find(ismember(antiSelDup,'In the past week'));
week_samps = sampDup(week_ind);
week_agp_ind = find(ismember(agp_identifiers(:),week_samps(:)));
weekGH = agp_GHabundance(week_agp_ind,:);
% category 2
month_ind = find(ismember(antiSelDup,'In the past month'));
month_samps = sampDup(month_ind);
month_agp_ind = find(ismember(agp_identifiers(:),month_samps(:)));
monthGH = agp_GHabundance(month_agp_ind,:);
% category 3
month6_ind = find(ismember(antiSelDup,'In the past 6 months'));
month6_samps = sampDup(month6_ind);
month6_agp_ind = find(ismember(agp_identifiers(:),month6_samps(:)));
month6GH = agp_GHabundance(month6_agp_ind,:);
% category 4
year_ind = find(ismember(antiSelDup,'In the past year'));
year_samps = sampDup(year_ind);
year_agp_ind = find(ismember(agp_identifiers(:),year_samps(:)));
yearGH = agp_GHabundance(year_agp_ind,:);
% category 5
multiyear_ind = find(ismember(antiSelDup, 'Not in the last year'));
multiyear_samps = sampDup(multiyear_ind);
multiyear_agp_ind = find(ismember(agp_identifiers(:),multiyear_samps(:)));
multiyearGH = agp_GHabundance(multiyear_agp_ind,:);
% altogether now
allTimesGH = [weekGH; monthGH; month6GH; yearGH; multiyearGH];

% no 'In the past week' entries, so get rid of this to avoid errors later
groupSizes = [size(monthGH,1), size(month6GH,1), size(yearGH,1), size(multiyearGH,1)];


%% normalize the GH profiles
zGHmat = zscore(allTimesGH);
GHs = cell(4,1);
for i=1:4
    if i==1
        GHs{i} = zGHmat(1:groupSizes(i),:);
    else
        sizeOffset = sum(groupSizes(1:i-1));
        GHs{i} = zGHmat(1 + sum(groupSizes(1:i-1)) : sum(groupSizes(1:i-1)) + groupSizes(i), :);
    end
end
month_zGH = GHs{1};
month6_zGH = GHs{2};
year_zGH = GHs{3};
multiyear_zGH = GHs{4};

%% get subsamples

% establish subsample sizes
subSampSizes = zeros(1,length(groupSizes));
subSampSizes(1) = groupSizes(1);
subSampSizes(2:end) = round(normrnd(groupSizes(2)*2/3, groupSizes(2)/5, 1, 3));

% store subsample profiles
month_sub = month_zGH;
month6_sub = month6_zGH(randi(size(month6_zGH,1), 1, subSampSizes(2)), :);
year_sub = year_zGH(randi(size(year_zGH,1), 1, subSampSizes(3)), :);
multiyear_sub = multiyear_zGH(randi(size(multiyear_zGH,1), 1, subSampSizes(4)), :);
zGH_sub = [month_sub; month6_sub; year_sub; multiyear_sub];

%% run kmeans

% establish constants
c5Limit = 0; % control respondents allowed in cluster for sampleID aggregation
% consider creating another input for minimum number of data in cluster for sampleID aggregation
nClust = 9; % for kmeans
replicates = 4; % for kmeans
displayBarChart = 1; % 0 is hide, 1 is display
plotClusters = 0; % 0 is hide, 1 is display -- we can usually hide this

% actually run kmeans
[indices, centroids] = kmeans(zGH_sub, nClust, 'Replicates', replicates);

%% partition data into clusters

% one row for each category
clusterCounts = zeros(4, nClust);
clusteredSampleIDs = cell(4, nClust, 1); % 3rd dimension for more IDs
index = zeros(1,1);
for i = 1:nClust
    for j = 1:4
        % Avoids 0 index error
        if j == 1
            rows = 1:subSampSizes(j);
        else
            rows = 1 + sum(subSampSizes(1:j-1)) : sum(subSampSizes(1:j-1)) + subSampSizes(j);
        end
        % Finds number of elements from each metadata subset
        for row = rows(1:end)
            if ismember(zGH_sub(row, :), zGH_sub(indices == i, :), 'rows')
                clusterCounts(j, i) = clusterCounts(j, i) + 1;
            end
        end
    end
end

%% display bar chart of results
if displayBarChart
    bar(1:nClust, clusterCounts', 0.5, 'stack');
    xlabel('Clusters');
    ylabel('Number of elements per cluster');
    legend({'In the past month', 'In the past 6 months', 'In the past year', 'Not in the last year'}, 'Location', 'EastOutside');
    hold off;
end

%% plotting clusters
if plotClusters
    % subplot numbers would need to be updated to the number of clusters
    figure
    for i = 1:nClust % looping through number of clusters
        subplot(3,3,i);
        % Matrix is transposed so there is one row per GH and one column per
        % respondent, such that the length of the x-axis remains constant while
        % the number of lines is the number of respondents.
        plot(zGH_sub(indices == i, :)', 'MarkerSize', 12);
        ylim([min(min(zGH_sub)) max(max(zGH_sub))]);
        xlabel('GH identifier (1-117)');
        ylabel('GH Zscores');
        titleString = sprintf('Cluster %d', i);
        title(titleString);
    end
    suptitleString = sprintf('Kmeans clusters of GH abundances with %d replicates', replicates);
    suptitle(suptitleString)
    hold off;
end

%% aggregate kmeans trials

iterations = 24;
agClustCounts = zeros(4, nClust);

figHand = figure;
for q=1:iterations
    % establish subsample sizes
    subSampSizes = zeros(1,length(groupSizes));
    subSampSizes(1) = groupSizes(1);
    subSampSizes(2:end) = round(normrnd(groupSizes(2)*2/3, groupSizes(2)/5, 1, 3));
    % store subsample profiles
    month_sub = month_zGH;
    month6_sub = month6_zGH(randi(size(month6_zGH,1), 1, subSampSizes(2)), :);
    year_sub = year_zGH(randi(size(year_zGH,1), 1, subSampSizes(3)), :);
    multiyear_sub = multiyear_zGH(randi(size(multiyear_zGH,1), 1, subSampSizes(4)), :);
    zGH_sub = [month_sub; month6_sub; year_sub; multiyear_sub];
    % actually run kmeans
    [indices, centroids] = kmeans(zGH_sub, nClust, 'Replicates', replicates);
    % one row for each category
    clusterCounts = zeros(4, nClust);
    clusteredSampleIDs = cell(4, nClust, 1); % 3rd dimension for more IDs
    index = zeros(1,1);
    for i = 1:nClust
        for j = 1:4
            % Avoids 0 index error
            if j == 1
                rows = 1:subSampSizes(j);
            else
                rows = 1 + sum(subSampSizes(1:j-1)) : sum(subSampSizes(1:j-1)) + subSampSizes(j);
            end
            % Finds number of elements from each metadata subset
            for row = rows(1:end)
                if ismember(zGH_sub(row, :), zGH_sub(indices == i, :), 'rows')
                    clusterCounts(j, i) = clusterCounts(j, i) + 1;
                    agClustCounts(j, i) = agClustCounts(j, i) + 1/iterations;
                end
            end
        end
    end
    % display bar chart
    positionDiff = [];
    if displayBarChart
        sh = subplot(ceil(sqrt(iterations)), ceil(sqrt(iterations)), q);
        bar(1:nClust, clusterCounts', 0.5, 'stack');
        xlabel('Clusters');
        ylabel('Number of elements');
        %legend({'In the past month', 'In the past 6 months', 'In the past year', 'Not in the last year'}, 'Location', 'EastOutside');
        %hold off;
        
        %sh=subplot(2,2,2);
        %p=get(sh,'position');
        %lh=legend(sh,[ph1;ph2]);
        %set(lh,'position',p);
        %axis(sh,'off');
        if q > 1
            lastP = p;
            p = get(sh, 'position');
            positionDiff = p - lastP;
        else 
            p = get(sh, 'position');
        end
        if q == iterations
            %p = get(sh, 'position');
            lh = legend(sh, {'In the past month', 'In the past 6 months', 'In the past year', 'Not in the last year'});
            set(lh, 'position', p + positionDiff);
            %axis(sh, 'off');
        end
    end
end
m = mtit('K-means clustering shows lack of definition of clustering within time-series categories for hosts with multiple samples');
set(m.th, 'FontSize', 18);
set(figHand, 'PaperOrientation', 'landscape');
