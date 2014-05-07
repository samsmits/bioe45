%% This function takes in the metadata cell array, a column of


function [ sampIDs ] = getAllSampleIDs(metadata,category,level)

%% Find the header of the metadata that matches the category
% 
headers = metadata(1,:);

%
categoryIndex = find(strcmpi(category,headers));

column = metadata(2:end,categoryIndex)

columnTrue = find(column == level)

%%


