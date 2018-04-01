function [frameY, frameCr, frameCb] = ccir2ycrcb(frameRGB)
    % Compute the ycrcb image --> 4:4:4
    imgycrcb(:,:,1) = 0.257*frameRGB(:,:,1)+...
                      0.504*frameRGB(:,:,2)+...
                      0.098*frameRGB(:,:,3)+16;
    imgycrcb(:,:,2) = 128+0.439*frameRGB(:,:,1)-...
                      0.368*frameRGB(:,:,2)-...
                      0.071*frameRGB(:,:,3);
    imgycrcb(:,:,3) = 128-0.148*frameRGB(:,:,1)-...
                      0.291*frameRGB(:,:,2)+...
                      0.439*frameRGB(:,:,3);
    
                  
    crcbFilt = [(1/8) (3/8) (3/8) (1/8)];
    yFilter=[-(29/256);0;(88/256);(138/256);(88/256);0;-(29/256)];
%% Convert 4:4:4 to 4:2:2
    crfilt = imfilter(imgycrcb(:,:,2),crcbFilt);
    crTemp = downsample(crfilt',2)';
    cr422 = imfilter(crTemp,crcbFilt);
    
    cbfilt = imfilter(imgycrcb(:,:,3),crcbFilt);
    cbTemp = downsample(cbfilt',2)';
    cb422 = imfilter(cbTemp,crcbFilt);
%% Y
    % Select odd field only
    yOddField = downsample(imgycrcb(:,:,1),2);
    
    %horizontal filter and subsample
    yfilt = imfilter(yOddField,yFilter,'replicate');
    yTemp = downsample(yfilt',2)';
    frameY = yTemp(:,5:end-4);
%% Cr
    %select one field
    crTemp = downsample(cr422,2);

    %horizontal filter and subsample
    crfilt = imfilter(crTemp,crcbFilt,'replicate');
    crTemp = downsample(crfilt',2)';

    %vertical filter and subsample
    crfilt = imfilter(crTemp,crcbFilt','replicate');
    crTemp = downsample(crfilt,2);

    frameCr = crTemp(:,3:end-2);
%% Cb
    %select one field
    cbTemp = downsample(cb422,2);

    %horizontal filter and subsample
    cbfilt = imfilter(cbTemp,crcbFilt,'replicate');
    cbTemp = downsample(cbfilt',2)';

    %vertical filter and subsample
    cbfilt = imfilter(cbTemp,crcbFilt','replicate');
    cbTemp = downsample(cbfilt,2);

    frameCb = cbTemp(:,3:end-2);
end