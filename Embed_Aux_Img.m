function [Emb_aux_img] = Embed_Aux_Img(En_img, t1, t2, same_All_Num_bin, remain_auxInfo_size, EncryptedAuxString)
Emb_aux_img = En_img;
[m, n] = size(En_img);
bm = floor(m/t1);
bn = floor(n/t2);
% All auxiliary information that needs to be embedded
AllInfo = [same_All_Num_bin, remain_auxInfo_size, EncryptedAuxString];
% The length of all auxiliary information
InfoLen = size(AllInfo,2);
% Traverse
index = 0;
block_index = 0;
data_index = 0;
flag = 0;
NumbinLen = ceil(log2(bm*bn));
for i = 9:-1:1
    MSB_value = i-1;
    % same_All_Num_bin
    MSB_number_bin = same_All_Num_bin(index+1:index+NumbinLen);
    [MSB_number] = bin_to_dec(MSB_number_bin, NumbinLen);
    % If the number of current block is not 0
    if MSB_number ~= 0
        index = index + NumbinLen;
        % Traverse MSB_number blocks
        for j = block_index+1:(block_index + MSB_number)
           % row and column of block
           [bm1, bn1] = Index_to_bm_bn(j, bm, bn);
           for M = 1:MSB_value
               % Characteristic data of the current block
               block = Emb_aux_img((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2);
               if data_index + t1*t2 > InfoLen
                   data = AllInfo(data_index+1:InfoLen);
                   num = InfoLen - data_index;
               else
                   data = AllInfo(data_index+1:data_index+t1*t2);
                   num = t1*t2;
               end
               [new_block] = Embed_plane_seq(block, t1, t2, M, num, data);
               Emb_aux_img((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2) = new_block;
               data_index = data_index + t1*t2;
               if data_index >= InfoLen
                   flag = 1;
                   break;
               end
           end
           if flag == 1
               break;
           end
        end
        block_index = block_index + MSB_number;
    else
        index = index + NumbinLen; 
    end
    if flag ==1
        break;
    end
end


