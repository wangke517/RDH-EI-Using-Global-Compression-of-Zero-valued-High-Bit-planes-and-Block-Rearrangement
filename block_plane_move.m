function [this_block] = block_plane_move(block, LSB_label)
len = size(LSB_label,2);
for i = 1:len
    flag = 0;
    MSB1 = len + 1 - i;
    if LSB_label(1,i) == 1
        continue;
    end
    for j = i+1:len
        MSB2 = len + 1 - j;
        if LSB_label(1,j) == 1
            a = mod(floor(block/2^(MSB1-1)),2);
            b = mod(floor(block/2^(MSB2-1)),2);
            block = block - a*2^(MSB1-1) - b*2^(MSB2-1) + a*2^(MSB2-1) + b*2^(MSB1-1);
            LSB_label(1,j) = 0;
            LSB_label(1,i) = 1;
            flag = 1;
            break;
        end
    end
    if flag == 0
        break;
    end
end
this_block = block;
end

