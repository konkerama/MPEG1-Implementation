function [runSymbols] = ivlc(vlcStream)
    getTheGlobals
    global d15a;
    global d15b;
    global d16a;
    global d16b;
    global d17a;
    global d17b;
    runSymbols=[];
    vlcIndex=1;
    while true
        % Check if element is in d15
        code = char(d15b(end-1));
        codeLength = numel(code);
        ind=codeLength+vlcIndex-1;
        if codeLength+vlcIndex-1>numel(vlcStream)
            ind=numel(vlcStream);
        end
        if strcmp(vlcStream(vlcIndex:ind),code)
            % code doesn't exist in d15 --> search d16 and d17
            vlcIndex = vlcIndex+codeLength;
            for i=1:numel(d16b)
                % for all elements of d16b check if is same with the
                % current code
                code = char(d16b(i));
                codeLength = numel(code);
                if codeLength+vlcIndex-1<=numel(vlcStream)
                    if strcmp(vlcStream(vlcIndex:vlcIndex+codeLength-1),code)
                        run = d16a(i);
                        vlcIndex = vlcIndex+codeLength;
                        break;
                    end
                end
            end
            for i=1:numel(d17b)
                % for all elements of d17b check if is same with the
                % current code
                code = char(d17b(i));
                codeLength = numel(code);
                if codeLength+vlcIndex-1<=numel(vlcStream)
                    if strcmp(vlcStream(vlcIndex:vlcIndex+codeLength-1),code)
                        value = d17a(i);
                        vlcIndex = vlcIndex+codeLength;
                        break;
                    end
                end
            end
        else
            % check d15 table
            for i=1:numel(d15b)
                % for all elements of d17b check if is same with the
                % current code
                code = char(d15b(i));
                codeLength = numel(code);
                if codeLength+vlcIndex-1<=numel(vlcStream)
                    if strcmp(vlcStream(vlcIndex:vlcIndex+codeLength-1),code)
                        run = d15a(i,1);
                        value = d15a(i,2);
                        vlcIndex = vlcIndex+codeLength;
                        break;
                    end
                end
            end
            if strcmp(vlcStream(vlcIndex),'1')
                % if last byte of code is 1 then value is negative 
                value = -value;
            end
            vlcIndex = vlcIndex+1;
        end
        % save the symbols
        runSymbols=[runSymbols;run value];
        if (strcmp(vlcStream(vlcIndex:vlcIndex+1),'10'))&&(vlcIndex>=numel(vlcStream)-1)
            % check if we are at EOB
            break;
        end
    end
end