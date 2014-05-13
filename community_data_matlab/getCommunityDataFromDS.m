function [ combinedDS ] = getCommunityDataFromDS(comDS, metaDS,taxLevel,bacteria)
%This function outputs a dataset of community abundance for each sample at
%a specified taxonomic level.
%
% comDS:  the community dataset from the file all-assignments.csv
%
% metaDS: the metadata dataset from the file
% allMetadata_underscoreHeaders.csv
%
% taxLevel: 1-6 1 being less specific (phyla) and 6 being most specific
% (species)
%
% bacteria: T/F indicating whether only bacteria or bacteria and other
% samples are included

DefaultCommDS = comDS(:,[1 3 4 (4+taxLevel) 11]);

% convert numeric taxa level to text
if taxLevel == 1;
    taxa = 'phylum';
elseif taxLevel == 2;
    taxa = 'class';
elseif taxLevel == 3;
    taxa = 'order';
elseif taxLevel == 4;
    taxa = 'family';
elseif taxLevel == 5;
    taxa = 'genus';
elseif taxLevel == 6;
    taxa = 'species';
end
        

MyCommDS = DefaultCommDS;

% remove all non-bacteria
if bacteria
    EukIndex=cellfun(@(x)strcmpi(x,'Eukaryota'), comDS.domain, 'Uniformoutput',false);
    ArchIndex=cellfun(@(x)strcmpi(x,'Archaea'), comDS.domain, 'Uniformoutput',false);
    NonBacIndex = cell2mat(EukIndex) + cell2mat(ArchIndex);
    posIndexLogical = logical(~NonBacIndex);
    MyCommDS = MyCommDS(posIndexLogical,:);
end

% look for each sample in community data
for i = 1:length(metaDS);
    study = metaDS.Study{i};
    sampleID = metaDS.Sample_Identifier{i};
    
    % Each sample has different formatting
    if strcmpi('American_gut_project', study) ;
        id = 17;
        % no change
        studyIndex = find(MyCommDS.id==id);
    elseif strcmpi('timeseries', study)
        id = 14;
        % no change
        studyIndex = find(MyCommDS.id==id);
    elseif strcmpi('Muegge', study);
        id = 16;
        % wrong case
        studyIndex = find(MyCommDS.id==id);
    elseif strcmpi('Yatsunenko', study);
        id = 9;
        % compare only length of sampleID
        studyIndex = find(MyCommDS.id==id);
    elseif strcmpi('ELDERMET', study);
        id = 5
        % compare only length of sampleID
        studyIndex = find(MyCommDS.id==id);
    end
    
    studyDS = MyCommDS(studyIndex,:);
    
    
    
    if (id == 5 ) || (id == 9)
        sampleIndex = cellfun(@(x) strncmpi(x, sampleID,length(sampleID)),...
            studyDS.name, 'Uniformoutput', false);
    elseif (id == 17);
        combSample = strcat('00000', sampleID);
        sampleIndex = cellfun(@(x) strncmpi(x, combSample, 9),...
            studyDS.name, 'Uniformoutput', false);
    else
        sampleIndex = cellfun(@(x) strcmpi(x, sampleID),...
            studyDS.name, 'Uniformoutput', false);
    end
    
    sampleIndexLogical = logical(cell2mat(sampleIndex));
    
    K = find(sampleIndexLogical>0);
    
    if (numel(K)>0)
        sampleDS = studyDS(sampleIndexLogical,:);
        uniqueTax = unique(sampleDS.(taxa));
        abundanceDS = findAbundance(sampleDS, taxa, uniqueTax); 
    end
    
    if i > 1;
        combinedDS = join(abundanceDS, combinedDS, 'type', 'fullouter', 'mergekeys', true);
    else
        combinedDS = abundanceDS;
    end
end
