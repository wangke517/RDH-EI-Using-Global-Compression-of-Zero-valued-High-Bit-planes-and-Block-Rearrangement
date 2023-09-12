function [En_Img] = EncryptionImg(Img, Encryption_key)
[m, n] = size(Img); 
En_Img = Img;
rand('seed',Encryption_key); 
E = round(rand(m,n)*255); 
for i=1:m
    for j=1:n
        En_Img(i,j) = bitxor(Img(i,j),E(i,j));
    end
end
end

