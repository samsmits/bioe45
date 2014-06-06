%% Get glycoside hydrolase information 
% This function allows the user to enter the the number of the glycoside 
% hydrolase (GH) family s/he is interested in and then outputs the known
% activities of that GH family. 

% Instructions: 

% Run get_activities2 in the command window

% GUI will ask you to input a vector with integers between 1 and 133. 

% If input is a string or if input does not contain integers between 1-133,
% it will output an error message.

% The script will output the GH family with its respective known
% activities. 


function [spacer, known_activities] = get_activities2


load('GH_family.mat');


vector = str2num(cell2mat(inputdlg( ...
    'Input vector with integers between 1 and 133, separated by spaces or commas:','Input Vector')));
check = isempty(vector);
vector_length = length(vector);

% checks if the input is a vector with integers between 1 and 133. 
if check == 0 & vector >= 1 & vector <= 133

    for i = 1:vector_length
    
        % finds the known activities of that GH family
        known_activities{i} = Activities{vector(i)};
        
        % prints out the GH information to the command window
        fprintf('%s%d%s %s \n', 'Known activities for GH', vector(i), ':', known_activities{i});
    end
    
    else
        
        % prints out a message if the input was not a number between 1 and 133.
        fprintf('%s \n','You did not enter a vector with integers from  1 to 133.');

end

end

% Other notes: 
% need to output the results into a variable or structural array
