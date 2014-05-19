%% This script can act as a sample for how to get community data

%%Convert metadata into dataset
metadataset = dataset('File','allMetadata_underscoreHeaders.csv',...
                   'ReadVarNames',true,'ReadObsNames',false,...
                    'Delimiter',',');
                
                
%%Convert community data into dataset                
communitydataset = dataset('File','all-assignments.csv',...
                    'ReadVarNames',true,'ReadObsNames',false,...
                    'Delimiter',',');

%%
filterFields = {'Age','Sex'};

Filtervalues = {'ALL'};
                
allAGD = getFilteredDataset( metadataset, filterFields,Filtervalues );



allCommunity = getCommunityDataFromDS(communitydataset, allAGD,2,true);

%% Making Matrix

commCell = dataset2cell(allCommunity);
commMat = cell2mat(commCell(2:end,2:end));
commMat(isnan(commMat)) = 0;

%% Normalizing

normMat = commMat;

for i = 1:length(commMat)
    readNum = sum(commMat(i,:));
    normMat(i,:) = normMat(i,:)/readNum;
end

%ANOVA
%Clustering
% Samples 
% Pull similar amount of samples from random
% Hierarchical clustering - euclydian distance
% PCA
% 