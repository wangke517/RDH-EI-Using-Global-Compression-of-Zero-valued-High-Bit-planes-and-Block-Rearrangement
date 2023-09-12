function [embed_aux_block] = Embed_Aux_Block(block, t, MSB_value, block_LSB_label, data)
embed_aux_block = block;
dataLen = size(data, 2);
index = 0;
flag = 0;
Embed_Index_Array = [ones(1, MSB_value), block_LSB_label];
for i = 1:8
    if Embed_Index_Array(1, i) == 1
        layer = i;
        if index + t*t > dataLen
            plane_data = data(index+1:dataLen);
            num = dataLen - index;
            flag = 1;
        else
            plane_data = data(index+1:index+t*t);
            num = t*t;
        end
        index = index + t*t;
        [new_block] = Embed_plane_seq(embed_aux_block, t, layer, num, plane_data);
        embed_aux_block = new_block;
        if flag == 1
            break;
        end
    end
end


