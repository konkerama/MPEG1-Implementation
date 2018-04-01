function [GoPEntityArray] = encodeSeq(bName, fExtension, startFrame, GoP, numOfGoPs, qScale)
    GoPEntityArray = cell(1);
    i=1;
    frameNumber = startFrame;
    while true
        % genGoPHeader
        GoPHeader = struct('group_start_code','00000000000000000000000110111000');
        % writeGopHeader
        GoPEntity = struct('GoPHeader',GoPHeader);
        % get the PicSliceEntityArray
        [t, GoPEntity.PicSliceEntityArray] = encodeGoP(frameNumber, bName,...
                                        fExtension,startFrame, GoP, qScale);
        if (not(isempty(GoPEntity.PicSliceEntityArray{1})))
            % update gopEntityArray
            GoPEntityArray{i}=GoPEntity;
        end
        % if out of pictures or out of frames
        if t==0 || frameNumber>(numOfGoPs*length(GoP))
            break;
        end
        % increment GoPEntityArray index and start frame of GoP
        i=i+1;
        frameNumber = frameNumber+length(GoP);
    end
    
end

