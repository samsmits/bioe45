%% statsCategorical
% returns:
%   abunds - The abundancies of the different bacterial communities found
%   in the samples.
%   
%   ords - The 'orders' of the biological communities found in the samples.
%   This actually could be whatever hierarchy is specified by the input.
%
%   u - the different categories the data is divided into in the metadata
%   file.
%
% inputs:
%   metadata - the metadata from a file, e.g. read_mixed_csv('allMetadata.csv',',')
%
%   assignments - the GH data from its associated file, e.g. read_mixed_csv('all-assignments.csv',',')
%
%   categories - the categories from the metadata file the user wishes to
%   look at (currently only works for one though), e.g. {'# Plants Consumes'}
%
%   hierarchy - same as the taxLevel parameter of the
%   getSampleCommunityData function
function [abunds, ords, u] = statsCategorical(metadata, assignments, categories, hierarchy)
for i=1:length(categories)
    colInd = strmatch(categories{i}, metadata(1,:), 'exact');
    colData = metadata(2:end,colInd);
    %fprintf('length of colData: %d\n', length(colData));
    [u,~,n] = unique(colData);
    [colData_2, colInd] = removeEmptyCells(colData);
    %fprintf('number of cells removed: %d\n', length(n(n==1)));
    sampleIDs = getColumnData('allMetadata.csv', 'Sample Identifier');
    %fprintf('original length of sampleIDs: %d\n', length(sampleIDs));
    sampleIDs(n==1) = [];
    %fprintf('final length of sampleIDs: %d\n', length(sampleIDs));
    n(n==1) = []; % removes blank entries
    n = n - 1; % adjusts answers because blank entries have been removed
    u = u(2:end); % removes blank category
    %fprintf('range of n: %d to %d\n', min(n), max(n));
    %fprintf('data adjusted for uniqueness and empty cells\n');
    %fprintf('example category reaching n(40)=%d\n',n(40));
    catCommData = cell(1,length(sampleIDs));
    for j = 1:length(sampleIDs)
        catCommData{j} = getSampleCommunityData(assignments, strcat('"',sampleIDs{j},'"'), hierarchy, 1);
    end
    %fprintf('made catCommData with %d entries\n',length(catCommData));
    ords = [];
    for j=1:length(catCommData)
        ords = vertcat(ords,setdiff(catCommData{j}(:,1),ords));
    end
    abunds = zeros(length(ords),length(u));
    %fprintf('finished making ords & abunds (%d x %d)\n', size(abunds,1), size(abunds,2));
    for j=1:length(catCommData)
        currGrps = catCommData{j}(:,1);
        currAb = cell2mat(catCommData{j}(:,2));
        
        for k=1:size(currGrps,1)
            fndInd = find(strcmpi(ords, currGrps(k)) == 1);
            abunds(fndInd,n(j)) = abunds(fndInd,n(j)) + currAb(k)/length(n(n==n(j)));
        end
    end
end
end