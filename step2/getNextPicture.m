function [pic, picType, tempRef] = getNextPicture(bName, fExtension, frameNumber, startFrame, GoP)
    % a vector of the encoding indexes of the GoP
    persistent index;
    % in the first call of getnext picture rearrange the indexes of the GoP
    % so that the P or I after the B is encoded first
    % for example: IBBPBBP --> IPBBPBB
    if isempty(index)
        index = zeros(length(GoP),1);
        prevB=0;
        Bpos=0;
        for i=1:length(GoP)
            if GoP(i) =='B' && prevB==0
                index(i+1)=i;
                prevB=1;
                Bpos=i;
            elseif GoP(i) =='B' && prevB==1
                index(i+1)=i;
            elseif (GoP(i) =='I' || GoP(i) =='P') && prevB==0
                index(i)=i;
            elseif (GoP(i) =='I' || GoP(i) =='P') && prevB==1
                index(Bpos)=i;
                prevB=0;
            end
        end
    end
    % find the picture type depending on the index of the GoP
    indexGoP=mod(frameNumber+1,length(GoP));
    if indexGoP==0
        num =index(length(GoP));
    else
        num =index(indexGoP);
    end
    picType = GoP(num);
    % find the startFrame of the GoP and compute the tempRef of the frame
    gopStartFrame = floor((startFrame+frameNumber)/length(GoP))*length(GoP);
    tempRef =gopStartFrame+num-1;
    % construct the filename and if exists return the frame else return an
    % empty image marking the end of pictures
    imgName = sprintf('%s%03d%s',bName,tempRef,fExtension);
	if exist(imgName,'file')==0
            pic=[];
        else
            frameRGB = imread(imgName);
            [frameY, frameCr, frameCb] = ccir2ycrcb(frameRGB);
            pic = struct('frameY', frameY, 'frameCr', frameCr, 'frameCb', frameCb);
	end
end