function decodeMPEG( fName, outFName)
    % read SeqEntity from the file
    load(fName);
    % readSeqHeader
    % decode SeqEnity
    decodeSeq(SeqEntity.GoPEntityArray, outFName);
end

