function [ logicalArr ] = getLogicalwithCell(cellCol, numval, comparison )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if (comparison == 'GE');
   indexCol = cellfun(@(x) (str2num(x) >= numval), cellCol,...
               'Uniformoutput',false);
elseif (equality == 'GT');
   indexCol = cellfun(@(x) (str2num(x) > numval), cellCol,...
               'Uniformoutput',false);
elseif (equality == 'LE');
   indexCol = cellfun(@(x) (str2num(x) <= numval), cellCol,...
               'Uniformoutput',false);
elseif (equailty == 'LT');
   indexCol = cellfun(@(x) (str2num(x) < numval), cellCol,...
               'Uniformoutput',false);
elseif (equailty == 'EQ');
   indexCol = cellfun(@(x) (str2num(x) == numval), cellCol,...
               'Uniformoutput',false);
end

emptyIndex = cellfun(@isempty,cellCol);       %# Find indices of empty cells
indexCol(emptyIndex) = {false};                    %# Fill empty cells with 0
logicalArr = cell2mat(indexCol);  %# Convert the cell array

end
