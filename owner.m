function [Encrypted_img] = owner(cover, t1, t2, Encryption_key)
[m, n] = size(cover);
bm = floor(m/t1);
bn = floor(n/t2);
% Count the number of blocks with different N_czb
same_MSB_Num = zeros(1, 9);
% The combination of N_czb of all APE blocks
same_MSB_dec = [];
% N_eb
same_MSB_Array = ones(bm, bn);
% Count the number of blocks with different N_eb
same_MSB_LSB_Num = zeros(1, 9);
same_All_Num_bin = [];
% all N_czb after huffman coding 
same_MSB_bin = [];
% The combination of Map of all APE blocks
LSB_label_Array = [];
LSB_label_cell = cell(bm, bn);
% The combination of Inf of all APE blocks
LSB_aux_Array = [];

%% Get APE image and sign map
[error_matrix, error_sign_label] = Pre_error_matrix(cover);

%% Process each individual divided block
for i = 1:bm
    for j = 1:bn
        error_block = error_matrix((i-1)*t1+1:i*t1, (j-1)*t2+1:j*t2);
        % Analyze each APE block and return N_czb, Map and Inf
        [same_MSB, LSB_label, LSB_aux_info] = Pre_aux_block(error_block, t1, t2);
        % Count the number of blocks with different same_MSB
        same_MSB_Num(1, same_MSB+1) = same_MSB_Num(1, same_MSB+1) + 1;
        same_MSB_dec = [same_MSB_dec same_MSB];
        LSB_label_Array = [LSB_label_Array LSB_label];
        LSB_label_cell{i,j} = LSB_label;
        LSB_aux_Array = [LSB_aux_Array LSB_aux_info];
        same_MSB_LSB_Num(1, same_MSB+sum(LSB_label==1)+1) = same_MSB_LSB_Num(1, same_MSB+sum(LSB_label==1)+1) + 1;
        % N_eb
        same_MSB_Array(i, j) = same_MSB + sum(LSB_label==1);
    end
end
numBit = 0;
for i = 1:9
    numBit = numBit + same_MSB_LSB_Num(1, i)*(i-1)*t1*t2;
end
%% Formulate rules based on Huffman coding
[huffman_rule] = huffman_define(same_MSB_Num);
rule = [];
% Huffman encoding
for i = 1:bm*bn
    MSB_value = same_MSB_dec(1,i);
    same_MSB_bin = [same_MSB_bin huffman_rule{MSB_value+1}];
end
for i = 1:9
    rule = [rule huffman_rule{i}];
end  
same_MSB_bin = [rule same_MSB_bin];

%% bit-plane swapping and block rearrangement
[sort_error_matrix] = Sort_error_matrix(error_matrix, same_MSB_Array, LSB_label_cell, t1, t2);
for i = 9:-1:1
    oneBin = dec_to_bin(same_MSB_LSB_Num(1,i),ceil(log2(bm*bn)));
    same_All_Num_bin = [same_All_Num_bin oneBin];
end

%% Image Encryption
[En_img] = EncryptionImg(sort_error_matrix, Encryption_key);

%% Embed auxiliary information into the encrypted image
first_piexl = dec_to_bin(cover(1,1), 8);
remain_auxInfo = [same_MSB_bin, LSB_label_Array, LSB_aux_Array, error_sign_label, first_piexl];
% Encrypt auxiliary information
EncryptedAuxString = EncryptionString(remain_auxInfo, Encryption_key);
remain_auxInfo_size_dec = size(remain_auxInfo, 2);
remain_auxInfo_size_bin = dec_to_bin(remain_auxInfo_size_dec, ceil(log2(m*n*8)));
[Emb_aux_img] = Embed_Aux_Img(En_img, t1, t2, same_All_Num_bin, remain_auxInfo_size_bin, EncryptedAuxString);
Encrypted_img = Emb_aux_img;
end

