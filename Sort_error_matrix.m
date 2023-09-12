function [sort_error_matrix] = Sort_error_matrix(error_matrix, same_MSB_Array, LSB_label_cell, t1, t2)
[m, n] = size(error_matrix);
bm = floor(m/t1);
bn = floor(n/t2);
sort_error_matrix = error_matrix;
% Which block is it currently
block_index = 1;
for i = 9:-1:1
    for j = 1:bm
        for k = 1:bn
            if same_MSB_Array(j, k) == i-1
                LSB_label = LSB_label_cell{j,k};
                [bm1, bn1] = Index_to_bm_bn(block_index, bm, bn);
                if sum(LSB_label == 1) ~= 0
                    block = error_matrix((j-1)*t1+1:j*t1, (k-1)*t2+1:k*t2);
                    [this_block] = block_plane_move(block, LSB_label);
                else
                    this_block = error_matrix((j-1)*t1+1:j*t1, (k-1)*t2+1:k*t2);
                end
                sort_error_matrix((bm1-1)*t1+1:bm1*t1, (bn1-1)*t2+1:bn1*t2) = this_block;
                block_index = block_index + 1;
            end
        end
    end
end
if block_index ~= bm*bn+1
    disp("An error occurred while sorting error_matrix");
end
end

