function [ dctBlock ] = dequantizePB( qBlock,qTable,qScale )
    q=double(qBlock);
    dctBlock = (qScale*q.*qTable)/8;
end

