function decodeGoP( PicSliceEntityArray, outFName )
    % for every frame in the GoP
    for picIndex = 1:numel(PicSliceEntityArray)
        %readPicSliceHeader
        % get tempRef and picType from ethe picSlice entity
        tempRef = PicSliceEntityArray{picIndex}.PicSliceHeader.temporal_reference;
        picType = PicSliceEntityArray{picIndex}.PicSliceHeader.picture_coding_type;
        fprintf('Decoding frame: %d, Type = %c \n',tempRef,picType)
        % decode the frame
        decPic = decodePicSlice(PicSliceEntityArray{picIndex}.MBEntityArray);
        % save decoded picture as a file
        fprintf('Saving Frame \n')
        pushFlushPic(decPic,tempRef, outFName);
        % if picType ==I||P save the pic to buffer
        if picType == 'I' || picType == 'P'
            pushPic(decPic);
        end
    end
end

