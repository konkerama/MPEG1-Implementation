function SeqEntity=encodeMPEG(bName, fExtension, startFrame, numOfGoPs, qScale)
    GoP = 'IPP';
    % genheader
    % horizontal_size = 720, vertical_size = 576
    SeqHeader = struct('sequence_header_code','00000000000000000000000110110011',...
               'horizontal_size','001011010000','vertical_size','001001000000');
    % writeheader
    SeqEntity = struct('SeqHeader',SeqHeader,'GoPEntityArray',[],'SeqEnd',[]);
    % get the GoPEntityArray
    SeqEntity.GoPEntityArray = encodeSeq(bName, fExtension,startFrame,...
                                         GoP, numOfGoPs, qScale);
    % writeSeqEnd
    SeqEntity.SeqEnd = '00000000000000000000000110110111';
end

