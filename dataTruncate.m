% Data truncation function
% Input the excel file name and the intended output file names as strings
% The script cycles through each test in the given file based on the test
% index (column 2), then plots the FSR data of each valid test. User has
% the option to select the beginning and end of data to keep for each test
% Excel files with truncated data should appear in the folder where you're
% working

function dataTruncate(excelFile, testName)
    data = readmatrix(excelFile);
    zeroMat = zeros(1, 22);
    data = [data; zeroMat];
    testInd = 0;
    startInd = 0;
    currInd = 1;
    endInd = 0;
    nameInd = 1;
    for row = data.'
        if row(2) ~= testInd && testInd == 0 % Look for start of test
             startInd = currInd;
             testInd = row(2);
             disp(testInd)
        elseif row(2) ~= testInd % Look for end of test
            endInd = currInd;
            testInd = 0;
            disp(startInd)
            disp(endInd)
            testMat = data(startInd:endInd, :);
            plot(testMat(:, 11:end));
            button = 1;
            xList = [];
            while sum(button) <=1   % read ginputs until a mouse right-button occurs
                [x,y,button] = ginput(1);
                if button <= 1
                    xList = [xList, x];
                end
            end
            disp(xList)
            nameVec = [testName, num2str(nameInd), '.csv'];
            fileName = join(nameVec);
            exportMat = testMat(floor(xList(1)) + 1:floor(xList(2)), :);
            writematrix(exportMat, fileName)
            nameInd = nameInd + 1;
        end
        currInd = currInd + 1;
    end
end