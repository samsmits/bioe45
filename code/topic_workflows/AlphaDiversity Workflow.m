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
%%               
GHdata = [GHprofile_antibiotic_6month;GHprofile_antibiotic_month; GHprofile_antibiotic_multipleyear; GHprofile_antibiotic_year; GHprofile_antibiotic_week];
temp = cellstr(agp_sampleID);
GHID = [temp(Index_antibiotic_6month); temp(Index_antibiotic_month); temp(Index_antibiotic_multipleyear);temp(Index_antibiotic_year); temp(Index_antibiotic_week);]
    
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
        t = 0;
        index = logical(cell2mat(cellfun(@(x) strncmpi(x, AntiBiodataset.SampleID(i), length(x)),...
            GHID, 'Uniformoutput', false)));
        t = find(index == 1);
        n = nnz(GHdata(i,:));
        if t>0;
            for k = 1:size(GHdata,2);
                SimpsonsGH =Simpsons + (GHdata(t,k)/n)^2;
            end
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
group1 = [repmat({'Older than 55'}, 1203,1); repmat({'Younger than 55'},723,1)];
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
    
boxplot([AllType1Under';AllType1Over';AllType2Under';AllType2Over';AllType3Under';AllType3Over'],group3)

%% Antibiotic and age

boxplot([Over';Under'],[OverAntiName';UnderAntiName'])

%% Susceptible GH profiles
HealthyGH8 = zeros(1,size(GHprofile_antibiotic_multipleyear,1))

sumHealthy = sum(GHprofile_antibiotic_multipleyear');
for i = 1:size(GHprofile_antibiotic_multipleyear,1);
    HealthyGH8(i) = GHprofile_antibiotic_multipleyear(i,8)/sumHealthy(i);
    HealthyGH24(i) = GHprofile_antibiotic_multipleyear(i,24)/sumHealthy(i);
    HealthyGH35(i) = GHprofile_antibiotic_multipleyear(i,35)/sumHealthy(i);
    HealthyGH43(i) = GHprofile_antibiotic_multipleyear(i,43)/sumHealthy(i);
    HealthyGH102(i) = GHprofile_antibiotic_multipleyear(i,102)/sumHealthy(i);
    HealthyGH103(i) = GHprofile_antibiotic_multipleyear(i,103)/sumHealthy(i);
    HealthyGH114(i) = GHprofile_antibiotic_multipleyear(i,114)/sumHealthy(i);
end
HealthyGH102(216) = [];
HealthyGH35(find(HealthyGH35 == max(HealthyGH35))) = [];

sumsixMo = sum(GHprofile_antibiotic_6month');
for i = 1:size(GHprofile_antibiotic_6month);
    sixMoGH8(i) = GHprofile_antibiotic_6month(i,8)/sumsixMo(i);
    sixMoGH24(i) = GHprofile_antibiotic_6month(i,24)/sumsixMo(i);
    sixMoGH35(i) = GHprofile_antibiotic_6month(i,35)/sumsixMo(i);
    sixMoGH43(i) = GHprofile_antibiotic_6month(i,43)/sumsixMo(i);
    sixMoGH102(i) = GHprofile_antibiotic_6month(i,102)/sumsixMo(i);
    sixMoGH103(i) = GHprofile_antibiotic_6month(i,103)/sumsixMo(i);
    sixMoGH114(i) = GHprofile_antibiotic_6month(i,114)/sumsixMo(i);
end

for i = 1:size(GHprofile_antibiotic_month);
sumMo = sum(GHprofile_antibiotic_month');
    MoGH8(i) = GHprofile_antibiotic_month(i,8)/sumMo(i);
    MoGH24(i) = GHprofile_antibiotic_month(i,24)/sumMo(i);
    MoGH35(i) = GHprofile_antibiotic_month(i,35)/sumMo(i);
    MoGH43(i) = GHprofile_antibiotic_month(i,43)/sumMo(i);
    MoGH102(i) = GHprofile_antibiotic_month(i,102)/sumMo(i);
    MoGH103(i) = GHprofile_antibiotic_month(i,103)/sumMo(i);
    MoGH114(i) = GHprofile_antibiotic_month(i,114)/sumMo(i);
end

sumYe = sum(GHprofile_antibiotic_year');
for i = 1:size(GHprofile_antibiotic_year);
    YeGH8(i) = GHprofile_antibiotic_year(i,8)/sumYe(i);
    YeGH24(i) = GHprofile_antibiotic_year(i,24)/sumYe(i);
    YeGH35(i) = GHprofile_antibiotic_year(i,35)/sumYe(i);
    YeGH43(i) = GHprofile_antibiotic_year(i,43)/sumYe(i);
    YeGH102(i) = GHprofile_antibiotic_year(i,102)/sumYe(i);
    YeGH103(i) = GHprofile_antibiotic_year(i,103)/sumYe(i);
    YeGH114(i) = GHprofile_antibiotic_year(i,114)/sumYe(i);
end

sumWe = sum(GHprofile_antibiotic_week');
for i = 1:size(GHprofile_antibiotic_week);
    WeGH8(i) = GHprofile_antibiotic_week(i,8)/sumWe(i);
    WeGH24(i) = GHprofile_antibiotic_week(i,24)/sumWe(i);
    WeGH35(i) = GHprofile_antibiotic_week(i,35)/sumYe(i);
    WeGH43(i) = GHprofile_antibiotic_week(i,43)/sumYe(i);
    WeGH102(i) = GHprofile_antibiotic_week(i,102)/sumWe(i);
    WeGH103(i) = GHprofile_antibiotic_week(i,103)/sumWe(i);
    WeGH114(i) = GHprofile_antibiotic_week(i,114)/sumWe(i);
end

group4 =[repmat({'Multiple year'}, size(HealthyGH8,2),1); repmat({'Year'},...
    size(YeGH8,2),1); repmat({'6 Month'}, size(sixMoGH8,2),1); repmat({'Month'},...
    size(MoGH8,2),1); repmat({'Week'}, size(WeGH8,2),1)];
Cat = [HealthyGH8';YeGH8';sixMoGH8'; MoGH8';WeGH8'];
b=boxplot(Cat,group4);
ylabel('Percent of total GH');
title('GH08');
set(b(7,:),'Visible','off')

randSample1 = randi([1,size(MoGH8,2)],1,50);
randSample2 = randi([1,size(HealthyGH8,2)],1,50);
[h, p] = ttest2(MoGH8(randSample1), HealthyGH8(randSample2), 0.05,'right', 'unequal')
% The above t-test, tests the hypothesis that the GH abundancies between  
% people that have taken antibiotics within the past week differ 
% significantly from those who have taken antibiotics multiple years ago. 
% The null hypothesis is that the difference is zero


%%
figure,
b = boxplot([HealthyGH24';YeGH24';sixMoGH24'; MoGH24';WeGH24'],group4);
ylabel('Percent of total GH');
title('GH24');
set(b(7,:),'Visible','off')
ylim([-0.0001 0.003])

randSample1 = randi([1,size(HealthyGH24,2)],1,500);
randSample2 = randi([1,size(sixMoGH24,2)],1,50);
[h, p] = ttest2(HealthyGH24(randSample1), sixMoGH24, 0.05,'right', 'unequal')
[h, p] = ttest2(WeGH24, sixMoGH24(randSample2), 0.05,'right', 'unequal')

% The above t-test, tests the hypothesis that the GH abundancies between  
% people that have taken antibiotics within the past week differ 
% significantly from those who have taken antibiotics multiple years ago. 
% The null hypothesis is that the difference is zero
%%
figure,
h=boxplot([HealthyGH103';YeGH103';sixMoGH103'; MoGH103';WeGH103'],group4);
ylabel('Percent of total GH');
title('GH103');
set(h(7,:),'Visible','off')
ylim([-0.0001 0.008])

randSample = randi([1,size(HealthyGH103,2)],1,500);
[h, p] = ttest2(HealthyGH103(randSample), sixMoGH103, 0.05,'right', 'unequal')% The above t-test, tests the hypothesis that the GH abundancies between  
% people that have taken antibiotics within the past week differ 
% significantly from those who have taken antibiotics multiple years ago. 
% The null hypothesis is that the difference is zero
%%
figure,
h=boxplot([HealthyGH114';YeGH114';sixMoGH114'; MoGH114';WeGH114'],group4);
ylabel('Percent of total GH');
title('GH114');
set(h(7,:),'Visible','off')

randSample = randi([1,size(HealthyGH114,2)],1,50);
[h, p] = ttest2(HealthyGH114(randSample), WeGH114, 0.05,'right', 'unequal')
% The above t-test, tests the hypothesis that the GH abundancies between  
% people that have taken antibiotics within the past week differ 
% significantly from those who have taken antibiotics multiple years ago. 
% The null hypothesis is that the difference is zero
%%
figure,
h=boxplot([HealthyGH43';YeGH43';sixMoGH43'; MoGH43';WeGH43'],group4);
ylabel('Percent of total GH');
title('GH43');
set(h(7,:),'Visible','off')
ylim([-0.0001 0.0007])

randSample = randi([1,size(HealthyGH43,2)],1,50);
[h, p] = ttest2(YeGH43, WeGH43, 0.05,'right', 'unequal')
% The above t-test, tests the hypothesis that the GH abundancies between  
% people that have taken antibiotics within the past week differ 
% significantly from those who have taken antibiotics multiple years ago. 
% The null hypothesis is that the difference is zero
%%

group5 =[repmat({'Multiple year'}, size(HealthyGH102,2),1); repmat({'Year'},...
    size(YeGH8,2),1); repmat({'6 Month'}, size(sixMoGH8,2),1); repmat({'Month'},...
    size(MoGH8,2),1); repmat({'Week'}, size(WeGH8,2),1)];
%%
figure,
h=boxplot([HealthyGH102';YeGH102';sixMoGH102'; MoGH102';WeGH102'],group5);
ylabel('Percent of total GH');
title('GH102');
set(h(7,:),'Visible','off')
ylim([-0.0001 0.0008])

randSample = randi([1,size(HealthyGH102,2)],1,50);
[h, p] = ttest2(HealthyGH102(randSample), MoGH102, 0.05,'right', 'unequal')
% The above t-test, tests the hypothesis that the GH abundancies between  
% people that have taken antibiotics within the past week differ 
% significantly from those who have taken antibiotics multiple years ago. 
% The null hypothesis is that the difference is zero
%%
figure,
h=boxplot([HealthyGH35';YeGH35';sixMoGH35'; MoGH35';WeGH35'],group5);
ylabel('Percent of total GH');
title('GH35');
ylim([-0.00001 0.0001])
set(h(7,:),'Visible','off')
ylim([-0.00001 0.00008])

randSample = randi([1,size(HealthyGH35,2)],1,500);
[h, p] = ttest2(HealthyGH35(randSample), sixMoGH35, 0.05,'right', 'equal')
% The above t-test, tests the hypothesis that the GH abundancies between  
% people that have taken antibiotics within the past week differ 
% significantly from those who have taken antibiotics multiple years ago. 
% The null hypothesis is that the difference is zero

%%
%% GH35 Age Difference

for i = 1:size(metadataset,1);
    sampleID  = metadataset.Sample_Identifier{i}
    finddot = findstr(sampleID, '.');
        if finddot ==5;
            sampleID = strcat('00000', sampleID);
        else
            sampleID = strcat('0000', sampleID);
        end
        while size(sampleID) < 16;
            sampleID = strcat(sampleID,'0');
        end
    metadataset.Sample_Identifier{i} = sampleID;
end
%% All ages
AgeTimeless = [];
AntibioticTaken = {};
for i = 1:size(GHID,1);
    sampleID = GHID{i};
    sampleIndex = cellfun(@(x) strncmpi(x, sampleID, 15),...
        metadataset.Sample_Identifier, 'Uniformoutput', false);
    
    sampleIndexLogical = logical(cell2mat(sampleIndex));
    
    n = find(sampleIndexLogical == 1)
    
    if n >=1
        AntibioticTaken{i} = metadataset.Antibiotic_Meds{n(1)};
        HowOld = str2num(metadataset.Age{n(1)});
        if isempty(HowOld);
        AgeTimeless(i) = nan;
        else 
        AgeTimeless(i) = HowOld;
        end
    else 
        AgeTimeless(i) = nan;
    end
end
%%
AgeTime = AgeTimeless;

sumGHdata = sum(GHdata');


GHdata35 = GHdata(:,08)./sumGHdata' + GHdata(:,24)./sumGHdata' + GHdata(:,35)./sumGHdata' + GHdata(:,43)./sumGHdata' + GHdata(:,102)./sumGHdata' + GHdata(:,103)./sumGHdata' + GHdata(:,114)./sumGHdata';

GHdata35 = GHdata35/7;
%normGHdata35 = GHdata35./sumGHdata';

%SimpsonsGHdata = (GHdata/35).^2;

%normGHdata35 = sum(SimpsonsGHdata')';

Antibiotic = AntibioticTaken;


MYear = normGHdata35(1:1422);
AgeMYear = AgeTime(1:1422);
AntiMYear = Antibiotic(1:1422);
normGHdata35(1:1422) = [];
AgeTime(1:1422) = [];
Antibiotic(1:1422) = [];
Year = normGHdata35(1:262);
AgeYear = AgeTime(1:262);
AntiYear = Antibiotic(1:262);
normGHdata35(1:262) = [];
AgeTime(1:262) = [];
Antibiotic(1:262) = [];
sixMonth = normGHdata35(1:255);
Age6Mo = AgeTime(1:255);
Anti6Mo = Antibiotic(1:255);
normGHdata35(1:255) = [];
AgeTime(1:255) = [];
Antibiotic(1:255) = [];
Month = normGHdata35(1:59);
AgeMo = AgeTime(1:59);
AntiMo = Antibiotic(1:59);
normGHdata35(1:59) = [];
AgeTime(1:59) = [];
Antibiotic(1:59) = [];
Week = normGHdata35;
AgeWeek = AgeTime;
AntiWeek = Antibiotic;


% Age considerations (cutoff = 55)
OlderMYear = MYear(find(AgeMYear >=55));
YoungerMYear = MYear(find(AgeMYear <=55));
OlderYear = Year(find(AgeYear >=55));
YoungerYear = Year(find(AgeYear <=55));
Older6Mo = sixMonth(find(Age6Mo >=55));
Younger6Mo = sixMonth(find(Age6Mo <=55));
OlderMo = Month(find(AgeMo >=55));
YoungerMo = Month(find(AgeMo <=55));
OlderWe = Week(find(AgeWeek >=55));
YoungerWe = Week(find(AgeWeek <=55));

% Antibiotic Types
type1 = {'amixicylin','amoxicillin','ampicillin','augmentin','cefadroxil','cefdinir','ceftin','cefotaxime','cefuroxime','cephalexin','cephl','clavulanate','flucloxacillin','kef','lansopraz','omnicef','omoxicillin','penic','rocephin','zocin','zosyn'};
% Inhibit protein synthesis
type2 = {'azr','Azi','clarithromycin','clinda','clynda','cyclamine','doxy','ery','eth','ivermectin','lansopraz','minocylin','muciprin','neomycin','paromomycin','solodyn','tetra','zit','zyt','zocin','zosyn','z pack','z-pac','zpac','c pack'};
% Inhibit DNA gyrase
type3 = {'alvelox','besifloxacin','cipro','levofloxacin','levaflo','levaquin','levoquin','moxifloxacin','norfloxacin','vigamox'};

T1MYeIndex = zeros(size(AntiMYear));
T1YeIndex = zeros(size(AntiYear));
T16MoIndex = zeros(size(Anti6Mo));
T1MoIndex = zeros(size(AntiMo));
T1WeIndex = zeros(size(AntiWeek));

for ty = 1:size(type1,2);
T1MYeIndex = T1MYeIndex + cell2mat(cellfun(@(x) strncmpi(x, type1(ty), length(type1{ty})),...
        AntiMYear, 'Uniformoutput', false));
T1YeIndex = T1YeIndex +cell2mat(cellfun(@(x) strncmpi(x, type1(ty), length(type1{ty})),...
        AntiYear, 'Uniformoutput', false));
T16MoIndex = T16MoIndex + cell2mat(cellfun(@(x) strncmpi(x, type1(ty), length(type1{ty})),...
        Anti6Mo, 'Uniformoutput', false));
T1MoIndex = T1MoIndex + cell2mat(cellfun(@(x) strncmpi(x, type1(ty), length(type1{ty})),...
        AntiMo, 'Uniformoutput', false));
T1WeIndex = T1WeIndex + cell2mat(cellfun(@(x) strncmpi(x, type1(ty), length(type1{ty})),...
        AntiWeek, 'Uniformoutput', false));
end

T2MYeIndex = zeros(size(AntiMYear));
T2YeIndex = zeros(size(AntiYear));
T26MoIndex = zeros(size(Anti6Mo));
T2MoIndex = zeros(size(AntiMo));
T2WeIndex = zeros(size(AntiWeek));

for ty = 1:size(type2,2);
T2MYeIndex = T2MYeIndex + cell2mat(cellfun(@(x) strncmpi(x, type2(ty), length(type2{ty})),...
        AntiMYear, 'Uniformoutput', false));
T2YeIndex = T2YeIndex +cell2mat(cellfun(@(x) strncmpi(x, type2(ty), length(type2{ty})),...
        AntiYear, 'Uniformoutput', false));
T26MoIndex = T26MoIndex + cell2mat(cellfun(@(x) strncmpi(x, type2(ty), length(type2{ty})),...
        Anti6Mo, 'Uniformoutput', false));
T2MoIndex = T2MoIndex + cell2mat(cellfun(@(x) strncmpi(x, type2(ty), length(type2{ty})),...
        AntiMo, 'Uniformoutput', false));
T2WeIndex = T2WeIndex + cell2mat(cellfun(@(x) strncmpi(x, type2(ty), length(type2{ty})),...
        AntiWeek, 'Uniformoutput', false));
end

T3MYeIndex = zeros(size(AntiMYear));
T3YeIndex = zeros(size(AntiYear));
T36MoIndex = zeros(size(Anti6Mo));
T3MoIndex = zeros(size(AntiMo));
T3WeIndex = zeros(size(AntiWeek));

for ty = 1:size(type3,2);
T3MYeIndex = T3MYeIndex + cell2mat(cellfun(@(x) strncmpi(x, type3(ty), length(type3{ty})),...
        AntiMYear, 'Uniformoutput', false));
T3YeIndex = T3YeIndex +cell2mat(cellfun(@(x) strncmpi(x, type3(ty), length(type3{ty})),...
        AntiYear, 'Uniformoutput', false));
T36MoIndex = T36MoIndex + cell2mat(cellfun(@(x) strncmpi(x, type3(ty), length(type3{ty})),...
        Anti6Mo, 'Uniformoutput', false));
T3MoIndex = T3MoIndex + cell2mat(cellfun(@(x) strncmpi(x, type3(ty), length(type3{ty})),...
        AntiMo, 'Uniformoutput', false));
T3WeIndex = T3WeIndex + cell2mat(cellfun(@(x) strncmpi(x, type3(ty), length(type3{ty})),...
        AntiWeek, 'Uniformoutput', false));
end

    
T1MYear = MYear(logical(T1MYeIndex));
T2MYear = MYear(logical(T2MYeIndex));
T3MYear = MYear(logical(T3MYeIndex));
T1Year = MYear(logical(T1YeIndex));
T2Year = MYear(logical(T2YeIndex));
T3Year = MYear(logical(T3YeIndex));
T16Mo = MYear(logical(T16MoIndex));
T26Mo = MYear(logical(T26MoIndex));
T36Mo = MYear(logical(T36MoIndex));
T1Mo = MYear(logical(T1MoIndex));
T2Mo = MYear(logical(T2MoIndex));
T3Mo = MYear(logical(T3MoIndex));
T1We = MYear(logical(T1WeIndex));
T2We = MYear(logical(T2WeIndex));
T3We = MYear(logical(T3WeIndex));


% Antibiotic Boxplot
group5 =[repmat({'Multiple Year: Type 1'}, size(T1MYear,1),1); repmat({'Year: Type 1'},...
    size(T1Year,1),1); repmat({'6 Month: Type 1'},size(T16Mo,1),1); repmat({'Month: Type 1'}, ...
    size(T1Mo,1),1); repmat({'Month: Type 1'}, size(T1We,1),1);];% repmat({'Multiple Year: Type 2'},...
    %size(T2MYear,1),1);repmat({'Year: Type 2'},size(T2Year,1),1);repmat({'6 Month: Type 2'},...
    % size(T26Mo,1),1); repmat({'Month: Type 2'},size(T2Mo,1),1);repmat({'Week: Type 2'},...
    %size(T2We,1),1); repmat({'Multiple Year: Type 3'}, size(T3MYear,1),1);  repmat({'Year: Type 3'}, size(T3Year,1),1); ;repmat({'6 Month: Type 3'}, size(T36Mo,1),1);  ;repmat({'Month: Type 3'}, size(T3Mo,1),1);  repmat({'Week: Type 3'}, size(T3We,1),1)]; 

Cat = [T1MYear;T1Year; T16Mo;T1Mo;T1We];%;T2MYear;T2Year; T26Mo;T2Mo;T2We;T3MYear;T3Year; T36Mo;T3Mo;T3We];
h = boxplot(Cat, group5)
%ylim([-0.000001 0.0001])
set(h(7,:),'Visible','off');
title('GH114')
ylabel('Percent of total GH');


%% Age Boxplot
group6 =[repmat({'Multiple year: >55'}, size(OlderMYear,1),1); repmat({'Multiple year: <55'},...
    size(YoungerMYear,1),1);repmat({'Year: >55'}, size(OlderYear,1),1); repmat({'Year: <55'},...
    size(YoungerYear,1),1);repmat({'6 Month: >55'}, size(Older6Mo,1),1); repmat({'6 Month: <55'},...
    size(Younger6Mo,1),1);repmat({'Month: >55'}, size(OlderMo,1),1); repmat({'Month: <55'},...
    size(YoungerMo,1),1);repmat({'Week: >55'}, size(OlderWe,1),1); repmat({'Week: <55'},...
    size(YoungerWe,1),1)]; 

Cat = [OlderMYear; YoungerMYear; OlderYear; YoungerYear; Older6Mo; Younger6Mo; OlderMo; YoungerMo; OlderWe; YoungerWe];

h = boxplot(Cat,group6)
ylabel('Simpsons Diversity Index');
title('GH profile');
set(h(7,:),'Visible','off')
ylim([-0.000001 0.06])

group7 =[repmat({'>55'}, size(OlderMYear,1),1); repmat({'<55'},...
    size(YoungerMYear,1),1);repmat({'>55'}, size(OlderYear,1),1); repmat({'<55'},...
    size(YoungerYear,1),1);repmat({'>55'}, size(Older6Mo,1),1); repmat({'<55'},...
    size(Younger6Mo,1),1);repmat({'>55'}, size(OlderMo,1),1); repmat({'<55'},...
    size(YoungerMo,1),1);repmat({'>55'}, size(OlderWe,1),1); repmat({'<55'},...
    size(YoungerWe,1),1)]; 
figure,
h = boxplot(Cat, group7);
ylabel('Percent of total GH');
title('GH24 vs Age');
set(h(7,:),'Visible','off')
ylim([-0.00001 0.06])

group8 =[repmat({'Multiple year'}, size(OlderMYear,1),1); repmat({'Multiple year'},...
    size(YoungerMYear,1),1);repmat({'Year'}, size(OlderYear,1),1); repmat({'Year'},...
    size(YoungerYear,1),1);repmat({'6 Month'}, size(Older6Mo,1),1); repmat({'6 Month'},...
    size(Younger6Mo,1),1);repmat({'Month'}, size(OlderMo,1),1); repmat({'Month'},...
    size(YoungerMo,1),1);repmat({'Week'}, size(OlderWe,1),1); repmat({'Week'},...
    size(YoungerWe,1),1)];
figure,
h = boxplot(Cat, group8);
ylabel('Percent of total GH');
title('GH24 vs Age');
set(h(7,:),'Visible','off')
ylim([-0.00001 0.06])