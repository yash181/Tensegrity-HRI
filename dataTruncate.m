% Data truncation function
% Input the excel file name as a string
% When the plot shows up, left click on all the points at which you want to
% truncate. When done selecting, right click to finish
% Excel files with truncated data should appear in the folder where you're
% working as "testSlice#"

function dataTruncate(excelFile)
    data = readmatrix(excelFile);
    plot(data(:, 2)); % Plot the second column of CSV files (the test index column)
    button = 1;
    xList = [];
    while sum(button) <=1   % read ginputs until a mouse right-button occurs
        [x,y,button] = ginput(1);
        if button <= 1
            xList = [xList, x];
        end
    end
    xPrev = 1;
    ind = 1;
    disp(xList)
    for xInd = xList
        nameVec = ['testSlice', num2str(ind)];
        fileName = join(nameVec);
        exportMat = data(xPrev:floor(xInd) + 1, :);
        xlswrite(fileName, exportMat)
        xPrev = floor(xInd) + 1;
        ind = ind + 1;
    end
    nameVec = ['testSlice', num2str(ind)];
    fileName = join(nameVec);
    exportMat = data(xPrev:end, :);
    xlswrite(fileName, exportMat)
end