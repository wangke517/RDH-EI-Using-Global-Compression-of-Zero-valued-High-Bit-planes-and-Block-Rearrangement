function [codes,dict] = huffman_encoding(freqs)

% Sort the input frequencies and convert them into leaf nodes
% sorted_freqs：Sort from small to large, corresponding to the original index  indices：Results sorted from small to large
[sorted_freqs, indices] = sort(freqs);
disp(indices);
disp(sorted_freqs);
leaves = cell(size(freqs));
for i = 1:length(leaves)
    leaves{i} = indices(i);
end

% Building a tree using Huffman's algorithm
tree = build_tree(sorted_freqs, leaves);

% Build coding dictionary
dict = cell(length(freqs), 2);
codes = cell(length(freqs), 1);
for i = 1:length(freqs)
    code = '';
    node = i;
    while node ~= tree.root
        if node == tree.left(tree.parent(node))
            code = ['0' code];
        else
            code = ['1' code];
        end
        node = tree.parent(node);
    end
    dict{i, 1} = indices(i);
    dict{i, 2} = code;
    codes{i} = code;
end

end

function tree = build_tree(freqs, leaves)

% initialization tree
n = length(freqs);
tree.parent = zeros(1, 2*n-1);
tree.left = zeros(1, 2*n-1);
tree.right = zeros(1, 2*n-1);
for i = 1:n
    tree.parent(i) = 0;
end

% Recursively build tree
for i = n+1:2*n-1
    min_freqs = inf(1, 2);
    min_nodes = zeros(1, 2);
    for j = 1:i-1
        if tree.parent(j) == 0
            if freqs(j) < min_freqs(1)
                min_freqs(2) = min_freqs(1);
                min_nodes(2) = min_nodes(1);
                min_freqs(1) = freqs(j);
                min_nodes(1) = j;
            elseif freqs(j) < min_freqs(2)
                min_freqs(2) = freqs(j);
                min_nodes(2) = j;
            end
        end
    end
    tree.parent(min_nodes(1)) = i;
    tree.parent(min_nodes(2)) = i;
    tree.left(i) = min_nodes(1);
    tree.right(i) = min_nodes(2);
    freqs(i) = min_freqs(1) + min_freqs(2);
end
tree.root = 2*n-1;

% Mark leaf nodes as negative
for i = 1:n
    tree.left(i) = -leaves{i};
end

end

