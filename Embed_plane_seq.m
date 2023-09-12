function [new_block] = Embed_plane_seq(block, t1, t2, lawer, num, data)
for i = 1:num
    [bm1,bn1] = Index_to_bm_bn(i,t1,t2);
    if mod(floor(block(bm1, bn1)/2^(8-lawer)), 2) ~= data(1, i)
        if data(1, i) == 1
            block(bm1, bn1) = block(bm1, bn1) + 2^(8-lawer);
        else
            block(bm1, bn1) = block(bm1, bn1) - 2^(8-lawer);
        end
    end
end
new_block = block;

