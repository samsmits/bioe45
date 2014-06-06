%% gather abundance data
[agp_GHabundance, agp_GHfamily, agp_sampleID] = tblread('agp.tsv', '\t'); %GH PROFILES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
agp_identifiers = cellstr(agp_sampleID);

GHabundsMat = zeros(size(antiSelDup, 1), 117);
blankInd = [];
for i=1:size(GHabundsMat,1)
    sampInd = find(strcmp(agp_sampleID, sampDup(i)) == 1);
    if size(sampInd,1) == 0
        blankInd = vertcat(blankInd, i);
    else
        GHabundsMat(i,:) = agp_GHabundance(sampInd,:);
    end
end
GHabundsMat(blankInd,:) = [];
hostDup(blankInd) = [];
sampDup(blankInd) = [];
antiCondDup(blankInd) = [];
antiSelDup(blankInd) = [];
runDateDup(blankInd) = [];

%% PCA

[antiBiSelSort, antiBiSelInd] = sort(antiSelDup);
GHabundsSort = GHabundsMat(antiBiSelInd,:);

GHmeans = mean(GHabundsSort);
nrow_GH = size(GHabundsSort,1);
GHoff = GHabundsSort - repmat(GHmeans, size(GHabundsSort, 1), 1);

ncol_GH = size(GHabundsSort,2);
GHcov = zeros(ncol_GH, ncol_GH);
for i=1:ncol_GH
    for j=1:ncol_GH
        GHcov(i,j) = 1/(nrow_GH-1)*sum(GHoff(:,i).*GHoff(:,j));
    end
end
imagesc(GHcov);
colorbar;

[Vgh, Dgh] = eigs(GHcov);
GHstd = sqrt(diag(Dgh)/sum(diag(Dgh)));
vars = diag(Dgh)/sum(diag(Dgh));
plot(1:size(GHmeans, 2), GHmeans, 'b.', 'MarkerSize', 15);
hold on;

pc = GHabundsSort * Vgh;
startInd = 1;
[SelU, ~, SelN] = unique(antiBiSelSort);
plotStyles = {'.g', '.b', '.c', '.r'};
for i=1:length(SelU)
    catLength = length(SelN(SelN==i));
    plot(pc(startInd:startInd+catLength-1,1), pc(startInd:startInd+catLength-1,2), plotStyles{i});
    hold on;
    startInd = startInd + catLength;
end
xlabel('PC1 (72.86% variance)');
ylabel('PC2 (20.52% variance)');
legend(SelU, 'Location', 'EastOutside');
title('PCA highlights the lack of clustering within time-series categories for hosts with multiple samples', 'FontSize', 16);
