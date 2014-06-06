%% This script can act as a sample for how to get community data

%Convert metadata into dataset
%metadataset = dataset('File','allMetadata_underscoreHeaders.csv',...
%                   'ReadVarNames',true,'ReadObsNames',false,...
%                    'Delimiter',',');
                
                
%Convert community data into dataset                
%communitydataset = dataset('File','all-assignments.csv',...
%                    'ReadVarNames',true,'ReadObsNames',false,...
%                    'Delimiter',',');

filterFields = {'Age',...
                'Sex',...
                'Shellfish_Allergy',...
                'Treenut_Allergies',...
                'Peanut_Allergies'...
                'Food_Allergies___Other',...
                'Food_Allergies___Other_Text',...
                'Gluten_Intolerant',...
                'Lactose_Intolerant',...
                'Seasonal_Allergies',...
                'Primary_Carb',...
                'Percent_of_Carbohydrates_from_Processed_Carbohydrates',...
                'x__Calories_from_Carbohydrate'};

Filtervalues = {'ALL'};
                
myData = getFilteredDataset( metadataset, filterFields,Filtervalues );

LogicalGlutenIntolerant = cell2mat(cellfun(@(x) strcmpi(x,'yes'),...
    myData.Gluten_Intolerant, 'UniformOutput',false));

% Find Gluten Intolerant
myDataGluten = myData;

myDataGluten(logical(~LogicalGlutenIntolerant),:) = [];


% Find Lactose Intolerant
myDataLactose = myData;

LogicalLactoseIntolerant = cell2mat(cellfun(@(x) strcmpi(x,'yes'),...
    myData.Lactose_Intolerant, 'UniformOutput',false));

myDataLactose(logical(~LogicalLactoseIntolerant),:) = [];

% Find ShellFish Allergies
myDataShellfish = myData;

LogicalShellfish = cell2mat(cellfun(@(x) strcmpi(x,'yes'),...
    myData.Shellfish_Allergy, 'UniformOutput',false));

myDataShellfish(logical(~LogicalShellfish),:) = [];

% Find Peanut Allergies
myDataPeanut = myData;

LogicalPeanut = cell2mat(cellfun(@(x) strcmpi(x,'yes'),...
    myData.Peanut_Allergies, 'UniformOutput',false));

myDataPeanut(logical(~LogicalPeanut),:) = [];

% Find Treenut Allergies
myDataTreenut = myData;

LogicalTreenut = cell2mat(cellfun(@(x) strcmpi(x,'yes'),...
    myData.Treenut_Allergies, 'UniformOutput',false));

myDataTreenut(logical(~LogicalTreenut),:) = [];

% Find Multiple Food Allergies

myDataMultipleFoodAllergies = myDataPeanut;

LogicalTreenutAll = cell2mat(cellfun(@(x) strcmpi(x,'yes'),...
    myDataPeanut.Treenut_Allergies, 'UniformOutput',false));

myDataMultipleFoodAllergies(logical(~LogicalTreenutAll),:) = [];

LogicalShellfishAll = cell2mat(cellfun(@(x) strcmpi(x,'yes'),...
    myDataMultipleFoodAllergies.Shellfish_Allergy, 'UniformOutput',false));

myDataMultipleFoodAllergies(logical(~LogicalShellfishAll),:) = [];


% Find Seasonal Allergies
myDataSeasonalAllergies = myData;

LogicalSeasonalAllergies = cell2mat(cellfun(@(x) strcmpi(x,'yes'),...
    myData.Seasonal_Allergies, 'UniformOutput',false));

myDataSeasonalAllergies(logical(~LogicalSeasonalAllergies),:) = [];

% Find No Allergies

LogicalNoAllergies = LogicalTreenut + LogicalPeanut + LogicalShellfish +...
    LogicalSeasonalAllergies;

myDataNoAllergies = myData;

myDataNoAllergies(logical(LogicalNoAllergies),:) = [];