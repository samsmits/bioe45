function [ filteredDataset ] = getFilteredDataset( datasetFromFile, filterFields,Filtervalues )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

                
fields = fieldnames(datasetFromFile);

for i = 1:numel(category);
    colIndex(i) = find(strcmpi(fields,filterFields{i}));
end

% % Get row indices for each level
% j = 1;
% for i = 1:numel(category); 
%    allvals = strcmpi(level(j),'ALL');
%    isvalue = isnumeric(level{j})
%    
%    % User specified 'ALL'
%    if (allvals == 1);
%        zeroMat = zeros(size(column, 2));
%        emptyMat = cellfun(@isempty,column(:,i));
%        zeroMat(emptyMat) = 1
%        rowIndex(:,i) = zeroMat;
%    % User specified a numeric value
%    elseif (isvalue == 1);
%        value = level{j}; 
%        j = j+1;
%        equality = level{j};
%        cellarr = column(2:end,i);
%        rowIndex(:,i) = getLogicalwithCell(cellarr, value, equality);
%    else
%        rowIndex(:,i) = strcmpi(column(:,i),level(i));
%    end
%    j = j+1;
% end
% 
% end
% 
