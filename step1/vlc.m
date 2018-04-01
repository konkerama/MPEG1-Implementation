function [ vlcStream ] = vlc( runSymbols )
    getTheGlobals;
    global d15a;
    global d15b;
    global d16a;
    global d16b;
    global d17a;
    global d17b;
    vlcode='';

    s= size(runSymbols);
    for i =1:s(1)
        % check the d15a matrix
        k=abs(runSymbols(i,:));
        sk=size(d15a);
        d15Index=[];
        for j=1:sk(1)
            if d15a(j,1)==k(1) && d15a(j,2)==k(2)
                d15Index=j;
            end
        end
        if isempty(d15Index)
            % Write Escape and go to the other tables
            code=d15b(end-1);
            [~,indexVector]=ismember(d16a,abs(runSymbols(i,1)),'rows');
            d16Index=logical(indexVector);
            code=strcat(code,d16b(d16Index));

            [~,indexVector]=ismember(d17a,runSymbols(i,2),'rows');
            d17Index=logical(indexVector);
            code=strcat(code,d17b(d17Index));
        else
            code=d15b(d15Index);
            if runSymbols(i,2)>0
                code=strcat(code,'0');
            else
                code=strcat(code,'1');
            end
        end
        vlcode = strcat(vlcode,code);
        
    end
    vlcode = strcat(vlcode,d15b(end));
    vlcStream = char(vlcode);
end

