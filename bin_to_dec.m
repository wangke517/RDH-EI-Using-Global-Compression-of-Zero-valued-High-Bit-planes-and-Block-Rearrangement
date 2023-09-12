function [dec] = bin_to_dec(MSB_number_bin, size)
dec = 0;
for i = 1:size
    dec = dec + MSB_number_bin(1,i) * 2^(size-i);
end

