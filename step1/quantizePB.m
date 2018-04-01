function [qBlock] = quantizePB(dctBlock,qTable,qScale)
    q= zeros(8,8);
    q(:,:) = round( 8*dctBlock(:,:)./(qScale*qTable(:,:)));
    % converting to int16
    qBlock = int16(q);
end

