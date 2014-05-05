%% Eldermet diet matcher
%   This script matches the ELDERMET patient data with the diets generated
%   with eldermet_diet_maker.m


dietFile = 'diets.csv';
patientFile = 'ELDERMET_raw.xlsx';

outputFile = 'ELDERMET_diets.csv';

headerlines = 3;

dietData = importdata(dietFile,',');
patientData = xlsread(patientFile,'Sheet1','E2:T179');
[ntext, patientText, patientTextall] = xlsread(patientFile,'Sheet1','A2:D179');
[nhead, patientHead]  = xlsread(patientFile,'Sheet1','A1:T1');
%% Extract data

%   Each diet is listed as a row
diets = dietData.data;
dietlist = dietData.textdata;
dietHeader = dietlist(1,2:end);

%   Diets are included in patientData column #4
patientDiet = patientData(:,1);


%   Make header for outcsv
OutHeader = [patientHead dietHeader];


%% Create csv file

dietMat = nan(length(patientDiet),length(dietHeader));

for i = 1:length(patientDiet);
    if not(isnan(patientDiet(i)))
        DG = int8(patientDiet(i));
        dietMat(i,:) = diets(DG,:);
    end
end

fid = fopen(outputFile,'w');

% Print header
for j = 1:length(OutHeader);
    fprintf(fid,'%s',OutHeader{j});
    if j~=length(OutHeader);
       fprintf(fid,'%s',',');
    else
       fprintf(fid,'\n');
    end
end

% Print everything else.  For some reason, I couldn't get everything into
% one cell so I had to split it up by column.

for i = 1:178;
    for j = 1:length(OutHeader);
        if (j==1) || ((j>2) && (j<=4));
           str = patientTextall{i,j};
           fprintf(fid, '%s', str);     % Sample, gender, and stratum
        elseif j ==2;                   
           str = patientTextall{i,j};
           fprintf(fid, '%d', str);     % Age
        elseif (4<j) && (j<=20);
           fprintf(fid, '%f', patientData(i,(j-4)));    %non-diet fields
        elseif j>20;
           fprintf(fid,'%s',dietMat(i, (j-20)));        %diet fields
        end
        
        if j~=length(OutHeader);
           fprintf(fid,'%s',',');
        else
           fprintf(fid,'\n');
        end
    end
end
fclose(fid);

