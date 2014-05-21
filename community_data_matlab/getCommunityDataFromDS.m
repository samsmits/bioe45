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

MyCommDS = comDS(:,[1 3 4 (4+taxLevel) 11]);

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

% remove all non-bacteria
if bacteria
    BacIndex=cellfun(@(x)strcmpi(x,'Bacteria'), comDS.domain, 'Uniformoutput',false);
    posIndexLogical = logical(cell2mat(BacIndex));
    MyCommDS = MyCommDS(posIndexLogical,:);
end

%Find uniqe taxa
uniqueTax = unique(MyCommDS.(taxa));
uniqueTax = uniqueTax(2:end); %remove '-'


sampleVec = {};
oldID = 0;


% look for each sample in community data
for i = 1:length(metaDS);
    tic
    study = metaDS.Study{i};
    sampleID = metaDS.Sample_Identifier{i};
   
    % Each sample has different formatting
    if strcmpi('American_gut_project', study) ;
        id = 17;
        % no change
    elseif strcmpi('timeseries', study)
        id = 14;
        % no change
    elseif strcmpi('Muegge', study);
        id = 16;
        % wrong case
    elseif strcmpi('Yatsunenko', study);
        id = 9;
        % compare only length of sampleID
    elseif strcmpi('ELDERMET', study);
        id = 5
        % compare only length of sampleID
    end
    
    if oldID ~= id;
        
        studyIndex = find(MyCommDS.id==id);
    
        studyDS = MyCommDS(studyIndex,2:end);
    end
    
    
  
        
    if (id == 5 ) || (id == 9)
        sampleIndex = cellfun(@(x) strncmpi(x, sampleID,length(sampleID)),...
            studyDS.name, 'Uniformoutput', false);
    elseif (id == 17);
        finddot = findstr(sampleID, '.');
        if finddot ==5;
            sampleID = strcat('00000', sampleID);
        else
            sampleID = strcat('0000', sampleID);
        end
        while size(sampleID) < 16;
            sampleID = strcat(sampleID,'0');
        end
        sampleIndex = cellfun(@(x) strncmpi(x, sampleID, length(sampleID)),...
            studyDS.name, 'Uniformoutput', false);
    else
        sampleIndex = cellfun(@(x) strcmpi(x, sampleID),...
            studyDS.name, 'Uniformoutput', false);
    end
    
    sampleIndexLogical = logical(cell2mat(sampleIndex));
    
    K = find(sampleIndexLogical>0);
    
    if (numel(K)>0)
        sampleVec{i} = sampleID;
        sampleDS = studyDS(sampleIndexLogical,:);
        sampleuniqueTax = unique(sampleDS.(taxa));
        sampleID = {sampleID};
        abundanceDS = findAbundance(sampleDS, taxa, sampleuniqueTax,sampleID); 
        %abundanceVec = findAbundanceVec(sampleDS,taxa,uniqueTax);
        %idCell = {'Sample_Identifier'; sampleID};
        %abundanceDS = join(cell2dataset(idCell), abundanceDS,'type','fullouter', 'mergekeys', true);
    end
 
    %abundanceMat(i,:) = abundanceVec;
    if i > 1;
        disp(sampleID)
        combinedDS = join(abundanceDS, combinedDS, 'type', 'fullouter', 'mergekeys', true);
    else
        combinedDS = abundanceDS;
    end
    
    oldID = id;
    toc
end

