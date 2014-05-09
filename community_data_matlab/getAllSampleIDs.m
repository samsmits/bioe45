function [ sampleIDs ] = getAllSampleIDs(metadata,category,level)

%% getAllSampleIDs 
%  return sampleIDs from a cell that display data of interest.
%  C = *getAllSampleIDs* (dataCell, category, level) creates an array, C,
%  of sampleIDs that fill the requirements of level for the header,
%  category.
%
%  C = *getAllSampleIDs* (dataCell, {C1, C2,...},{level1, level2,...})
%  allows the user to specify multiple values.  Specifying "ALL" as the
%  level, returns all SampleIDs that contain any value for that category.
%
%  
%  For example:
%  C = *getAllSampleIDs*(dataCell, {'Sex', 'Race'},{'Female', 'ALL'})
%  one can find all SampleIDs from subjects who are Female 
%
%  Numbers can be used as level input, however, it must be determined
%  whether you are looking for a data that is greater,'GT',greater than or
%  equal, 'GE', less than, 'LT', less than or equal 'LE', or exactly equal,
%  ,'EQ', to the level
%
% 
%  For example:
%  C = *getAllSampleIDs*(dataCell, {'Age'},{35, 'ge'})
%  one can find all SampleIDs from subjects who are of age greater than or 
%  equal to 35 

%% Get headers and indices of the columns that contain specified categories
headers = metadata (1,:);

for i = 1:numel(category);
    colIndex(i) = find(strcmpi(headers,category{i}));
end

%% Grab the column of that index and return sampleIDs
column = metadata(2:end,colIndex);

% Get row indices for each level
j = 1;
for i = 1:numel(category); 
   allvals = strcmpi(level(j),'ALL');
   isvalue = isnumeric(level{j});
   
   % User specified 'ALL'
   if (allvals == 1);
       zeroMat = zeros(size(column, 2));
       emptyMat = cellfun(@isempty,column(:,i));
       zeroMat(emptyMat) = 1
       rowIndex(:,i) = zeroMat;
   % User specified a numeric value
   elseif (isvalue == 1);
       value = level{j}; 
       j = j+1;
       equality = level{j};
       cellarr = column(2:end,i);
       rowIndex(:,i) = getLogicalwithCell(cellarr, value, equality);
   else
       rowIndex(:,i) = strcmpi(column(:,i),level(i));
   end
   j = j+1;
end

allvals = strcmpi(level(1),'ALL');
if (allvals == 1);
    SubjectIndex = find(rowIndex(:,1) == 0);
else
    SubjectIndex = find(rowIndex(:,1));
end

% Get SampleIDs from indices
for i = 2:numel(category)
    allvals = strcmpi(level(i),'ALL');
    if (allvals == 1);
        find(rowIndex(:,i) == 0)
        SubjectIndex = intersect(SubjectIndex,find(rowIndex(:,i) == 0));
    else
        SubjectIndex = intersect(SubjectIndex,find(rowIndex(:,i)));
    end
end

sampleIDs = metadata(SubjectIndex,2);




