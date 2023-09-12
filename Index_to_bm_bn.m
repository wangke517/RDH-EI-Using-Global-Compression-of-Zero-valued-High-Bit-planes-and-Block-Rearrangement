function [bm1, bn1] = Index_to_bm_bn(index, bm, bn)
if mod(index, bn) == 0
    bm1 = floor(index/bn);
else
    bm1 = floor(index/bn) + 1;
end
bn1 = index - (bm1-1)*bn;
end

