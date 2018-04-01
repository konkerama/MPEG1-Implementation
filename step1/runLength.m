function [runSymbols] = runLength(qBlock)
    % intialize
    numOfZeros=0;
    runSymbols=[0 qBlock(1,1)];

    % rotate the matrix to get the secondary diagonals
    rotQ = rot90(qBlock);
    % start by access diagonal from top to bottpm
    direction = 1;
    for diagonal = -6:7
        % Get the diagonal 
        d = diag(rotQ,diagonal);
        if direction ==0
            % scan the diagonal from bottom
            for i=numel(d):-1:1
                if d(i)==0
                    numOfZeros = numOfZeros +1;
                else
                    runSymbols=[runSymbols;numOfZeros d(i)];
                    numOfZeros=0;
                end
            end
            direction = 1;
        else
            % scan the diagonal from the top
            for i=1:numel(d)
                if d(i)==0
                    numOfZeros = numOfZeros +1;
                else
                    runSymbols=[runSymbols;numOfZeros d(i)];
                    numOfZeros=0;
                end
            end
            direction = 0;
        end
    end
end

