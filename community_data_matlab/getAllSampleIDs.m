%% getAllSampleIDs
% This function takes in the metadata cell matrix, a column of  the metadata
% that you are interested in (string), and a level and return an array of 
% sample IDs. For example if you wanted sample IDs for all females you you 
% would pass in (metadata,'Sex','female'). The function is not case 
% sensitive, but the strings have to be exact matches. 

function [ sampIDs ] = getAllSampleIDs(metadata,category,level)

%% Find the header of the metadata that matches the category
<<<<<<< HEAD

% Store the first row of the metadata as the headers 
headers = metadata (1,:);

% Find the index of the column with the category you're interested in
colIndex = find(strcmpi(headers,category));

% Grab the column of that index
column = metadata(2:end,colIndex);

% Find the indexes of all rows with the level you're interested in
rowIndex = find(strcmpi(column,level));

% Store the 
sampIDs = metadata(rowIndex,2);

=======
% 
headers = metadata(1,:);

%
categoryIndex = find(strcmpi(category,headers));

column = metadata(2:end,categoryIndex)

columnTrue = find(column == level)
>>>>>>> FETCH_HEAD

%%


