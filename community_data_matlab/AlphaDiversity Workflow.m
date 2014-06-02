% This is a workflow to plot the CommunityAlpha Diversity based on various
% factors
%
% The first is respect to age:

% The second is respect to age and time since antibiotic use

% The third is respect to age and type of antibiotic used

%% Read in files as dataset

AntiBiodataset = dataset('File','AllAntibiotic_Class_notNormalized_antibioticClass.csv',...
                  'ReadVarNames',true,'ReadObsNames',false,...
                   'Delimiter',',');
               
Genusdataset = dataset('File','AllAntibiotic_Genus.csv',...
                  'ReadVarNames',true,'ReadObsNames',false,...
                   'Delimiter',','); 
               
GHdata = [GHprofile_antibiotic_6month;GHprofile_antibiotic_month; GHprofile_antibiotic_multipleyear; GHprofile_antibiotic_year; GHprofile_antibiotic_week];

%%
% Calculate Alpha diversity

Under = [];
Over = [];
OverSample = {};
UnderSample = {};
OverAntiTime = {};
UnderAntiTime = {};
OverAntiClass = [];
UnderAntiClass = [];
OverAntiName = {};
UnderAntiName = {};
OverGH = [];
UnderGH = [];

Agecutoff = 55;

for i = 1:size(AntiBiodataset,1);
    SampleAge = AntiBiodataset.Age(i)
    Type1 = AntiBiodataset.Class1(i);
    Type2 = 3*AntiBiodataset.Class2(i);
    Type3 = 5*AntiBiodataset.Class3(i);
    AntiClass = Type1+Type2+Type3;
    if isnumeric(SampleAge);
        Simpsons = 0;
        CommCell = dataset2cell(Genusdataset(i,3:end));
        CommMat = cell2mat(CommCell(2,:));
        n = nnz(CommMat);
        for j = 1:size(CommMat,2);
            Simpsons = Simpsons + (CommMat(j)/n)^2;
        end
        n = nnz(GHdata(i,:));
        for k = 1:size(GHdata,2);
            SimpsonsGH =Simpsons + (GHdata(i,j)/n)^2;
        end
        SimpsonsGH = 0;
        GHCell = dataset2cell(Genusdataset(i,3:end));
        GHMat = cell2mat(CommCell(2,:));
        n = nnz(GHMat);
        for k = 1:size(GHMat,2);
            SimpsonsGH = SimpsonsGH + (GHMat(j)/n)^2;
        end
        if (SampleAge >= Agecutoff);
            Over = [Over,Simpsons];
            OverGH = [OverGH,SimpsonsGH];
            OverSample = [OverSample,SampleAge];
            OverAntiTime = [OverAntiTime, AntiBiodataset.Type{i}];
            OverAntiClass = [OverAntiClass, AntiClass];
            OverAntiName = [OverAntiName,AntiBiodataset.Antibiotic{i}];
            OverGH = [OverGH, SimpsonsGH];
            
        elseif (SampleAge < Agecutoff);
            Under = [Under,Simpsons];
            UnderGH = [UnderGH, SimpsonsGH];
            UnderSample = [UnderSample,SampleAge];
            UnderAntiTime = [UnderAntiTime, AntiBiodataset.Type{i}];
            UnderAntiClass = [UnderAntiClass, AntiClass];
            UnderAntiName = [UnderAntiName,AntiBiodataset.Antibiotic{i}];
            UnderGH = [UnderGH, SimpsonsGH];
        end
    end
end

%% Plot boxplot of ages
group1 = [repmat({'Older than 50'}, 1203,1); repmat({'Younger than 50'},723,1)];
groupnum = [Over';Under'];
boxplot(groupnum,group1)

%% Plot boxplot of ages and antibiotic time
% First, find all instances of time
weektimeUnder = logical(cell2mat(cellfun(@(x) strcmpi(x, 'week'), UnderAntiTime,...
    'Uniformoutput', false)));
weektimeOver = logical(cell2mat(cellfun(@(x) strcmpi(x, 'week'), OverAntiTime,...
    'Uniformoutput', false)));
motimeUnder = logical(cell2mat(cellfun(@(x) strcmpi(x, 'month'), UnderAntiTime,...
    'Uniformoutput', false)));
motimeOver = logical(cell2mat(cellfun(@(x) strcmpi(x, 'month'), OverAntiTime,...
    'Uniformoutput', false)));
sixmotimeUnder = logical(cell2mat(cellfun(@(x) strcmpi(x, '6month'), UnderAntiTime,...
    'Uniformoutput', false)));
sixmotimeOver = logical(cell2mat(cellfun(@(x) strcmpi(x, '6month'), OverAntiTime,...
    'Uniformoutput', false)));
yearTimeUnder = logical(cell2mat(cellfun(@(x) strcmpi(x, 'year'), UnderAntiTime,...
    'Uniformoutput', false)));
yearTimeOver = logical(cell2mat(cellfun(@(x) strcmpi(x, 'year'), OverAntiTime,...
    'Uniformoutput', false)));
multyearTimeUnder = logical(cell2mat(cellfun(@(x) strcmpi(x, 'multipleyear'), UnderAntiTime,...
    'Uniformoutput', false)));
multyearTimeOver = logical(cell2mat(cellfun(@(x) strcmpi(x, 'multipleyear'), OverAntiTime,...
    'Uniformoutput', false)));

% Second, narrow down variables to time
weekUnder = Under(weektimeUnder);
weekOver = Over(weektimeOver);
moUnder = Under(motimeUnder);
moOver = Over(motimeOver);
sixmoUnder = Under(sixmotimeUnder);
sixmoOver = Over(sixmotimeOver);
yearUnder = Under(yearTimeUnder);
yearOver = Over(yearTimeOver);
multiyearUnder = Under(multyearTimeUnder);
multiyearOver = Over(multyearTimeOver);

% Boxplot
group2 = [repmat({'Week: <50'}, size(weekUnder,2), size(weekUnder,1)); repmat({'Week: >50'},...
    size(weekOver,2),size(weekOver,1)); repmat({'Month: <50'},...
    size(moUnder,2),size(moUnder,1)); repmat({'Month: >50'},...
    size(moOver,2), size(moOver,1)); repmat({'6 Month: <50'},...
    size(sixmoUnder,2),size(sixmoUnder,1)); repmat({'6 Month: >50'},...
    size(sixmoOver,2), size(sixmoOver,1));repmat({'Year: < 50'},...
    size(yearUnder,2),size(yearUnder,1));repmat({'Year: > 50'},...
    size(yearOver,2),size(yearOver,1)); repmat({'Multiple Years: < 50'},...
    size(multiyearUnder,2),size(multiyearUnder,1)); repmat({'Multiple Years: >50'},...
    size(multiyearOver,2),size(multiyearOver,1))];
groupnum2=[weekUnder';weekOver';moUnder';moOver';sixmoUnder';sixmoOver';yearUnder';yearOver';multiyearUnder';multiyearOver'];
boxplot(groupnum2,group2) 

%% Plot Boxplot of ages and antibiotic types
% Note: there don't seem to be enough of each type to do any analysis

Type1Under = UnderAntiClass(find(UnderAntiClass == 1));
Type1Over = OverAntiClass(find(OverAntiClass == 1));

Type2Under = UnderAntiClass(find(UnderAntiClass == 3));
Type2Over = OverAntiClass(find(OverAntiClass == 3));

Type3Under = UnderAntiClass(find(UnderAntiClass == 5));
Type3Over = OverAntiClass(find(OverAntiClass == 5));

Type12Under = UnderAntiClass(find(UnderAntiClass == 4));
Type12Over = OverAntiClass(find(OverAntiClass == 4));

Type13Under = UnderAntiClass(find(UnderAntiClass == 6));
Type13Over = OverAntiClass(find(OverAntiClass == 6));

Type23Under = UnderAntiClass(find(UnderAntiClass == 8));
Type23Over = OverAntiClass(find(OverAntiClass == 8));

AllType1Under = [Type1Under,Type12Under,Type13Under];
AllType1Over = [Type1Over, Type12Over,Type13Over];

AllType2Under = [Type2Under,Type12Under,Type23Under];
AllType2Over = [Type2Over,Type12Over,Type23Over];

AllType3Under = [Type3Under,Type13Under,Type23Under];
AllType3Over = [Type3Over,Type13Over,Type23Over];

group3 =[repmat({'Type1: <50'}, size(AllType1Under,2),1); repmat({'Type1: >50'},...
    size(AllType1Over,2),1); repmat({'Type2: <50'}, size(AllType2Under,2),1); repmat({'Type2: >50'},...
    size(AllType2Over,2),1); repmat({'Type3: <50'}, size(AllType3Under,2),1); repmat({'Type3: >50'},...
    size(AllType3Over,2),1)];
    
boxplot([AllType1Under';AllType1Over';AllType2Under';AllType2Over';AllType3Under';AllType3Over'],group3);

%% Antibiotic and age

boxplot([Over';Under'],[OverAntiName';UnderAntiName'])