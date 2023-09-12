function [first_plane_sequence] = Plane_sequence(block, t1, t2, lawer, num)
first_plane_sequence = [];
index = 1;
newBlock = mod(floor(block/2^(9-lawer-1)),2);
while index <= num
    [i,j] = Index_to_bm_bn(index, t1, t2);
    first_plane_sequence = [first_plane_sequence newBlock(i,j)];
    index = index + 1;
end
end

