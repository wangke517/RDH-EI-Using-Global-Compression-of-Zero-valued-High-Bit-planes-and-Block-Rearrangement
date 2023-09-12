function [Marked_img, data_index] = Embed_data(Encrypted_img, t1, t2, data, Data_key)
[m, n] = size(Encrypted_img);
bm = floor(m/t1);
bn = floor(n/t2);
Marked_img = Encrypted_img;
All_emb_info = [];
one_block = 1;
% first block
first_block = Encrypted_img(1:t1,1:t2);
layer = 1;
[first_plane_sequence] = Plane_sequence(first_block, t1, t2, layer, t1*t2);
All_emb_info = [All_emb_info first_plane_sequence];
% index of All_emb_info
index = 0;
% index of block
block_index = 0;
same_MSB_Num = [];
NumbinLen = ceil(log2(bm*bn));
[Encrypted_data] = EncryptionString(data, Data_key);
for i = 9:-1:1
    % current MSB_value
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
    same_MSB_Num = [same_MSB_Num MSB_Num];
    index = index + NumbinLen;
    if MSB_Num == 0
        continue;
    else
        block_end_index = block_index + MSB_Num;
        % if it is the first block
        if one_block == 1
            % MSB
            for j = layer+1:MSB_value
                All_emb_info = [All_emb_info Plane_sequence(first_block, t1, t2, j, t1*t2)];
            end
            one_block = 0;
            block_index = block_index + 1;
        end
        for j = block_index+1:block_end_index
            % The row and column of the current block
            [bm1, bn1] = Index_to_bm_bn(j, bm, bn);
            this_block = Encrypted_img((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2);
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
%% get All_emb_info and Aux_Len
flag = 1;
Info_index = 0;
data_index = 0;
block_index = 0;
for i = 1:9
    MSB_value = 9-i;
    MSB_Num = same_MSB_Num(1, i);
    for j = 1:MSB_Num
        block_index = block_index + 1;
        [bm1,bn1] = Index_to_bm_bn(block_index, bm, bn);
        for m = 1:MSB_value
             this_block = Marked_img((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2);
             Info_index = Info_index + t1*t2;
             if flag == 0
                [new_block, Embed_len] = Embed_first_data(t1*t2, 0, All_emb_info, Encrypted_data, this_block, t1, t2, m, data_index);
                data_index = data_index + Embed_len;
                Marked_img((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2) = new_block;
             end
             if Info_index > Aux_Len && flag == 1
                 [new_block, Embed_len] = Embed_first_data(Info_index, Aux_Len, All_emb_info, Encrypted_data, this_block, t1, t2, m, 0);
                 data_index = data_index + Embed_len;
                 flag = 0;
                 Marked_img((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2) = new_block;
             end
        end
    end
end


