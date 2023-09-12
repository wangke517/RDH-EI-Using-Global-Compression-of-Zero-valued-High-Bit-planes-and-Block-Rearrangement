function [same_MSB, LSB_label, LSB_aux_info] = Pre_aux_block(error_block, t1, t2)

same_MSB = 0;
LSB_label = [];
LSB_aux_info = [];
for i = 1:8
    wg = 2^(8-i);
    plane_block = floor(error_block/wg);
    if isempty(find(plane_block == 1)) == 0
        break;
    end
    same_MSB = same_MSB + 1;
end
%% Find threshold
for i = 1:t1*t2
    all_acc_num = 1 + ceil(log2(i+1)) + i*(ceil(log2(t1))+ceil(log2(t2)));
    if all_acc_num >= t1*t2
        max_limit = i-1;
        break;
    end
end
limit_bit_num = ceil(log2(max_limit+1));
for i = same_MSB+1 :8
    wg = 2^(8-i);
    plane_block = floor(error_block/wg);
    plane_block = mod(plane_block, 2);
    num0 = sum(plane_block(:)==0);
    num1 = sum(plane_block(:)==1);
    if num0 < num1
        value = 0;
    else
        value = 1;
    end
    min_value = min(num0, num1);
    if min_value <= max_limit
        LSB_label = [LSB_label 1];
        LSB_aux_info = [LSB_aux_info value];
        emb_bin = dec_to_bin(min_value, limit_bit_num);
        LSB_aux_info = [LSB_aux_info emb_bin];
        position_num1 = ceil(log2(t1));
        position_num2 = ceil(log2(t2));
        for x = 1:t1
            for y = 1:t2
                if plane_block(x, y) == value
                    x_bin = dec_to_bin(x-1, position_num1);
                    y_bin = dec_to_bin(y-1, position_num2);
                    LSB_aux_info = [LSB_aux_info x_bin y_bin];
                end
            end
        end
    else
        LSB_label = [LSB_label 0];
    end
end

