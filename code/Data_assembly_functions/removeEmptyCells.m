%% removeEmptyCells
% Takes in a column of data, removes all cells that contain no data, and
% returns an updated version of the column, as well as the indices of the
% cells removed (in case the user wants to manipulate other columns based
% on these indices).
function [updatedColumn, indices] = removeEmptyCells(column)
indices = strcmp(column,'') == 1;
updatedColumn = column;
updatedColumn(indices) = [];
end