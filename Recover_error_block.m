function [error_matrix] = Recover_error_block(re_pos_Img, MSB_num_cell, LSB_label_Array, LSB_aux_Array, t1, t2)
[m, n] = size(re_pos_Img);
bm = floor(m/t1);
bn = floor(n/t2);
error_matrix = re_pos_Img;
block_index = 0;
LSB_index = 0;
LSB_aux_index = 0;
for i = 1:bm
    for j = 1:bn
        block_index = block_index + 1;
        [bm1, bn1] = Index_to_bm_bn(block_index, bm, bn);
        block = re_pos_Img((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2);
        MSB_value = MSB_num_cell{i,j};
        LSB_Len = 8-MSB_value;
        % MSB
        for k = 1:MSB_value
            block = block - mod(floor(block/2^(8-k)),2)*2^(8-k);
        end
        % LSB
        LSB_Label = LSB_label_Array(LSB_index+1:LSB_index+LSB_Len);
        LSB_index = LSB_index + LSB_Len;
        block = block_plane_recover(block, LSB_Label);
        % LSB_aux_Array
        for k = 1:LSB_Len
            if LSB_Label(1,k) == 1
                value = LSB_aux_Array(1,LSB_aux_index+1);
                LSB_aux_index = LSB_aux_index + 1;
                num = bin_to_dec(LSB_aux_Array(LSB_aux_index+1:LSB_aux_index+2),2);
                LSB_aux_index = LSB_aux_index + 2;
                if num == 0
                    block = block - mod(floor(block/2^(LSB_Len-k)),2)*2^(LSB_Len-k);
                    block = block + (~value)*2^(LSB_Len-k);
                else
                    plane = zeros(t1,t2) + (~value);
                    pos_bin_x = ceil(log2(t1));
                    pos_bin_y = ceil(log2(t2));
                    for x = 1:num
                        x_Pos = bin_to_dec(LSB_aux_Array(LSB_aux_index+1:LSB_aux_index+pos_bin_x),pos_bin_x)+1;
                        LSB_aux_index = LSB_aux_index + pos_bin_x;
                        y_Pos = bin_to_dec(LSB_aux_Array(LSB_aux_index+1:LSB_aux_index+pos_bin_y),pos_bin_y)+1;
                        LSB_aux_index = LSB_aux_index + pos_bin_y;
                        plane(x_Pos,y_Pos) = value;
                    end
                    block = block - mod(floor(block/2^(LSB_Len-k)),2)*2^(LSB_Len-k);
                    block = block + plane*2^(LSB_Len-k);
                end
            end
        end
        error_matrix((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2) = block;
    end
end
end

