function [this_block] = block_plane_recover(block, LSB_Label)
this_block = block;
LSB_Len = size(LSB_Label, 2);
index_Array = zeros(1,LSB_Len);
for i = 1:LSB_Len
    index_Array(1,i) = i;
end
for i = 1:LSB_Len
    flag = 0;
    if LSB_Label(1,i) == 1
        continue;
    end
    for j = i+1:LSB_Len
        if LSB_Label(1,j) == 1
            a = index_Array(1,i);
            b = index_Array(1,j);
            index_Array(1,i) = b;
            index_Array(1,j) = a;
            LSB_Label(1,j) = 0;
            LSB_Label(1,i) = 1;
            flag = 1;
            break;
        end
    end
    if flag == 0
        break;
    end
end
for i = 1:LSB_Len
    plane_index = index_Array(1,i);
    this_plane = mod(floor(block/2^(LSB_Len-i)),2);
    this_block = this_block - mod(floor(block/2^(LSB_Len-plane_index)),2)*2^(LSB_Len-plane_index) + this_plane*2^(LSB_Len-plane_index);
end

