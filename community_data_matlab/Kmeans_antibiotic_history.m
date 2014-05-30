% USER -- open workspace GHabundances_antibiotics.mat

% This script performs Kmeans clustering of GH scores for comparison to 
% antibiotic history groups in the metadata

%% Creating clusters

% Concatenates GH abundances from those who took antibiotics at different
% times
GHsConcatenated = [GHprofile_antibiotic_week; ...
    GHprofile_antibiotic_month; GHprofile_antibiotic_6month; ...
    GHprofile_antibiotic_year; GHprofile_antibiotic_multipleyear];

% Normalizes GH abundances by column
zscoresGHsConcatenated = zscore(GHsConcatenated);

% Running kmeans
clusters = 5;
replicates = 20;
[indices, centroids] = kmeans(zscoresGHsConcatenated, clusters, 'Replicates', replicates);

%% Plotting clusters
figure
for i = 1:length(centroids(:, 1)) % looping through number of clusters
    subplot(3,2,i)
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

%% Analyzing accuracy of clusters
respondentsPerCluster = zeros(length(centroids(:, 1)),1); % initializes
for i = 1:length(centroids(:, 1)) % looping through number of clusters
    respondentsPerCluster(i) = size(zscoresGHsConcatenated(indices == i, :), 1);
end
respondentsPerCluster
% Resulting values can be compared to the sizes of the original respondent
% groups