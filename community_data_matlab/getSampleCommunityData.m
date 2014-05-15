function [ allCommData ] = getSampleCommunityData(comDat, sampleIDs,taxLevel,bacteria)
%% getSampleCommunityData
% This function takes in the community data stored as a cell matrix
% read_mixed_csv('all-assignments.csv',',') -- and an array of sample IDs 
% and returns the list of bacterial community members for that sample and their 
% abundances. 

% SampleIDs: a cell array of sampleIDs


% taxLevel = Can be value: 
%                             1 = phylum
%                             2 = class
%                             3 = order
%                             4 = family
%                             5 = genus
%                             6 = species
%                             7 = strain

% bacteria can be 
%                             1 = Only return bacterial organisms
%                             0 = return all organisms
%%

% Store the samples IDs from the third column 
comSampleCol = comDat(:,3);

% Allocate a cell array to store the community data for all samples
allCommData = {length(sampleIDs)};

% Loop through all sampleIDs
for i = 1:length(sampleIDs)

    sample = sampleIDs{1};     
   
    % Find the indexes for records in the community data with the sampleID
    communityIdx = strcmpi(comSampleCol,strcat('"',sample,'"'));

    % Generate a new cell matrix of community members for sampleID 
    comMatForSample = comDat(communityIdx,:);

    % Filter out non-bacterial species
    if bacteria == 1
        domain = comMatForSample(:,4);
        onlyBacteria = strcmpi(domain,'"Bacteria"');
        comMatForSample = comMatForSample(onlyBacteria,:); 
    end

    % pick a column for the taxonomy level
    if taxLevel == 1
        taxCol = 4;
    elseif taxLevel == 2
        taxCol = 5;
    elseif taxLevel == 3
        taxCol = 6;
    elseif taxLevel == 4
        taxCol = 7;
    elseif taxLevel == 5
        taxCol = 8;
    elseif taxLevel == 6
        taxCol = 9;
    elseif taxLevel == 7
        taxCol = 10;
    end
    
    % Generate a list of community members for sampleID at the given taxonomic
    % level and their abundances
    comList = comMatForSample(:,taxCol);
    abundance = comMatForSample(:,11);

    % make a matrix of community members and abundance
    community = [comList,abundance];

    % Filter out rows with unassigned taxonomy
    blankIdx = strcmp(comList,'"-"');
    community(blankIdx,:) = [];
    moreUnassigned = strncmp(community(:,1),'"unclassified"',10);
    community(moreUnassigned,:) = [];

    % Collapse rows of the same taxonomy
    [uniqueTaxa, firstInd, allInd] = unique(community(:,1));

    % Silly conversion of string to double for abundances -- get rid of this
    % when we can successfully read in mixed csv's.
    abundanceNumeric=(size(community,1));
    for j=1:size(community,1)
        abundanceNumeric(j) = str2double(community(j,2));
    end

    % For every unique taxon, the total abundance for that taxon is the sum of
    % the abundance array that have indices
    totalAbund = (numel(firstInd));
    for k = 1:numel(firstInd)
        totalAbund(k) = sum(abundanceNumeric(allInd == k));
    end

    % Convert abundances back into a cell and take the transpose
    abundanceCell = num2cell(totalAbund)';

    community = [uniqueTaxa,abundanceCell];
    
    % Store the community in allCommData
    allCommData{i} = community;
end

end

