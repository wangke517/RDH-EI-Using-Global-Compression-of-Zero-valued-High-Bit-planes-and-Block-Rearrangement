function [recoverImg, error_matrix] = Recover_img(Marked_img, t1, t2, Encryption_key)
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
same_MSB_Num = [];
NumbinLen = ceil(log2(bm*bn));
for i = 9:-1:1
    % MSB_value of current block
    MSB_value = i-1;
    % MSB_num is not enough
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
Aux_Len = Aux_Len + bin_size;
en_remain_auxInfo = All_emb_info(Aux_Len+1:Aux_Len+remain_auxInfo_size);
remain_auxInfo = DecryptionString(en_remain_auxInfo, Encryption_key);
index = 0;
% rule
rule_cell = cell(1,9);
for i = 1:9
    num1 = 0;
    num0 = 0;
    rule_bin = [];
    while num1 == 0 || num0 == 0
        index = index + 1;
        rule_bin = [rule_bin remain_auxInfo(1, index)];
        if remain_auxInfo(1, index) == 1
            num1 = 1;
        else
            num0 = 1;
        end
    end
    rule_cell{1,i} = rule_bin;
end
% MSB_num
MSB_num_cell = cell(bm,bn);
MSB_All_num = 0;
for i = 1:bm
    for j = 1:bn
        num1 = 0;
        num0 = 0;
        MSB_bin = [];
        while num1==0 || num0 == 0
            index = index + 1;
            MSB_bin = [MSB_bin remain_auxInfo(1, index)];
            if remain_auxInfo(1, index) == 1
                num1 = 1;
            else
                num0 = 1;
            end
        end
        for k = 1:9
            if isequal(rule_cell{1,k},MSB_bin)
                MSB_num_cell{i,j} = k-1;
                MSB_All_num = MSB_All_num + k-1;
            end
        end
    end
end
LSB_label_Array = remain_auxInfo(index+1:index+(bm*bn*8-MSB_All_num));
index = index + (bm*bn*8-MSB_All_num);
now_index = index;
for i = 1:sum(LSB_label_Array==1)
    index = index + 1;
    num = bin_to_dec(remain_auxInfo(index+1:index+2),2);
    index = index + 2 + num*(ceil(log2(t1))+ceil(log2(t2)));
end
LSB_aux_Array = remain_auxInfo(now_index+1:index);
error_sign_label = remain_auxInfo(index+1:index+m*n-1);
index = index + m*n-1;
first_piexl = remain_auxInfo(index+1: index+8);

%% Image Processing
[decryptedImg] = DecryptionImg(Marked_img, Encryption_key);
MSB_LSB_num_cell = cell(bm,bn);
LSB_index = 0;
for i = 1:bm
    for j = 1:bn
        MSB_value = MSB_num_cell{i,j};
        LSB_all_value = 8 - MSB_value;
        LSB_value = sum(LSB_label_Array(LSB_index+1:LSB_index+LSB_all_value)==1);
        MSB_LSB_num_cell{i,j} = MSB_value + LSB_value;
        LSB_index = LSB_index + LSB_all_value;
    end
end
% Restore blocks within the image to their original positions
[re_pos_Img] = Recover_position(decryptedImg, same_MSB_Num, MSB_LSB_num_cell, t1, t2);
% Recover the bit-planes within each block
[error_matrix] = Recover_error_block(re_pos_Img, MSB_num_cell, LSB_label_Array, LSB_aux_Array, t1, t2);
error_matrix(1,1) = bin_to_dec(first_piexl, 8);
[recoverImg] = Recover_error_matrix(error_matrix, error_sign_label);
end

