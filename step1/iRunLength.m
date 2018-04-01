function [qBlock] = iRunLength(runSymbols)
    qBlock=zeros(8,8);
    s= size(runSymbols);
    qBlock(1,1)=runSymbols(1,2);
    % rotate the matrix to get the secondary diagonals
    rotQ = rot90(qBlock);

    % start by access diagonal from top to bottpm
    direction = 1;
    index=2;
    counter=0;
    for diagonal = -6:7
        % get the diagonal of the matrix
        ii = diag(true(8-abs(diagonal),1),diagonal);
        % d has the new diagonal
        d = zeros(8-abs(diagonal),1);
        if direction ==0
            % scan the diagonal from bottom
            for i=numel(d):-1:1
                if (index>s(1))
                    break;
                end
                % if the counter of zeros has finished add the element
                if (counter == runSymbols(index,1))
                    d(i)=runSymbols(index,2);
                    counter=0;
                    index=index+1;
                else
                    counter = counter+1;
                end
            end
            direction = 1;
        else
            % scan the diagonal from the top
            for i=1:numel(d)
                if (index>s(1))
                    break;
                end
                % if the counter of zeros has finished add the element
                if (counter == runSymbols(index,1))
                    d(i)=runSymbols(index,2);
                    counter=0;
                    index=index+1;
                else
                    counter = counter+1;
                end
            end
            direction = 0;
        end
        % update the matrix
        rotQ(ii)=d;
    end
    % rotate the matrix to get the final
    qBlock=rot90(rotQ,-1);
end

