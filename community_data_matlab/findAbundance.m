function [ outputDS ] = findAbundance( sampleDataset, field, varnames)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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
                if strncmp(varN,'unclassified',12);
                    varN = 'unclassified'; 
                end
            
                outputDS.(varN) = val;
            end
        end 
    end
end

end

