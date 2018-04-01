function [MotionVectors, BlockEntityArray] = encodeMB(pic, picType, qScale, mBIndex)
    global buffer;
    % if P||B get the motion vector
    if picType=='P'
        [eMBY,eMBCr,eMBCb,mV]=motEstP(pic.frameY, pic.frameCr, pic.frameCb,...
                                      mBIndex, buffer(1).pic.frameY,...
                                      buffer(1).pic.frameCr, buffer(1).pic.frameCb);
    elseif picType=='B'
        [eMBY,eMBCr,eMBCb,mV]=motEstB(pic.frameY, pic.frameCr, pic.frameCb,...
                                      mBIndex,buffer(1).pic.frameY, buffer(1).pic.frameCr,...
                                      buffer(1).pic.frameCb,buffer(2).pic.frameY,...
                                      buffer(2).pic.frameCr,buffer(2).pic.frameCb);
    else
        % If I the error macroblocks are the MB of the frame
        mV=[NaN NaN;NaN NaN];
        
        iBlock = floor(mBIndex/22);
        jBlock = mod(mBIndex,22);
        % MB for Y
        iStart = iBlock*16+1;
        iEnd = (iBlock+1)*16;
        jStart = jBlock*16+1;
        jEnd = (jBlock+1)*16;

        icrcbStart = iBlock*8+1;
        icrcbEnd = (iBlock+1)*8;
        jcrcbStart = jBlock*8+1;
        jcrcbEnd = (jBlock+1)*8;
        %error MBs
        eMBY = pic.frameY(iStart:iEnd,jStart:jEnd);
        eMBCr = pic.frameCr(icrcbStart:icrcbEnd,jcrcbStart:jcrcbEnd);
        eMBCb = pic.frameCb(icrcbStart:icrcbEnd,jcrcbStart:jcrcbEnd);
    end
	MotionVectors=mV;
    
    BlockEntityArray = cell(6,1);
    BlockEntity = struct('VLCodes',[]);
    % Number of Blocks is 6(4 y,1 cr,1 cb)
    % for every block compute and save the vlcdodes
    
    % Y upper left block
    BlockEntity.VLCodes = encodeBlock(eMBY(1:8,1:8),picType,qScale);
    BlockEntityArray{1} = BlockEntity;
    % Y upper right block
    BlockEntity.VLCodes = encodeBlock(eMBY(1:8,9:16),picType,qScale);
    BlockEntityArray{2} = BlockEntity;
    % Y down left block
    BlockEntity.VLCodes = encodeBlock(eMBY(9:16,1:8),picType,qScale);
    BlockEntityArray{3} = BlockEntity;
    % Y down right block
    BlockEntity.VLCodes = encodeBlock(eMBY(9:16,9:16),picType,qScale);
    BlockEntityArray{4} = BlockEntity;
    % Cr block 
    BlockEntity.VLCodes = encodeBlock(eMBCr,picType,qScale);
    BlockEntityArray{5} = BlockEntity;
    % Cr block
    BlockEntity.VLCodes = encodeBlock(eMBCb,picType,qScale);
    BlockEntityArray{6} = BlockEntity;
end