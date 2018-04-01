image = imread('coastguard003.tiff');
[frameY, frameCr, frameCb] = ccir2ycrcb(image);
mBYprev=uint8(frameY(1:16,1:16));

refImage = imread('coastguard001.tiff');
[refFrameY, refFrameCr, refFrameCb] = ccir2ycrcb(refImage);
mBIndex=0;
[eMBY, eMBCr, eMBCb, mV] = motEstP(frameY, frameCr, frameCb, mBIndex, refFrameY, refFrameCr, refFrameCb);
[mBY, mBCr, mBCb] = iMotEstP(eMBY, eMBCr, eMBCb, mBIndex, mV, refFrameY, refFrameCr, refFrameCb);

figure('Name','coastguard003')
imshow(mBYprev);

figure('Name','coastguard001')
imshow(refFrameY(1+mV(1,1):16+mV(1,1),1+mV(2,1):16+mV(2,1)));

figure('Name','New image')
imshow(uint8(mBY));

mBYprev=single(frameY(1:16,1:16));
figure('Name','Prediction Error')
predError=mBYprev-mBY;
imshow(predError)
imwrite(predError, 'predError.png');
