%% Get glycoside hydrolase family 
% This function allows the user to enter the names of multiple glycoside 
% hydrolyases into the GUI and then outputs the GH families for each GH. 
%
% Example: get_family2(&beta;-galactosidase 1.2-mannosidase chitosanase)
% Notes: when you want to input a 'beta' or 'alpha', the proper syntax is
% '&beta;' or '&alpha;'. 
%
% Also, due to the fact that the data was transferred from a csv file and
% would separate the enzymes by commas, I replaced the commas with periods.
% So instead of 1,4-enzyme or 1,3-enzyme, you will need to input 1.4-enzyme
% or 1.3-enzyme. 
%
% This version currently does not return an error message if you input
% numbers into the dialog box. 

function [spacer, output] = get_family2;

load('GH_family.mat');

% Opens input dialog box to enter input separated by spaces
vector = (inputdlg( ...
    'Input vector with glycoside hydrolases, separated by spaces:','Input Vector'));
check = isempty(str2num(vector{1}));

% Splits the inputs into indivdidual cells
vector_split = strsplit(vector{1}, {' '});

%%
if check == 1
    for j = 1:length(vector_split)
        
        % for loop that looks for the GH based on known activities
        for i = 1:133
            index{i} = find(strfind(Activities{i}, vector_split{j}));
        end
    
    % finds the indices of the GH_family cell that contains the GHs
    nonemptyCells = find(~cellfun(@isempty,index));
    output = GH_family(nonemptyCells);
    
    % Prints out the GH families that contain the GH
    fprintf('\n %s %s \n', vector_split{j}, ':');
    fprintf('%s ', output{:});
    
    end
    
    fprintf('\n');
    
else
    % Prints out message if the input was not a GH found in the database.
    fprintf('%s \n', 'This glycoside hydrolase was not found.')

end

end

