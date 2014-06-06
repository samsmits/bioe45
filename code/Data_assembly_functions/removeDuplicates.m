%% remove duplicates
% takes in a cell array of sampleIDs, the hierarchy by which the function
% will decide which sample is more significant, and the assignments
% obtained via read_mixed_csv('all-assignments.csv',',')
%
% outputs a cell array of sampleIDs with the duplicates with the lowest
% abundancies removed, and the indices of the removed sampleIDs
function [samples, inds] = removeDuplicates(sampleIDs, hierarchy, assignments)
samps = floor(str2double(sampleIDs));
[u,~,n] = unique(samps);
inds = [];
for i=1:length(u)
    if isnan(u(i))
        continue;
    end
    currInds = find(n==i);
    if length(currInds) > 1 % maximum of 2 samples per ID in metadata (will only compare two samples here)
        % get the abundancies using getSampleCommunityData() then taking
        % the sum/average(?) of that; the sample with the largest
        % abundancies gets removed from currInds, and the rest of currInds
        % gets added to inds
        
        commData = cell(1,length(currInds));
        for j=1:length(currInds)
            commData{j} = getSampleCommunityDataOg(assignments, strcat('"',sampleIDs{currInds(j)},'"'), hierarchy, 1);
        end
        if size(commData{1},1) > size(commData{2},1)
            inds = vertcat(inds, currInds(2));
        elseif size(commData{1},1) < size(commData{2},1)
            inds = vertcat(inds, currInds(1));
        else
            avg1 = mean(cell2mat(commData{1}(:,2)));
            avg2 = mean(cell2mat(commData{2}(:,2)));
            if avg1>= avg2
                inds = vertcat(inds, currInds(2));
            else
                inds = vertcat(inds, currInds(1));
            end
        end
    end
end
samples = sampleIDs;
samples(inds) = [];
end