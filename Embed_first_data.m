function [new_block, Embed_len] = Embed_first_data(info_index, Aux_Len, All_emb_info, data, this_block, t1, t2, M, position)
% Embeddable capacity exceeds auxiliary information size
Embed_len = info_index - Aux_Len;
% Combining embedded information
if Aux_Len == 0
    block_data = data(position+1:position+Embed_len);
else
    block_data = [All_emb_info(Aux_Len+1-(t1*t2-Embed_len):Aux_Len) data(position+1:position+Embed_len)];
end
new_block = Embed_plane_seq(this_block, t1, t2, M, t1*t2, block_data);
end

