function [mBY, mBCr, mBCb] = iMotEstB(eMBY, eMBCr, eMBCb, mBIndex, mV, ...
                                      backwFrameY, backwFrameCr, backwFrameCb, ...
                                      forwFrameY, forwFrameCr, forwFrameCb)
    iBlock = floor(mBIndex/22);
    jBlock = mod(mBIndex,22);

    % Block array starts at 0
    % get i,j for the mBindex of y block
    refiStart = iBlock*16+1;
    refiEnd = (iBlock+1)*16;
    refjStart = jBlock*16+1;
    refjEnd = (jBlock+1)*16;
    % get i,j for the mBindex of cr cb blocks
    reficrcbStart = iBlock*8+1;
    reficrcbEnd = (iBlock+1)*8;
    refjcrcbStart = jBlock*8+1;
    refjcrcbEnd = (jBlock+1)*8;

    mot=mV(:,all(~isnan(mV)));
    % get the coordinates from the motion vector
    refiStart = refiStart + mot(1);
    refiEnd = refiEnd + mot(1);
    refjStart = refjStart + mot(2);
    refjEnd = refjEnd + mot(2);

    reficrcbStart = reficrcbStart + round(mot(1)/2);
    reficrcbEnd = reficrcbEnd + round(mot(1)/2);
    refjcrcbStart = refjcrcbStart + round(mot(2)/2);
    refjcrcbEnd = refjcrcbEnd + round(mot(2)/2);

    if isnan(mV(1,2))
        % Backward
        % get the reference macro blocks 
        refyBlock = backwFrameY(refiStart:refiEnd,refjStart:refjEnd);
        refcrBlock = backwFrameCr(reficrcbStart:reficrcbEnd,refjcrcbStart:refjcrcbEnd);
        refcbBlock = backwFrameCb(reficrcbStart:reficrcbEnd,refjcrcbStart:refjcrcbEnd);
    else
        % Forward
        % get the reference macro blocks 
        refyBlock = forwFrameY(refiStart:refiEnd,refjStart:refjEnd);
        refcrBlock = forwFrameCr(reficrcbStart:reficrcbEnd,refjcrcbStart:refjcrcbEnd);
        refcbBlock = forwFrameCb(reficrcbStart:reficrcbEnd,refjcrcbStart:refjcrcbEnd);
    end
    %compute the decoded macro blocks
    mBY = eMBY + single(refyBlock);
    mBCr = eMBCr + single(refcrBlock);
    mBCb = eMBCb + single(refcbBlock);

end

