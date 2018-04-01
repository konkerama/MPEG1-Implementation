function decodeSeq(GoPEntityArray, outFName)
    % for every GoP
    for i = 1:numel(GoPEntityArray)
        % readGoPHeader
        % decode the GoP entity
        decodeGoP(GoPEntityArray{i}.PicSliceEntityArray, outFName);
    end
end

