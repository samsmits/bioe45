

%name
sampleInfo = communitydataset;
outlier1 = cell2mat(cellfun(@(x) strcmpi(x,'191 ELDERMET samples'),...
    sampleInfo.name,'UniformOutput',false));
outlier2 = cell2mat(cellfun(@(x) strcmpi(x,...
    '1Rehmannia_glutinosa1_phytoplasma'),sampleInfo.species,'UniformOutput',...
    false));
index1 = find(logical(outlier1) ==1);
index2 = find(logical(outlier2) == 1);
for outliers1 = 1:numel(index1);
    sampleInfo.name{index1(outliers1)} = 'ELDERMET_191_samples';
end
for outliers2 = 1:numel(index2);
    sampleInfo.name{index2(outliers2)} = 'Rehmannia_glutinosa1_phytoplasma';
end
sampleInfo(end-2:end,:) = [];


for i = 1:length(sampleInfo);
%     id = sampleInfo.id(i);
%     if id == 17;
%        study = 'American_gut_project';
%     elseif id == 5;
%        study = 'ELDERMET';
%     elseif id == 14;
%        study = 'timeseries';
%     elseif id == 16;
%        study = 'Muegge';
%     elseif id == 9;
%        study = 'Yatsunenko';
%     end
   
    names = makeValidFieldName(sampleInfo.name{i});
    domain = sampleInfo.domain{i};
    if ~strcmpi(domain,'-');
        phylum = sampleInfo.phylum{i};
        if ~strcmpi(phylum,'-');
            phylum = makeValidFieldName(sampleInfo.phylum{i});
            class = sampleInfo.class{i};
            if ~strcmpi(class,'-');
                class = makeValidFieldName(sampleInfo.class{i});
                order = sampleInfo.order{i};
                if ~strcmpi(order,'-');
                    order = makeValidFieldName(sampleInfo.order{i});
                    family = sampleInfo.family{i};
                    if ~strcmpi(family,'-');
                        family = makeValidFieldName(sampleInfo.family{i});
                        genus = sampleInfo.genus{i};
                        if ~strcmpi(genus,'-');
                            genus = makeValidFieldName(sampleInfo.genus{i});
                            species = sampleInfo.species{i};
                            if ~strcmpi(species,'-');
                                species = makeValidFieldName(sampleInfo.species{i});
                                communityStruct.(names).(phylum).(order).(family).(genus).(species) = sampleInfo.abundance(i);
                            end
                        end
                    end
                end
            end
        end
    end
end

    

