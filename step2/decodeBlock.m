function [decBlock] = decodeBlock(encBlock, mBType, qScale)
    % read the vlCodes of the block
    vlcStream = encBlock.VLCodes;
    % Compute the runSymbols unsing ivlc
    runSymbols = ivlc(vlcStream);
    % compute the quantized Block
    qBlock = iRunLength(runSymbols);
    % dequantize using different table depending on the picType
    if mBType=='I'
        qTable=[8 16 19 22 26 27 29 34;
               16 16 22 24 27 29 34 37;
               19 22 26 27 29 34 34 38;
               22 22 26 27 29 34 37 40;
               22 26 27 29 32 35 40 48;
               26 27 29 32 35 40 48 58;
               26 27 29 34 38 46 56 69;
               27 29 35 38 46 56 69 83];
        dctBlock = dequantizeI(qBlock, qTable, qScale);
    else
        qTable=ones(8,8)*16;
        dctBlock = dequantizePB(qBlock, qTable, qScale);
    end
    % return the decoded block after using invert dct
    decBlock = iBlockDCT(dctBlock);
end

