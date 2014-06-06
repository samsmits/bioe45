%% This script can act as a sample for how to get community data

%Convert metadata into dataset
metadataset = dataset('File','allMetadata_underscoreHeaders.csv',...
                   'ReadVarNames',true,'ReadObsNames',false,...
                    'Delimiter',',');
                
                
%Convert community data into dataset                
communitydataset = dataset('File','all-assignments.csv',...
                    'ReadVarNames',true,'ReadObsNames',false,...
                    'Delimiter',',');
                
filterFields = {'Age','Sex','Pregnant','Pregnant_Due_Date','Contraceptive'};

Filtervalues = {'ALL','Female','yes','ALL','All'};
                
isPreg = getFilteredDataset( metadataset, filterFields,Filtervalues );

LogicalhasDueDate = cell2mat(cellfun(@(x) strcmpi(x,'none'),...
    isPreg.Pregnant_Due_Date, 'UniformOutput',false));
% Sort for only those that have due dates
isPreg(logical(LogicalhasDueDate),:) = [];

Filtervalues = {'ALL','Female','ALL','none','ALL'};

% Find everyone else
female = getFilteredDataset( metadataset, filterFields,Filtervalues );

% Might be pregnant
LogicalisPreg = cell2mat(cellfun(@(x) strcmpi(x,'yes'),female.Pregnant,...
    'UniformOutput',false));

LogicalunsurePreg = cell2mat(cellfun(@(x) strcmpi(x,'notsure'),female.Pregnant,...
    'UniformOutput',false));

LogicalunknownPreg = cell2mat(cellfun(@(x) strcmpi(x,'unknown'),female.Pregnant,...
    'UniformOutput',false));

LogicalmayBPreg = LogicalunknownPreg + LogicalunsurePreg;

femaleMayBPreg = female;

femaleMayBPreg(logical(~LogicalmayBPreg),:) = [];

LogicalagetooYoung = cell2mat(cellfun(@(x) str2num(x) <= 12 ,femaleMayBPreg.Age,...
    'UniformOutput',false));

LogicalagetooOld = cell2mat(cellfun(@(x) str2num(x) > 45 ,femaleMayBPreg.Age,...
    'UniformOutput',false));

LogicalAgeAppropriate = LogicalagetooYoung + LogicalagetooOld;

femaleMayBPreg(logical(LogicalAgeAppropriate),:) = [];

% Not Pregnant
femaleNoPreg = female;

LogicalNotPreg = LogicalmayBPreg+ LogicalisPreg;

femaleNoPreg(logical(LogicalNotPreg),:) = [];

LogicalPill = cell2mat(cellfun(@(x) strcmpi(x,'I take the pill'),femaleNoPreg.Contraceptive,...
    'UniformOutput',false));

LogicalRing = cell2mat(cellfun(@(x) strcmpi(x,'I use the NuvaRing'),femaleNoPreg.Contraceptive,...
    'UniformOutput',false));

LogicalShot = cell2mat(cellfun(@(x) strcmpi(x,'I use an injected contraceptive (DMPA)'),femaleNoPreg.Contraceptive,...
    'UniformOutput',false));

LogicalBC = LogicalPill+LogicalRing+LogicalShot;

femaleNoBC = femaleNoPreg;

femaleNoBC(logical(LogicalBC),:) = [];

femaleHormonalBC = femaleNoPreg;

femaleHormonalBC(logical(~LogicalBC),:) = [];




femaleCommunity = getCommunityDataFromDS(communitydataset, female,2,true);
femalePregComm = getCommunityDataFromDS(communitydataset, isPreg,2,true);
femaleBCComm = getCommunityDataFromDS(communitydataset, femaleHormonalBC,2,true);
femaleNoBCComm = getCommunityDataFromDS(communitydataset, femaleNoBC,2,true);



femCell = dataset2cell(femaleCommunity);
femCell = femCell(2:end,:);
femMat = cell2mat(femCell);
femNan = find(isnan(femMat));
femMat(femNan) = 0;

%ANOVA
%Clustering
% Samples 
% Pull similar amount of samples from random
% Hierarchical clustering - euclydian distance
% PCA
% 