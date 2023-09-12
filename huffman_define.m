function [huffman_rule] = huffman_define(freqs)
code = {[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],[0 0 0 0 1],[1 1 1 1 0],[0 0 0 0 0 1]};
huffman_rule = code;
[sorted_freqs, indices] = sort(freqs);
for i = 1:9
    index = indices(i);
    huffman_rule{index} = code{10-i};
end