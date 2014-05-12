function [ filteredDataset ] = getFilteredDataset( datasetFromFile, filterFields,Filtervalues )
%% return dataset that displays data of interest.
%  C = *getFilteredDataset* (datset, category, level) creates an array, C,
%  of sampleIDs that fill the requirements of level for the header,
%  category.
%
%  C = *getFilteredDataset* (dataCell, {C1, C2,...},{level1, level2,...})
%  allows the user to specify multiple values.  Specifying "ALL" as the
%  level, returns all complete data for the desired levels. Specifying
%  "ALL" for any particular level, returns all complete data for that level
%  only
%
%  
%  For example:
%  C = *getfilteredDS*(dataCell, {'Sex', 'Race'},{'Female', 'ALL'})
%  one can get a dataset from all subjects who are Female 
%
%  Numbers can be used as level input, however, it must be determined
%  whether you are looking for a data that is greater,'GT',greater than or
%  equal, 'GE', less than, 'LT', less than or equal 'LE', or exactly equal,
%  ,'EQ', to the level
%
% 
%  For example:
%  C = *getfilteredDS*(dataCell, {'Age'},{35, 'ge'})
%  one can find all SampleIDs from subjects who are of age greater than or 
%  equal to 35 


% Always include Study and Sample_Identifier
defaultFields = {'Study','Sample_Identifier'};
fields = [defaultFields filterFields];
dsDefault = datasetFromFile(:,fields);




% if there is only one input value and it is 'ALL', just find all subjects
% with data

if (strcmpi(Filtervalues{1},'ALL') && (numel(Filtervalues) == 1));
    ix = ismissing(dsDefault);
    filteredDataset = dsDefault(~any(ix,2),:);
else
    
    filteredDataset = dsDefault;
    j = 1;

% For multiple Filtervalues
    for i = 1:numel(filterFields);
        str = filterFields{i};
        val = Filtervalues{j};
        if isnumeric(val)       %if you're looking for an equality
            j = j+1;
            ineq = Filtervalues{j}
            posIndexLogical = getLogicalwithDS(filteredDataset.(str),...
                val, ineq );
            
        elseif (strcmpi(val,'ALL')) % if you want all values for a level
            emptyMat = cellfun(@isempty,filteredDataset.(str));
            posIndexLogical = logical(~emptyMat);
            
        else
            posIndex=cellfun(@(x)strcmpi(x,val), filteredDataset.(str), 'Uniformoutput',false);
            posIndexLogical = cell2mat(posIndex);
        end
        filteredDataset = filteredDataset(posIndexLogical,:);
        j = j+1;
    end
end

