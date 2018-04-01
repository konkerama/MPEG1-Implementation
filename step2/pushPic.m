function pushPic(pic)
    global buffer
    if isempty(buffer)
        buffer = struct('pic',pic);
    end
    buffer(2).pic=buffer(1).pic;
    buffer(1).pic=pic;
end