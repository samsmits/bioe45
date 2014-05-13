function [ logicalArr ] = getLogicalwithDS(dsCol, numval, comparison )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if (comparison == 'GE');
   indexCol = cellfun(@(x) (str2num(x) >= numval), dsCol,...
               'Uniformoutput',false);
elseif (equality == 'GT');
   indexCol = cellfun(@(x) (str2num(x) > numval), dsCol,...
               'Uniformoutput',false);
elseif (equality == 'LE');
   indexCol = cellfun(@(x) (str2num(x) <= numval), dsCol,...
               'Uniformoutput',false);
elseif (equailty == 'LT');
   indexCol = cellfun(@(x) (str2num(x) < numval), dsCol,...
               'Uniformoutput',false);
elseif (equailty == 'EQ');
   indexCol = cellfun(@(x) (str2num(x) == numval), dsCol,...
               'Uniformoutput',false);
end

emptyIndex = cellfun(@isempty,dsCol);       %# Find indices of empty cells
indexCol(emptyIndex) = {false};                    %# Fill empty cells with 0
logicalArr = cell2mat(indexCol);  %# Convert the cell array

end
