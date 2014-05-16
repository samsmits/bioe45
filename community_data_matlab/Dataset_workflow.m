%% This script can act as a sample for how to get community data

%Convert metadata into dataset
metadataset = dataset('File','allMetadata_underscoreHeaders.csv',...
                   'ReadVarNames',true,'ReadObsNames',false,...
                    'Delimiter',',');
                
                
%Convert community data into dataset                
%communitydataset = dataset('File','all-assignments.csv',...
%                    'ReadVarNames',true,'ReadObsNames',false,...
%                    'Delimiter',',');
                
filterFields = {'Age','Sex','Pregnant','Pregnant_Due_Date','Contraceptive'};

Filtervalues = {'ALL','Female','yes','ALL','All'};
                
isPreg = getFilteredDataset( metadataset, filterFields,Filtervalues );

LogicalhasDueDate = cell2mat(cellfun(@(x) strcmpi(x,'none'),...
    isPreg.Pregnant_Due_Date, 'UniformOutput',false));

isPreg(logical(LogicalhasDueDate),:) = [];

Filtervalues = {'ALL','Female','notsure','none','ALL'};

maybPreg = getFilteredDataset( metadataset, filterFields,Filtervalues );

Filtervalues = {'ALL','Female','ALL','none','ALL'};

female = getFilteredDataset( metadataset, filterFields,Filtervalues );

LogicalisPreg = cell2mat(cellfun(@(x) strcmpi(x,'yes'),female.Pregnant,...
    'UniformOutput',false));

LogicalmayBPrg = cell2mat(cellfun(@(x) strcmpi(x,'notsure'),female.Pregnant,...
    'UniformOutput',false));

female(logical(LogicalisPreg),:) = [];

female(logical(LogicalmayBPrg),:) = [];



%myCommunity = getCommunityDataFromDS(communitydataset, isPreg,2,true);