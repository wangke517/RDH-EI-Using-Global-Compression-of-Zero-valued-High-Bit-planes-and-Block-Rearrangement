function [re_pos_Img] = Recover_position(decryptedImg, same_MSB_Num, MSB_LSB_num_cell, t1, t2)
[m, n] = size(decryptedImg);
bm = floor(m/t1);
bn = floor(n/t2);
re_pos_Img = decryptedImg;
same_MSB_Num_index = zeros(1,9);
for i = 1:bm
    for j = 1:bn
        block_index = 0;
        MSB_LSB_value = MSB_LSB_num_cell{i,j};
        same_MSB_Num_index(1,MSB_LSB_value+1) = same_MSB_Num_index(1,MSB_LSB_value+1) + 1;
        for k = 1:(8-MSB_LSB_value)
            block_index = block_index + same_MSB_Num(1, k);
        end
        block_index = block_index + same_MSB_Num_index(1,MSB_LSB_value+1);
        [bm1,bn1] = Index_to_bm_bn(block_index, bm, bn);
        re_pos_Img((i-1)*t1+1:i*t1, (j-1)*t2+1:j*t2) = decryptedImg((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2);
    end
end
end

