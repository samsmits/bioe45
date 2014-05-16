%% This script can act as a sample for how to get community data

%Convert metadata into dataset
metadataset = dataset('File','allMetadata_underscoreHeaders.csv',...
                   'ReadVarNames',true,'ReadObsNames',false,...
                    'Delimiter',',');
                
                
%Convert community data into dataset                
%communitydataset = dataset('File','all-assignments.csv',...
%                    'ReadVarNames',true,'ReadObsNames',false,...
%                    'Delimiter',',');
                
filterFields = {'Age','Pregnant','Pregnant_Due_Date'};

Filtervalues = {'ALL','yes','ALL'};
                
myData = getFilteredDataset( metadataset, filterFields,Filtervalues );

isPreg = myData;

LogicalhasAge = cell2mat(cellfun(@(x) strcmpi(x,'none'),isPreg.Age,'UniformOutput',false));

isPreg(logical(LogicalhasAge),:) = [];

LogicalisPreg = cell2mat(cellfun(@(x) str2num(x)>15,isPreg.Age,'UniformOutput',false));

isPreg = isPreg(logical(LogicalisPreg),:);

LogicalisPreg = cell2mat(cellfun(@(x) str2num(x)<=45,isPreg.Age,'UniformOutput',false));

isPreg = isPreg(logical(LogicalisPreg),:);

myCommunity = getCommunityDataFromDS(communitydataset, isPreg,2,true);