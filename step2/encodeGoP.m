function [t, PicSliceEntityArray] = encodeGoP(frameNumber, bName, fExtension,startFrame, GoP, qScale)
    PicSliceEntityArray = cell(1);
    GoPSize=size(GoP);
    i=1;
    % for every image in GoP
    for iPic = frameNumber:frameNumber+GoPSize(2)-1
        % get the next picture depending on the rules of encoding
        [pic, picType, tempRef] = getNextPicture(bName, fExtension, iPic,startFrame, GoP);
        if isempty(pic)
            disp('Out of pictures');
            t=0;
            break;
        else
            t=1;
        end
        fprintf('Encoding frame: %d, Type = %c \n',tempRef,picType)
        % genPicSliceHeader
        PicSliceHeader = struct('picture_start_code','00000000000000000000000100000000',...
                    'temporal_reference',tempRef,'picture_coding_type',picType,...
                    'slice_start_code',startFrame,'quantizer_scale',qScale);
        % writePicSliceHeader
        PicSliceEntity = struct('PicSliceHeader',PicSliceHeader);
        % get MBEntityArray
        PicSliceEntity.MBEntityArray = encodePicSlice(pic, picType, qScale);
        % update picslice entity array
        PicSliceEntityArray{i} = PicSliceEntity;
        % if pictype is I||p decode and save to buffer for reference
        if picType == 'I' || picType =='P'
            fprintf('Decoding %c frame \n',picType)
            decPic = decodePicSlice(PicSliceEntity.MBEntityArray);
            pushPic(decPic)
            fprintf('Decoding Finished \n')
        end
        i=i+1;
    end
end