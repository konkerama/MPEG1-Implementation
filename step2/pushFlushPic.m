function pushFlushPic(pic, tempRef, outFName)
    % convert pic to rgb
    finalPic = ycrcb2ccir(pic.frameY,pic.frameCr, pic.frameCb);
    % find pic filename
    imgfile = sprintf('%s%03d%s',outFName,tempRef,'.tiff');
    % save pic
    imwrite(finalPic,imgfile);
end

