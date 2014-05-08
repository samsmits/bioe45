function [ comListAndAbundance ] = getSampleCommunityData(comDat, sampleID,taxLevel,bacteria)
% This function takes in the community data csv and a sample ID and returns
% the list of bacterial community members for that sample

% The samples are in the third column 
samples = comDat(:,3);

% Find the indexes for records in the community data with the sampleID
communityIdx = find(strcmpi(samples,sampleID));

% Generate a new matrix of community members for sampleID 
comMatForSample = comDat(communityIdx,:);

% Filter out non-bacterial species
if bacteria == 1
    domain = comMatForSample(:,4);
    onlyBacteria = find(strcmpi(domain,'"Bacteria"'));
    comMatForSample = comMatForSample(onlyBacteria,:); 
end

% Store the abundances of each bacterial member
abundance = comMatForSample(:,11);

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
    
% Generate a list of community members for sampleID at given taxonomic
% level
comList = comMatForSample(:,taxCol);

% make a matrix of community members and abundance
comListAndAbundance = [comList,abundance];

% Filter out rows with unassigned taxonomy
blankIdx = find(strcmpi(comListAndAbundance,'"-"'));
comListAndAbundance(blankIdx,:) = [];

end

