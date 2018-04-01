function [MBEntityArray] = encodePicSlice(pic, picType, qScale)
    ySize = size(pic.frameY);
    numOfMB = (ySize(1)/16)*(ySize(2)/16);
    MBEntityArray = cell(numOfMB,1);
    % for every macroblock
    for mBIndex = 1:numOfMB
        % genMBHeader
        MBHeader = struct('macroblock_type',picType,'quantizer_scale',qScale);
        % writeMBHeader
        MBEntity = struct('MBHeader',MBHeader,'MotionVectors',[],'BlockEntityArray',[]);
        % get motionVectors and BlockEnittyArray
        [MBEntity.MotionVectors, MBEntity.BlockEntityArray] = encodeMB(pic, picType, qScale, mBIndex-1);
        % update MBEntityArray
        MBEntityArray{mBIndex} = MBEntity;
    end

end

