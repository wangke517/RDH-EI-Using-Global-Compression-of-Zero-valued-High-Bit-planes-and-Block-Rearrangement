function [data] = Extract_data(Marked_img, t1, t2, Data_key)
[m, n] = size(Marked_img);
bm = floor(m/t1);
bn = floor(n/t2);
All_emb_info = [];
one_block = 1;
first_block = Marked_img(1:t1,1:t2);
layer = 1;
[first_plane_sequence] = Plane_sequence(first_block, t1, t2, layer, t1*t2);
All_emb_info = [All_emb_info first_plane_sequence];
index = 0;
block_index = 0;
NumbinLen = ceil(log2(bm*bn));
for i = 9:-1:1
    MSB_value = i-1;
    if index+NumbinLen > size(All_emb_info, 2) && one_block == 1
        layer = layer + 1;
        if layer > MSB_value
            disp("Block storage error");
            break;
        end
        All_emb_info = [All_emb_info Plane_sequence(first_block, t1, t2, layer, t1*t2)];
    end
    MSB_Num = bin_to_dec(All_emb_info(index+1:index+NumbinLen), NumbinLen);
    index = index + NumbinLen;
    if MSB_Num == 0
        continue;
    else
        block_end_index = block_index + MSB_Num;
        if one_block == 1
            % MSB
            for j = layer+1:MSB_value
                All_emb_info = [All_emb_info Plane_sequence(first_block, t1, t2, j, t1*t2)];
            end
            one_block = 0;
            block_index = block_index + 1;
        end
        for j = block_index+1:block_end_index
            [bm1, bn1] = Index_to_bm_bn(j, bm, bn);
            this_block = Marked_img((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2);
            % MSB
            for M = 1:MSB_value
                All_emb_info = [All_emb_info Plane_sequence(this_block, t1, t2, M, t1*t2)];
            end
        end
        block_index = block_end_index; 
    end
end
if block_index ~= bm*bn
    disp("An error occurred in the previous operation");
end
%% all auxiliary information
Aux_Len = 9*NumbinLen;
% remain_auxInfo
bin_size = ceil(log2(m*n*8));
remain_auxInfo_size_bin = All_emb_info(Aux_Len+1:Aux_Len+bin_size);
remain_auxInfo_size = bin_to_dec(remain_auxInfo_size_bin, bin_size);
Aux_Len = Aux_Len + bin_size + remain_auxInfo_size;
data = All_emb_info(Aux_Len+1:size(All_emb_info,2));
data = DecryptionString(data, Data_key);
end

