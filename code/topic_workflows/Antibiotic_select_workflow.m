% Workflow for retrieving different groups of people based on when they last took an antibiotic
% Gets both GH abundances and their Sample IDs. 


%% Gets sample ID from all metadata
SampleID = getColumnData('allMetadata.csv', 'Sample Identifier');


%% Gets GH abundance, GH family, and GH sample ID for all GH profile datasets
[agp_GHabundance, agp_GHfamily, agp_sampleID] = tblread('agp.tsv', '\t');
[dts_GHabundance, dts_GHfamily, dts_sampleID] = tblread('diet_time_series.tsv', '\t');
[eldermet_GHabundance, eldermet_GHfamily, eldermet_sampleID] = tblread('eldermet.tsv', '\t');
[muegge_GHabundance, muegge_GHfamily, muegge_sampleID] = tblread('muegge_human.tsv', '\t');
[yatsunenko_GHabundance, yatsunenko_GHfamily, yatsunenko_sampleID] = tblread('yatsunenko.tsv', '\t');

% concatenates all GH abundances together
allGHprofile = vertcat(agp_GHabundance, dts_GHabundance,eldermet_GHabundance, muegge_GHabundance, yatsunenko_GHabundance);


%% Gets the antibiotic status of people from AGP
identifier = cellstr(agp_sampleID); % set identifier variable to sample ID of AGP GH profiles
antibiotic_select = getColumnData('allMetadata.csv', 'Antibiotic Select'); % get column data for Antibiotic Select Field

%% Gets GH profile of people who have been treated with an antibiotic in the past week
antibiotic_week_index = strfind(antibiotic_select,'past week');
antibiotic_week_index = find(~cellfun('isempty', antibiotic_week_index));
SampleID_antibiotic_week = SampleID(antibiotic_week_index); % get Sample IDs of people who have taken antibiotics in the past week
Index_antibiotic_week = find(ismember(identifier(:),SampleID_antibiotic_week(:))); % find the index of people who have taken antibiotics in the past week in the AGP GH profile
GHprofile_antibiotic_week = agp_GHabundance(Index_antibiotic_week,:); % get the GH abundances of people who have taken antibiotics in the past week

%% Gets GH profile of people who have been treated with an antibiotic in the past month
antibiotic_month_index = strfind(antibiotic_select,'past month');
antibiotic_month_index = find(~cellfun('isempty', antibiotic_month_index));
SampleID_antibiotic_month = SampleID(antibiotic_month_index);
Index_antibiotic_month = find(ismember(identifier(:),SampleID_antibiotic_month(:)));
GHprofile_antibiotic_month = agp_GHabundance(Index_antibiotic_month,:); % get the GH abundances of people who have taken antibiotics in the past month


%% Gets GH profile of people who have been treated with an antibiotic in the past 6 months
antibiotic_6month_index = strfind(antibiotic_select,'past 6 months');
antibiotic_6month_index = find(~cellfun('isempty', antibiotic_6month_index));
SampleID_antibiotic_6month = SampleID(antibiotic_6month_index);
Index_antibiotic_6month = find(ismember(identifier(:),SampleID_antibiotic_6month(:)));
GHprofile_antibiotic_6month = agp_GHabundance(Index_antibiotic_6month,:);  % get the GH abundances of people who have taken antibiotics in the past 6 month

%% Gets GH profile of people who haven't been treated with an antibiotic in the last year
antibiotic_year_index = strfind(antibiotic_select,'past year');
antibiotic_year_index = find(~cellfun('isempty', antibiotic_year_index));
SampleID_antibiotic_year = SampleID(antibiotic_year_index);
Index_antibiotic_year = find(ismember(identifier(:),SampleID_antibiotic_year(:)));
GHprofile_antibiotic_year = agp_GHabundance(Index_antibiotic_year,:);  % get the GH abundances of people who have taken antibiotics in the past year

%% Gets GH profile of people who haven't been treated with an antibiotic
antibiotic_multipleyear_index = strfind(antibiotic_select,'last year');
antibiotic_multipleyear_index = find(~cellfun('isempty', antibiotic_multipleyear_index));
SampleID_antibiotic_multipleyear = SampleID(antibiotic_multipleyear_index);
Index_antibiotic_multipleyear = find(ismember(identifier(:),SampleID_antibiotic_multipleyear(:)));
GHprofile_antibiotic_multipleyear = agp_GHabundance(Index_antibiotic_multipleyear,:); 

%% Get the sample IDs for antibiotics
SampleID = getColumnData('allMetadata.csv', 'Sample Identifier');
agp_antibiotics = getColumnData('allMetadata.csv', 'Antibiotic Meds');
SampleID_antibiotics = horzcat(SampleID, agp_antibiotics);

%% Get only sample IDs for AGP
for i = 2133:numel(SampleID_antibiotics)
    SampleID_antibiotics(i, :) = [];
end
