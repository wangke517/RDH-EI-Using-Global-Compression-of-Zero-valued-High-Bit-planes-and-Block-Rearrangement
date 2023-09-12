function [EncryptedString] = EncryptionString(string, Encryption_key)
EncryptedString = string;
len = size(string, 2);
rand('seed',Encryption_key); 
E = round(rand(1,len)); 
for i = 1:len
    EncryptedString(1,i) = bitxor(string(1,i),E(1,i));
end
end

