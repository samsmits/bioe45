% This script performs Kmeans clustering of GH scores for comparison to 
% antibiotic history groups in the metadata. The usual output is a stacked
% bar chart that shows how subsampled data is clustered but the clusters
% themselves may also be plotted with GHs 1-117 on the x-axis, zscores on
% the y-axis, and the lines corresponding to respondents. PCA can also be
% performed on the centroids of clusters. The while loops allows this
% program to identify "interesting" clusters across runs and store
% associated sample IDs. What constitutes an interesting cluster is
% determined by c5Limit and stringent.

clc
close all
clear all
load('Antibiotic_group_data.mat'); % access GH data

% Important constants
whileLoops = 1;
stringent = 2; % minimum cluster size for sampleID aggregation
c5Limit = 0; % control respondents allowed in cluster for sampleID aggregation
% consider creating another input for minimum number of data in cluster for sampleID aggregation
clusters = 5; % for kmeans
replicates = 10; % for kmeans
displayBarChart = 1; % 0 is hide, 1 is display
pcaCentroids = 1; % 0 is hide, 1 is display
plotClusters = 0; % 0 is hide, 1 is display -- we can usually hide this

clusteredSampleIDs = cell(whileLoops, 5, 5, 1); %whileCount, 5, clusters, 1 % 3rd dimension for more IDs

% Stores sample IDs of GH data that clustered to exclude control data
usefulSampleIDs = cell(0, 1);
UniqueSampleIDs = cell(0, 1);

% Everything runs until usefulSampleIDs is complete i.e. no growth from run to run
whileCount = 0;
lastLength = -1;

temp = cellstr(agp_sampleID);
tempw = temp(Index_antibiotic_week);
tempm = temp(Index_antibiotic_month);
tempsm = temp(Index_antibiotic_6month);
tempy = temp(Index_antibiotic_year);
tempmy = temp(Index_antibiotic_multipleyear);
temp_new = [tempw; tempm; tempsm; tempy; tempmy];


while (length(UniqueSampleIDs) ~= lastLength || whileCount < whileLoops) && whileCount < 100
    if length(UniqueSampleIDs) > 0
        lastLength = length(UniqueSampleIDs)
    else
        lastLength = -1;
    end
    whileCount = whileCount + 1

%% Storing sample IDs
allSampleIDs = cellstr(agp_sampleID);
SampleID_GHprofile_week = allSampleIDs(Index_antibiotic_week);
SampleID_GHprofile_month = allSampleIDs(Index_antibiotic_month);
SampleID_GHprofile_6month = allSampleIDs(Index_antibiotic_6month);
SampleID_GHprofile_year = allSampleIDs(Index_antibiotic_year);
SampleID_GHprofile_multipleyear = allSampleIDs(Index_antibiotic_multipleyear);

%% Creating subsets of samples

% Creates random subsamples of randomized size, normalized to the smallest
% metadata group
metadataGroupSizes = [37, 59, 255, 262, 1422];
subSampleSizes = zeros(1, length(metadataGroupSizes));
subSampleSizes(1) = min(metadataGroupSizes);
subSampleSizes(2:end) = round(normrnd(min(metadataGroupSizes), min(metadataGroupSizes)/10, 1, 4));

%% Creating clusters
% Concatenates GH abundances from those who took antibiotics at different
% times

% Concatenation of all GHs
allGHsConcatenated = [GHprofile_antibiotic_week; ...
    GHprofile_antibiotic_month; GHprofile_antibiotic_6month; ...
    GHprofile_antibiotic_year; GHprofile_antibiotic_multipleyear];

% Normalizes GH abundances by column
zscoreAllGHsConcatenated = zscore(allGHsConcatenated);
%%
GHs = cell(5,1);
for i = 1:5
        % Avoids 0 index error
        if i == 1
            GHs{i} = zscoreAllGHsConcatenated(1:metadataGroupSizes(i),:);
        else
            GHs{i} = zscoreAllGHsConcatenated(1 + sum(metadataGroupSizes(1:i-1)) : sum(metadataGroupSizes(1:i-1)) + metadataGroupSizes(i), :);
        end
end
%%
GHprofile_antibiotic_week = GHs{1};%zscoreAllGHsConcatenated(1:metadataGroupSizes(1), :);
GHprofile_antibiotic_month = GHs{2};% zscoreAllGHsConcatenated(1+metadataGroupSizes(1):metadataGroupSizes(1)+metadataGroupSizes(2), :);
GHprofile_antibiotic_6month = GHs{3};%zscoreAllGHsConcatenated(1+metadataGroupSizes(2):metadataGroupSizes(2)+metadataGroupSizes(3), :);
GHprofile_antibiotic_year = GHs{4};%zscoreAllGHsConcatenated(1+metadataGroupSizes(3):metadataGroupSizes(3)+metadataGroupSizes(4), :);
GHprofile_antibiotic_multipleyear = GHs{5};%zscoreAllGHsConcatenated(1+metadataGroupSizes(4):metadataGroupSizes(4)+metadataGroupSizes(5), :);

weekSubSample = GHprofile_antibiotic_week;
monthSubSampleIndices = randi(length(GHprofile_antibiotic_month(:, 1)), 1, subSampleSizes(2)); %randsample(1:length(GHprofile_antibiotic_month(:, 1)), subSampleSizes(2));
sixmonthSubSampleIndices = randi(length(GHprofile_antibiotic_6month(:, 1)), 1, subSampleSizes(3)); %randsample(1:length(GHprofile_antibiotic_6month(:, 1)), subSampleSizes(3));
yearSubSampleIndices = randi(length(GHprofile_antibiotic_year(:, 1)), 1, subSampleSizes(4)); %randsample(1:length(GHprofile_antibiotic_year(:, 1)), subSampleSizes(4));
multipleyearSubSampleIndices = randi(length(GHprofile_antibiotic_multipleyear(:, 1)), 1, subSampleSizes(5)); %randsample(1:length(GHprofile_antibiotic_multipleyear(:, 1)), subSampleSizes(5));

monthSubSample = GHprofile_antibiotic_month(monthSubSampleIndices, :);
sixmonthSubSample = GHprofile_antibiotic_6month(sixmonthSubSampleIndices, :);
yearSubSample = GHprofile_antibiotic_year(yearSubSampleIndices, :);
multipleyearSubSample = GHprofile_antibiotic_multipleyear(multipleyearSubSampleIndices, :);

% Concatenation of subsamples
zscoresGHsConcatenated = [weekSubSample; monthSubSample; sixmonthSubSample; yearSubSample; ...
   multipleyearSubSample];

%% Not subsampling

% subSampleSizes = [37, 59, 255, 262, 1422];
%  GHsConcatenated = [GHprofile_antibiotic_week; ...
%     GHprofile_antibiotic_month; GHprofile_antibiotic_6month; ...
%     GHprofile_antibiotic_year; GHprofile_antibiotic_multipleyear];


%%

% Running kmeans
[indices, centroids] = kmeans(zscoresGHsConcatenated, clusters, 'Replicates', replicates);

%% Creating stacked bar chart
% clusterCounts rows are metadata groups, columns are determined clusters
clusterCounts = zeros(5, clusters);

for i = 1:clusters
    for j = 1:5
        % Avoids 0 index error
        if j == 1
            rows = 1:subSampleSizes(j);
        else
            rows = 1 + sum(subSampleSizes(1:j-1)) : sum(subSampleSizes(1:j-1)) + subSampleSizes(j);
        end
        % Finds number of elements from each metadata subset
        for row = rows(1:end)
            if ismember(zscoresGHsConcatenated(row, :), zscoresGHsConcatenated(indices == i, :), 'rows')
                clusterCounts(j, i) = clusterCounts(j, i) + 1;
                
                % Finds index of GH profile in larger dataset
                diff = zscoreAllGHsConcatenated-repmat(zscoresGHsConcatenated(row, :), length(zscoreAllGHsConcatenated(:, 1)),1);
                for k=1:length(allGHsConcatenated(:, 1))
                    if norm(diff(k,:))==0
                        % Retrieves sample IDs of person(s) with a certain index
                        clusteredSampleIDs(whileCount, j, i, end + 1) = temp_new(k);
                    end
                end
            end
        end
    end
end

%% Retrieve interesting sample IDs
for i = 1:clusters
    if clusterCounts(5, i) <= c5Limit && sum(clusterCounts(1:4, i)) >= stringent % if no or few control data in cluster
        % Store sample IDs
        for g = 1:4
            for h = 1:length(clusteredSampleIDs(whileCount, g, i, :))
                if ~isempty(clusteredSampleIDs{whileCount, g, i, h})
                    usefulSampleIDs(end + 1) = clusteredSampleIDs(whileCount, g, i, h);
                end
            end
        end
    end
end

%% Displaying stacked bar chart

if displayBarChart
    figure
    bar(1:clusters, clusterCounts', 0.5, 'stack');
    xlabel('Clusters')
    ylabel('Number of elements per cluster')
    legend('week', 'month', '6 months', 'year', 'multiple years', 'Location', 'NorthEastOutside');
end

%% Plotting clusters
if plotClusters
    figure
    for i = 1:clusters % looping through number of clusters
        subplot(clusters/2,2,i)
        % Matrix is transposed so there is one row per GH and one column per
        % respondent, such that the length of the x-axis remains constant while
        % the number of lines is the number of respondents.
        plot(zscoresGHsConcatenated(indices == i, :)', 'MarkerSize', 12)
        ylim([min(min(zscoresGHsConcatenated)) max(max(zscoresGHsConcatenated))])
        xlabel('GH identifier (1-117)')
        ylabel('GH Zscores')
        titleString = sprintf('Cluster %d', i);
        title(titleString)
    end
    suptitleString = sprintf('Kmeans clusters of GH abundances with %d replicates', replicates);
    suptitle(suptitleString)
end

%% PCA of centroids

if pcaCentroids == 1
    centroidsT = centroids';
    coMatrix = cov([centroids' zscoresGHsConcatenated']);
    [V, D] = eigs(coMatrix);
    figure
    hold on
    for i = 1:5
        scatter(V(i, 1), V(i, 2), 'xr', 'LineWidth', 3)
    end
    legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5', 'Location', 'NorthEastOutside')
    for i = 6:length(V(:, 1))
            scatter(V(i, 1), V(i, 2), 'xb', 'LineWidth', 3)
    end
    title('Principle Component Analysis of Centroids from GH Profile Kmeans Clustering')
    xlabel('Component 1')
    ylabel('Component 2')
    
    
    figure
    [pc,score,latent] = princomp(centroids');
    biplot(pc(:,1:2),'Scores',score(:,1:2), 'VarLabels',...
		{'Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5'})
    title('Principle Component Analysis of Centroids from GH Profile Kmeans Clustering')
    xlabel('Component 1')
    ylabel('Component 2')
    cumsum(latent(1:5))./sum(latent) % fraction of variation in first eigenvalues
end

newUniqueSampleIDs = unique(usefulSampleIDs', 'rows'); % eliminates repeats
UniqueSampleIDs = unique([UniqueSampleIDs; newUniqueSampleIDs]);
end