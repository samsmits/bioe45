%% This function takes in the metadata cell array, a column of


function [ sampIDs ] = getAllSampleIDs(metadata,category,level)

%% Find the header of the metadata that matches the category
% 
headers = metadata {1,:};

%
categoryRef = strcmpi(category,headers);

metadata{:,categoryRef}

%%


