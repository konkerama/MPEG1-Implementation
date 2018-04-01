function [eMBY, eMBCr, eMBCb, mV] = motEstP(frameY, frameCr, frameCb, mBIndex, refFrameY, refFrameCr, refFrameCb)
    iBlock = floor(mBIndex/22);
    jBlock = mod(mBIndex,22);
    % Block array starts at 0
    % get i,j for the mBindex of y block
    iStart = iBlock*16+1;
    iEnd = (iBlock+1)*16;
    jStart = jBlock*16+1;
    jEnd = (jBlock+1)*16;
    % get the y block
    yBlock = frameY(iStart:iEnd,jStart:jEnd);
    % get i,j for the mBindex of cr cb blocks
    icrcbStart = iBlock*8+1;
    icrcbEnd = (iBlock+1)*8;
    jcrcbStart = jBlock*8+1;
    jcrcbEnd = (jBlock+1)*8;
	% get cr cb blocks
    crBlock = frameCr(icrcbStart:icrcbEnd,jcrcbStart:jcrcbEnd);
    cbBlock = frameCb(icrcbStart:icrcbEnd,jcrcbStart:jcrcbEnd);

    minError=999999999999;
    eMBY = zeros(16,16);
    eMBCr = zeros(16,16);
    eMBCb = zeros(16,16);
    imotion=0;
    jmotion=0;
    kStart=-7;
    kEnd=7;
    lStart=-7;
    lEnd=7;
    % if in edge case then start/finish to zero
    if iBlock==0
        kStart=0;
    elseif iBlock==17
        kEnd=0;
    end
    if jBlock==0
        lStart=0;
    elseif jBlock==21
        lEnd=0;
    end 

    for k=kStart:1:kEnd
        for l=lStart:1:lEnd
            % get y cr and cb i,j
            refiStart = iStart+k;
            refiEnd = iEnd+k;
            refjStart = jStart+l;
            refjEnd = jEnd+l;

            reficrcbStart = icrcbStart+round(k/2);
            reficrcbEnd = icrcbEnd+round(k/2);
            refjcrcbStart = jcrcbStart+round(l/2);
            refjcrcbEnd = jcrcbEnd+round(l/2);
            % compute the ref block
            refyBlock = refFrameY(refiStart:refiEnd,refjStart:refjEnd);
            refcrBlock = refFrameCr(reficrcbStart:reficrcbEnd,refjcrcbStart:refjcrcbEnd);
            refcbBlock = refFrameCb(reficrcbStart:reficrcbEnd,refjcrcbStart:refjcrcbEnd);
            % compute the error per macro block
            errorY = single(yBlock)-single(refyBlock);
            errorCr = single(crBlock)-single(refcrBlock);
            errorCb = single(cbBlock)-single(refcbBlock);
            % compute the total error
            error = sum(sum(abs(errorY)))+sum(sum(abs(errorCr)))+sum(sum(abs(errorCb)));
            % if min error then update the motion vector
            if (error<minError);
                imotion = k;
                jmotion = l;
                eMBY = errorY;
                eMBCr = errorCr;
                eMBCb = errorCb;
                minError=error;
            end
        end
    end
    %compute the motion vector
    mV=[imotion NaN;jmotion NaN];
end

