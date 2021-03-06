function [ comMat ] = makeCommunityMatrix(comDat, sampleIDs,taxLevel,Bacteria)
%% makeCommunityMatrix
%  takes an array of sampleIDs and returns a matrix of all available
%  community data at the specified taxon level.
%  
%     comDat   = data from all-assignments.csv
%
%     sampleIDs= array of sampleIDs (can be made from getAllSampleIDs.m)
%
%     taxLevel = Can be value: 
%                             1 = phylum
%                             2 = class
%                             3 = order
%                             4 = falmily
%                             5 = genus
%                             6 = species
%     Bacteria = true if only bacteria, false if all available taxa

%% Pseudocode

% Get indexes in community data for all sampleIDs


% Find the community data for each sampleID
  

% Sort community data by taxLevel, combining identical taxa names and
% summing abundance

% Create a dataset for each SampleID

% merge all data by using the join function




end

