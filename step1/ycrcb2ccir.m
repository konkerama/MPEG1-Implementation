function [frameRGB] = ycrcb2ccir( frameY,frameCr,frameCb)
%% Y
    % 352 to 360
    ypadded = padarray(frameY,[0,4],'replicate');
    % Horizontal upsampling and filtering
    yTemp=upsample(ypadded.',2);
    % add a mirroring pad just for the filter
    ypadded2 = padarray(yTemp.',[0,3]);
    % filter y horizontaly
    yHorFiltered = zeros(288,720);
    for i=1:720
        j=i+3;
        yHorFiltered(:,i) = (256/256)*ypadded2(:,j)+(140/256)*ypadded2(:,j-1)+...
                         (140/256)*ypadded2(:,j+1)-(12/256)*ypadded2(:,j-3)-...
                         (12/256)*ypadded2(:,j+3);
    end
    % Vertical Upsampling and Filtering
    yVer = upsample(yHorFiltered,2);
    ypadded4 = [yVer(4,:);yVer(3,:);yVer(2,:);yVer;yVer(end-1,:);yVer(end-2,:);yVer(end-3,:)];
    yFinal = zeros(576,720);
    for i=1:576
        j=i+3;
        yFinal(i,:) = (256/256)*ypadded4(j,:)+(140/256)*ypadded4(j-1,:)+...
                  (140/256)*ypadded4(j+1,:)-(12/256)*ypadded4(j-3,:)-...
                  (12/256)*ypadded4(j+3,:);
    end
%% Cr
    % 176 to 180
    crpadded = padarray(frameCr,[0,2],'replicate');
    % Vertical upsampling and Filtering
    crVer = upsample(crpadded,2);
    crpadded2 = [crVer(4,:);crVer(3,:);crVer(2,:);crVer;crVer(end-1,:);crVer(end-2,:);crVer(end-3,:)];
    crVer1 = zeros(288,180);
    for i=1:288
        j=i+3;
        crVer1(i,:) = (256/256)*crpadded2(j,:)+(140/256)*crpadded2(j-1,:)+...
                      (140/256)*crpadded2(j+1,:)-(12/256)*crpadded2(j-3,:)-...
                      (12/256)*crpadded2(j+3,:);

    end
    %Horizontal upsampling and Filtering
    crTemp=upsample(crVer1.',2)';
    crpadded3 = [crTemp(:,4) crTemp(:,3) crTemp(:,2) crTemp crTemp(:,end-1) crTemp(:,end-2) crTemp(:,end-3)];
    crHor = zeros(288,360);
    for i=1:360
        j=i+3;
        crHor(:,i) = (256/256)*crpadded3(:,j)+(140/256)*crpadded3(:,j-1)+...
                         (140/256)*crpadded3(:,j+1)-(12/256)*crpadded3(:,j-3)-...
                         (12/256)*crpadded3(:,j+3);
    end
    % Vertical upsampling and Filtering
    crVer2 = upsample(crHor,2);
    crpadded4 = [crVer2(4,:);crVer2(3,:);crVer2(2,:);crVer2;crVer2(end-1,:);crVer2(end-2,:);crVer2(end-3,:)];
    crVer3 = zeros(576,360);
    for i=1:576
        j=i+3;
        crVer3(i,:) = (256/256)*crpadded4(j,:)+(140/256)*crpadded4(j-1,:)+...
                      (140/256)*crpadded4(j+1,:)-(12/256)*crpadded4(j-3,:)-...
                      (12/256)*crpadded4(j+3,:);
    end
%% Cb
    % 176 to 180
    cbpadded = padarray(frameCb,[0,2],'replicate');
    % Vertical upsampling and Filtering
    cbVer = upsample(cbpadded,2);
    cbpadded2 = [cbVer(4,:);cbVer(3,:);cbVer(2,:);cbVer;cbVer(end-1,:);cbVer(end-2,:);cbVer(end-3,:)];
    cbVer1 = zeros(288,180);
    for i=1:288
        j=i+3;
        cbVer1(i,:) = (256/256)*cbpadded2(j,:)+(140/256)*cbpadded2(j-1,:)+...
                      (140/256)*cbpadded2(j+1,:)-(12/256)*cbpadded2(j-3,:)-...
                      (12/256)*cbpadded2(j+3,:);
    end

    %Horizontal upsampling and Filtering
    cbTemp=upsample(cbVer1.',2)';
    cbpadded3 = [cbTemp(:,4) cbTemp(:,3) cbTemp(:,2) cbTemp cbTemp(:,end-1) cbTemp(:,end-2) cbTemp(:,end-3)];
    cbHor = zeros(288,360);
    for i=1:360
        j=i+3;
        cbHor(:,i) = (256/256)*cbpadded3(:,j)+(140/256)*cbpadded3(:,j-1)+...
                     (140/256)*cbpadded3(:,j+1)-(12/256)*cbpadded3(:,j-3)-...
                     (12/256)*cbpadded3(:,j+3);
    end
    % Vertical upsampling and Filtering
    cbVer2 = upsample(cbHor,2);
    cbpadded4 = [cbVer2(4,:);cbVer2(3,:);cbVer2(2,:);cbVer2;cbVer2(end-1,:);cbVer2(end-2,:);cbVer2(end-3,:)];
    cbVer3 = zeros(576,360);
    for i=1:576
        j=i+3;
        cbVer3(i,:) = (256/256)*cbpadded4(j,:)+(140/256)*cbpadded4(j-1,:)+...
                      (140/256)*cbpadded4(j+1,:)-(12/256)*cbpadded4(j-3,:)-...
                      (12/256)*cbpadded4(j+3,:);
    end
%% 4:2:2 to 4:4:4
    %cr
    crTemp2=upsample(crVer3.',2)';
    crpadded4 = [crTemp2(:,4) crTemp2(:,3) crTemp2(:,2) crTemp2 crTemp2(:,end-1) crTemp2(:,end-2) crTemp2(:,end-3)];
    crFinal = zeros(576,720);
    for i=1:720
        j=i+3;
        crFinal(:,i) = (256/256)*crpadded4(:,j)+(140/256)*crpadded4(:,j-1)+...
                         (140/256)*crpadded4(:,j+1)-(12/256)*crpadded4(:,j-3)-...
                         (12/256)*crpadded4(:,j+3);
    end
    %cb
    cbTemp2=upsample(cbVer3.',2)';
    cbpadded4 = [cbTemp2(:,4) cbTemp2(:,3) cbTemp2(:,2) cbTemp2 cbTemp2(:,end-1) cbTemp2(:,end-2) cbTemp2(:,end-3)];
    cbFinal = zeros(576,720);
    for i=1:720
        j=i+3;
        cbFinal(:,i) = (256/256)*cbpadded4(:,j)+(140/256)*cbpadded4(:,j-1)+...
                       (140/256)*cbpadded4(:,j+1)-(12/256)*cbpadded4(:,j-3)-...
                       (12/256)*cbpadded4(:,j+3);
    end
%% Convert ycrcb to rgb
    rgbimg(:,:,1) = 1.164*(yFinal - 16) + 1.596*(crFinal - 128);
    rgbimg(:,:,2) = 1.164*(yFinal - 16) - 0.813*(crFinal - 128) - 0.391*(cbFinal - 128);
    rgbimg(:,:,3) = 1.164*(yFinal - 16) + 2.018*(cbFinal - 128);
    frameRGB = uint8(rgbimg);
end

