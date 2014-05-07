%% getColumnData
% This function retrieves the data of the column from the file, specified by fileName,
% with the header columnName
function [data] = getColumnData(fileName, columnName)
    D = read_mixed_csv(fileName, ',');
    for i = 0:size(D,2)-1
        if strcmpi(D(i*size(D,1)+1), columnName) == 1
            data = D(:,i+1);
            data(1) = [];
            return
        end
    end
    fprintf('Unable to find column %s in file %s', columnName, fileName);
    data = cell(1);
end