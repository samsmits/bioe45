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

%% Clustering



%ANOVA
%Clustering
% Samples 
% Pull similar amount of samples from random
% Hierarchical clustering - euclydian distance
% PCA
% 