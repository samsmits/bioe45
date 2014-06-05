tax = 'genus';
dataS = SampleID_antibiotic_multipleyear

uniqueTax = transpose(unique(communitydataset.(tax)));
abundanceVector = zeros(length(dataS),length(uniqueTax));

names = dataS;

for i = 1:length(dataS);
    disp(100*i/length(dataS));
    sampleID = dataS{i};
    
    sampleIndex = cellfun(@(x) strncmpi(x, sampleID, length(sampleID)),...
        communitydataset.name, 'Uniformoutput', false);
    
    sampleIndexLogical = logical(cell2mat(sampleIndex));
    
    K = find(sampleIndexLogical>0);
    
    sampleDS = communitydataset(sampleIndexLogical,:);
    
    

        for j = 1:length(sampleDS);
            %abundanceVector{i,1} = sampleID;
            sampleTax = sampleDS.(tax){j};
            for k = 1:numel(uniqueTax);
                comTax = uniqueTax{k};
                if strcmpi(sampleTax,comTax);
                   
                    abundanceVector(i,k) = sampleDS.abundance(j) +...
                        abundanceVector(i,k);
           
                end
            end
        end 
end

allAntibioticsCell = abundanceVector;

%%
headers = uniqueTax;
for i = 1:length(uniqueTax);
    varN = uniqueTax{i};
    varN(ismember(varN,' ,.:;!)')) = [];
    varN(ismember(varN,'-(')) = ['_'];
    headers{i} = varN;
end

if strcmp(tax,'class');
    headers{2} = 'S5_18';
end
headers = headers(2:end);

%% Normalize
normMat = [];
for i = 1:size(allAntibioticsCell,1)
    readNum = sum(allAntibioticsCell(i,:));
    normMat(i,:) = allAntibioticsCell(i,:);%/readNum;
end
normMat(isnan(normMat)) = 0;
%%
normMat = normMat(:,2:end);
%%
antibiotics_myear_DS_noNorm = mat2dataset(normMat);
antibiotics_myear_DS_noNorm.Properties.VarNames = headers;
antibiotics_myear_DS_noNorm.Properties.ObsNames = names;