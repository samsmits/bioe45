%% statsByID

function [abunds, groups, cats, allAbunds] = statsByID(assignments, sampleIDs, colData, hierarchy)
    %fprintf('length of colData: %d\n', length(colData));
    [cats,~,n] = unique(colData);
    catCommData = cell(1,length(sampleIDs));
    for j = 1:length(sampleIDs)
        catCommData{j} = getSampleCommunityData(assignments, strcat('"',sampleIDs{j},'"'), hierarchy, 1);
    end
    fprintf('made catCommData with %d entries\n',length(catCommData));
    groups = [];
    for j=1:length(catCommData)
        groups = vertcat(groups,setdiff(catCommData{j}(:,1),groups));
    end
    abunds = zeros(length(groups),length(cats));
    allAbunds = zeros(length(groups), length(sampleIDs));
    fprintf('finished making ords & abunds (%d x %d)\n', size(abunds,1), size(abunds,2));
    for j=1:length(catCommData)
        currGrps = catCommData{j}(:,1);
        currAb = cell2mat(catCommData{j}(:,2));
        for k=1:size(currGrps,1)
            fndInd = find(strcmpi(groups, currGrps(k)) == 1);
            abunds(fndInd,n(j)) = abunds(fndInd,n(j)) + currAb(k)/length(n(n==n(j)));
            allAbunds(fndInd, j) = currAb(k);
        end
    end
end