function [mBY, mBCr, mBCb] = iMotEstP(eMBY, eMBCr, eMBCb, mBIndex, mV, refFrameY, refFrameCr, refFrameCb)
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
    % get the coordinates from the motion vector
    refiStart = refiStart + mV(1,1);
    refiEnd = refiEnd + mV(1,1);
    refjStart = refjStart + mV(2,1);
    refjEnd = refjEnd + mV(2,1);

    reficrcbStart = reficrcbStart + round(mV(1,1)/2);
    reficrcbEnd = reficrcbEnd + round(mV(1,1)/2);
    refjcrcbStart = refjcrcbStart + round(mV(2,1)/2);
    refjcrcbEnd = refjcrcbEnd + round(mV(2,1)/2);
    % get the reference macro blocks 
    refyBlock = refFrameY(refiStart:refiEnd,refjStart:refjEnd);
    refcrBlock = refFrameCr(reficrcbStart:reficrcbEnd,refjcrcbStart:refjcrcbEnd);
    refcbBlock = refFrameCb(reficrcbStart:reficrcbEnd,refjcrcbStart:refjcrcbEnd);
    %compute the decoded macro blocks
    mBY = eMBY+single(refyBlock);
    mBCr = eMBCr + single(refcrBlock);
    mBCb = eMBCb+single(refcbBlock);


end

