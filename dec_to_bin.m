function [bin] = dec_to_bin(dec, bit_num)
bin = [];
for i = 1:bit_num
    bin = [bin mod(floor(dec/2^(bit_num-i)), 2)];
end

