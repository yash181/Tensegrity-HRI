%% Cypher script for associating FSR signals with node locations
% ---------------------------------------------------------

% TEST2.CSV
% Use the identification sequence key diagram to associate numeric values
% with the correct node locations

% Cypher containing key values

function cypher = cypher_TEST2()
cypher = [4, 3, 12, 11, 5, 6, 7, 8, 1, 2, 10, 9];

% golden ratio
g_ratio = (1+sqrt(5))/2;
% coordinates of identification sequence key diagram (bar-by-bar)
sequence_coordinates = [1, 0, -g_ratio;
    -1, 0, -g_ratio;
    1, 0, g_ratio;
    -1, 0, g_ratio;
    0, -g_ratio, 1;
    0, -g_ratio, -1;
    0, g_ratio, 1;
    0, g_ratio, -1;
    g_ratio, -1, 0;
    g_ratio, 1, 0;
    -g_ratio, -1, 0;
    -g_ratio, 1, 0];

end