function [VLCodes] = encodeBlock(blockMatrix,mBType,qScale)
    % dct transformation
    dctBlock = blockDCT(blockMatrix);
    % call quantize function with the appropriate table depentind on the 
    % pictype
    if mBType == 'I'
            qTable=[8 16 19 22 26 27 29 34;
                   16 16 22 24 27 29 34 37;
                   19 22 26 27 29 34 34 38;
                   22 22 26 27 29 34 37 40;
                   22 26 27 29 32 35 40 48;
                   26 27 29 32 35 40 48 58;
                   26 27 29 34 38 46 56 69;
                   27 29 35 38 46 56 69 83];
        qBlock = quantizeI(dctBlock, qTable, qScale);
    else
        qTable=ones(8,8)*16;
        qBlock = quantizePB(dctBlock, qTable, qScale);
    end
    % Do the zigzag scanning and conpute the runSymbols
    runSymbols = runLength(qBlock);
    % Compute the vlCodes
    VLCodes = vlc(runSymbols);
end

