function [ outputDS ] = findAbundance( sampleDataset, field, varnames)
%Helper function for *getCommunityDataFromDS.m*
% This function takes a dataset, a column name, and all the unique taxa and
% returns a dataset of abundances for each sample

outputDS = dataset;
abundanceVector = zeros(1,length(varnames));
for i = 1:length(sampleDataset);
    for j = 1:numel(varnames);
        varN = varnames{j};
        if ~strcmpi(varN,'-');
            if strcmpi(sampleDataset.(field){i},varN);
                abundanceVector(j) = sampleDataset.abundance(i) +...
                    abundanceVector(j);
                val = abundanceVector(j);
                % find spaces/characters and remove
                varN(ismember(varN,' ,.:;!)')) = [];
                varN(ismember(varN,'-(')) = ['_'];
            
                outputDS.(varN) = val;
            end
        end 
    end
end


end

