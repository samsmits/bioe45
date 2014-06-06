% This program sorts text responses about what antibiotics each respondent
% took into 4 classes of antibiotic based on mechanism: 1. Inhibit
% peptidoglycan synthesism 2. Inhibit protein synthesis 3. Inhibit DNA
% gyrase 4. Other. Text responses that could not be identified as
% responding to a specific antibiotic were ignored entirely.

load('SampleID_antibiotic_meds.mat') % loads original text responses

SampleID_antibiotics(:,2) = lower(SampleID_antibiotics(:,2));
% Short strings the program will recognize in responses as corresponding to
% specific antibiotics. The length of this cell array is because of the
% amount of typographical errors in the text responses
uniqueAntibiotics = {'alvelox';'amixicylin';'amoxi';'ampi';'aug';'azr';'bac';'bes';'cefa';'cefd';'ceft';'cefo';'cephad';'cephal';'cephl';'cipro';'clarithro';'clavulanate';'chlorhexidine';'clinda';'clynda';'co-trimoxazole';'cycla';'doxy';'ery';'eth';'fla';'flucl';'fluco';'iverm';'gluconate';'kef';'lansop';'levaflo';'levoflox';'levaq';'levoq';'macrob';'metronid';'metro gel';'microfura';'minocy';'moxiflox';'muciprin';'neomycin';'nitrofur';'norfloxa';'omnicef';'omoxic';'oregano';'paro';'penic';'rimadyl';'rifamp';'rifaximin';'rivaximin';'rocephin';'secniz';'septra';'smz';'solodyn';'sul';'tetra';'tinidazole';'tindamax';'vancomycin';'vigamox';'xifax';'zit';'zyt';'zocin';'zosyn';'z pac';'z-pac';'zpac';'c pack'};

% Antibiotic categories:
% Inhibit peptidoglycan synthesis
type1 = 'amixicylin,amoxicillin,ampicillin,augmentin,cefadroxil,cefdinir,ceftin,cefotaxime,cefuroxime,cephalexin,cephl,clavulanate,flucloxacillin,kef,lansopraz,omnicef,omoxicillin,penic,rocephin,zocin,zosyn';
% Inhibit protein synthesis
type2 = 'azr,clarithromycin,clinda,clynda,cyclamine,doxy,ery,eth,ivermectin,lansopraz,minocylin,muciprin,neomycin,paromomycin,solodyn,tetra,zit,zyt,zocin,zosyn,z pack,z-pac,zpac,c pack';
% Inhibit DNA gyrase
type3 = 'alvelox,besifloxacin,cipro,levofloxacin,levaflo,levaquin,levoquin,moxifloxacin,norfloxacin,vigamox';
BroadCategories = {type1; type2; type3};

% Preallocates space
for row = 1:length(SampleID_antibiotics(:,1))
    SampleID_antibiotics{row,3} = 0; % type 1
    SampleID_antibiotics{row,4} = 0; % type 2
    SampleID_antibiotics{row,5} = 0; % type 3
    SampleID_antibiotics{row,6} = 0; % other
end

for i = 1:length(uniqueAntibiotics) % loops through each antibiotic to sort
    % search responses for shortened names of antibiotics
    matchesIndices = strfind(SampleID_antibiotics(:, 2), uniqueAntibiotics{i});
    % bin antibiotic into category
    % category will be 3x1 cell array with empty values or 1s
    category = strfind(BroadCategories, uniqueAntibiotics{i})';
    for j = 1:length(matchesIndices) % should be the same as length SampleID_antibiotics(:, 2)
        for k = 3:5
            if ~isempty(matchesIndices{j})
                if ~isempty(category{1}) || ~isempty(category{2}) || ~isempty(category{3})
                    SampleID_antibiotics{j, k} = SampleID_antibiotics{j, k} + length(category{k - 2});
                end
            end
        end
        if ~isempty(matchesIndices{j}) && (isempty(category{1}) && isempty(category{2}) && isempty(category{3}))
            % Store antibiotics that don't fall into a category
            SampleID_antibiotics{j, 6} = SampleID_antibiotics{j, 6} + 1;
        end
    end
end