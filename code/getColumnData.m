%% getColumnData
% This function retrieves the data of the column from the file, specified by fileName,
% with the header columnName. Extended to accept a cell array of column
% names, and have the output reflect all specified columns in the order
% they are specified in the input.
function [data] = getColumnData(fileName, columnName)
if(~iscell(columnName))
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
else
    
    D = read_mixed_csv(fileName, ',');
    data = cell(length(D)-1, length(columnName));
    for i = 1:length(columnName)
        found = false;
        for j = 0:size(D,2)-1
            if strcmpi(D(j*size(D,1)+1), columnName{i}) == 1
                found = true;
                temp = D(:,j+1);
                temp(1) = [];
                fprintf('size of data is (%d x %d)\n', size(data,1), size(data,2));
                fprintf('size of temp is (%d x %d)\n', size(temp,1), size(temp,2))
                data(:,i) = temp;
                break
            end
        end
        if ~found
            fprintf('Unable to find column %s in file %s\n', columnName{i}, fileName);
            data = cell(1);
        end
    end
end
end