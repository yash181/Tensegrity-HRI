function nothingCheck(excelFile, firstInd)
    data = readmatrix(excelFile);
    onesMat = ones(1, 22);
    data = [data; onesMat];
    testInd = 1;
    startInd = 0;
    currInd = 1;
    endInd = 0;
    nameInd = firstInd;
    for row = data.'
        if row(2) == 0 && testInd ~= 0
             startInd = currInd;
             testInd = 0;
             disp(testInd)
        elseif row(2) ~= 0 && testInd == 0 % Look for end of nothing
            endInd = currInd;
            testInd = 1;
            disp(startInd)
            disp(endInd)
            testMat = data(startInd:endInd, :);
            plot(testMat(:, 11:end));
            [x, y, button] = ginput(1);
            if button <= 1
                nameVec = ['nothing', num2str(nameInd), '.csv'];
                fileName = join(nameVec);
                writematrix(testMat, fileName)
                nameInd = nameInd + 1;
            end
        end
        currInd = currInd + 1;
    end
end