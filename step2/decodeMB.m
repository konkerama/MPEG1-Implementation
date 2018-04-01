function [decMBY,decMBCr,decMBCb] = decodeMB(BlockEntityArray, MotionVectors,mBType, mBIndex, qScale)
    global buffer;    
    eMBY = zeros(16,16);
    % Compute the error ycrcb macroblocks
    % upper left block
    eMBY(1:8,1:8) = decodeBlock(BlockEntityArray{1}, mBType, qScale);
    % upper right block
    eMBY(1:8,9:16) = decodeBlock(BlockEntityArray{2}, mBType, qScale);
    % down left block
    eMBY(9:16,1:8) = decodeBlock(BlockEntityArray{3}, mBType, qScale);
    % down right block
    eMBY(9:16,9:16) = decodeBlock(BlockEntityArray{4}, mBType, qScale);
    % Cr block
    eMBCr = decodeBlock(BlockEntityArray{5}, mBType, qScale);
    % Cb block
	eMBCb = decodeBlock(BlockEntityArray{6}, mBType, qScale);
    % if pictype=P||B compute the decoded MBs using the
    % invertMotionEstimation
    % if picype=I the error MBs are the decoded MBs
    if mBType=='P'
        [decMBY, decMBCr, decMBCb] = iMotEstP(eMBY, eMBCr, eMBCb, mBIndex,...
                                      MotionVectors, buffer(1).pic.frameY,...
                                      buffer(1).pic.frameCr, buffer(1).pic.frameCb);
    elseif mBType == 'B'
        [decMBY, decMBCr, decMBCb] = iMotEstB(eMBY, eMBCr, eMBCb, mBIndex,...
                                      MotionVectors, buffer(1).pic.frameY,...
                                      buffer(1).pic.frameCr, buffer(1).pic.frameCb,...
                                      buffer(2).pic.frameY,buffer(2).pic.frameCr,...
                                      buffer(2).pic.frameCb);
    else
        decMBY = eMBY;
        decMBCr = eMBCr;
        decMBCb = eMBCb;
    end
end

