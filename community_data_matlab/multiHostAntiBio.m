%% multiHostAntiBio
% Gets the host IDs, sample IDs, antibiotic conditions, antibiotic slects,
% and run dates of all hosts who've had multiple samples taken from them,
% and have at least one recorded sample from a time-frame of less than a
% year after taking antibiotics

%% sifting through metadata

% read in metadata
metaData = read_mixed_csv('allMetadata.csv',',');

% get column data
hostIDs = getColumnData('allMetadata.csv', 'Host Subject ID');
sampleIDs = getColumnData('allMetadata.csv', 'Sample Identifier');
antiBiCond = getColumnData('allMetadata.csv', 'Antibiotic Condition');
antiBiSel = getColumnData('allMetadata.csv', 'Antibiotic Select');
runDate = getColumnData('allMetadata.csv', 'Run Date');

% remove samples with no host ID
emptyInds = (strcmp(hostIDs,'')==1);
hostIDs(emptyInds) = [];
sampleIDs(emptyInds) = [];
antiBiCond(emptyInds) = [];
antiBiSel(emptyInds) = [];
runDate(emptyInds) = [];

% remove duplicate samples (samples recorded >1 times)
[sampleIDs, dupInds] = removeDuplicates(sampleIDs, 4, allAss);
hostIDs(dupInds) = [];
antiBiCond(dupInds) = [];
antiBiSel(dupInds) = [];
runDate(dupInds) = [];


%% retrieving data for hosts with multiple samples

% truncate the hostIDs to get the host #s
truncHosts = hostIDs;
for i=1:length(truncHosts)
    truncHosts{i} = truncHosts{i}(6:end);
end

% find all unique host #s
[u,~,n] = unique(truncHosts);

% set up cells for all 5 fields of interest
hostDup = {};
sampDup = {};
antiCondDup = {};
antiSelDup = {};
runDateDup = {};

% if a host # appears more than once, than we know that host had multiple
% samples taken from them, so we add the information for that host to our
% cells
numHosts = 0;
for i=1:length(u)
    currInds = find(n==i);
    if length(currInds) > 1
        fprintf('FOUND %d MATCH(S) FOR: %s\n', length(currInds), u{i});
        hostDup = vertcat(hostDup, hostIDs(currInds));
        sampDup = vertcat(sampDup, sampleIDs(currInds));
        antiCondDup = vertcat(antiCondDup, antiBiCond(currInds));
        antiSelDup = vertcat(antiSelDup, antiBiSel(currInds));
        runDateDup = vertcat(runDateDup, runDate(currInds));
        
        numHosts = numHosts + 1;
    end
end

fprintf('Number of hosts with multiple samples is %d', numHosts);
