function [De_Img] = DecryptionImg(Img, Encryption_key)
[m, n] = size(Img); 
De_Img = Img;
rand('seed',Encryption_key); 
E = round(rand(m,n)*255); 
for i=1:m
    for j=1:n
        De_Img(i,j) = bitxor(Img(i,j),E(i,j));
    end
end
end

