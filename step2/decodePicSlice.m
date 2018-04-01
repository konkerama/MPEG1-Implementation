function [decPic] = decodePicSlice(MBEntityArray)
    frameY = zeros(288,352);
    frameCr = zeros(144,176);
    frameCb = zeros(144,176);
    for mBIndex = 1:numel(MBEntityArray)
        %readMBHeader
        MBHeader = MBEntityArray{mBIndex}.MBHeader;
        % decode MacroBlock
        [decMBY,decMBCr,decMBCb]=decodeMB(MBEntityArray{mBIndex}.BlockEntityArray,MBEntityArray{mBIndex}.MotionVectors,...
                                    MBHeader.macroblock_type,mBIndex-1, MBHeader.quantizer_scale);
        % find i,j of macroblock y
        iBlock = floor((mBIndex-1)/22);
        jBlock = mod((mBIndex-1),22);
        iStart = iBlock*16+1;
        iEnd = (iBlock+1)*16;
        jStart = jBlock*16+1;
        jEnd = (jBlock+1)*16;
        % add decoded macroblock to the decoded frameY
        frameY(iStart:iEnd,jStart:jEnd) = decMBY;
        % find i,j of macroblock cr,cb
        icrcbStart = iBlock*8+1;
        icrcbEnd = (iBlock+1)*8;
        jcrcbStart = jBlock*8+1;
        jcrcbEnd = (jBlock+1)*8;
        % add decoded macroblock to the decoded frameCr and frameCb
        frameCr(icrcbStart:icrcbEnd,jcrcbStart:jcrcbEnd) = decMBCr;
        frameCb(icrcbStart:icrcbEnd,jcrcbStart:jcrcbEnd) = decMBCb;
    end
    % add ycrcb to struct
    decPic = struct('frameY', frameY, 'frameCr', frameCr, 'frameCb', frameCb);
end

