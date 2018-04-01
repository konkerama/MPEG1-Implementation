function [qBlock] = quantizeI(dctBlock,qTable,qScale)
    q= zeros(8,8);

    q(:,:) = round( 8*dctBlock(:,:)./(qScale*qTable(:,:)));
    q(1,1) = round(dctBlock(1,1)/8);
    % converting to int16
    qBlock = int16(q);
end

