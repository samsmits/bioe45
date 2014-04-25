%% This script calculated the daily diet for the ELDERMET data
% Input: ELDERMET_DIETS_EDITED.xls
% Output: csv file with the nutrients of the 4 diets

% read data from file
    filename = 'ELDERMET_DIETS_EDITED.xlsx';
    headerlines = 1;
    
    Data = importdata(filename,headerlines);
    
%% Get numeric data from file
% First sheet (DIETS) is where all the info is from
    numericData = Data.data.DIETS;
    
    % Separate out the amounts of each food that participants ate
    DG1_amt = numericData(:,4);
    DG2_amt = numericData(:,5);
    DG3_amt = numericData(:,6);
    DG4_amt = numericData(:,7);
    
    % Separate out the Nutritional info for each food
    NutritionalInfo = numericData(:,8:end);
    
    [r, c] = size(NutritionalInfo);
    
%% Calculate nutriets receieved by each diet group

    
    for i = 1:r;
        DG1_foods(i,:)= DG1_amt(i) .* NutritionalInfo(i,:);
        DG2_foods(i,:)= DG2_amt(i) .* NutritionalInfo(i,:);
        DG3_foods(i,:)= DG3_amt(i) .* NutritionalInfo(i,:);
        DG4_foods(i,:)= DG4_amt(i) .* NutritionalInfo(i,:);
    end
    
    DG1 = [];
    
    for j = 1:c;
        DG1(j) = sum(DG1_foods(:,j));
        DG2(j) = sum(DG2_foods(:,j));
        DG3(j) = sum(DG3_foods(:,j));
        DG4(j) = sum(DG4_foods(:,j));
    end
    
    
    Diet = [1, DG1;2, DG2; 3, DG3; 4, DG4];
    

%% Get header info
    
    GetHeader = Data.textdata.DIETS(1,7:end);
    Header = ['Diet Group' GetHeader(1:end)];

%
%% Convert all to cell
    DietDataHead = cell(Header);
    DietCell = num2cell(Diet);
    DietData = [Header;DietCell];
    DD = transpose(DietData);
    
    
    
%% Write CSV file

    file2wrt = 'diet.csv'
    fid = fopen(file2wrt,'w');
    for i = 1:size(DietData,1)
        for j = 1:size(DietData,2)
            fprintf(fid,'%s',DietData{i,j});
            if j~=size(DietData,2)
                fprintf(fid,'%s',',');
            else
                fprintf(fid,'\n');
            end
        end
    end
    fclose(fid);


  