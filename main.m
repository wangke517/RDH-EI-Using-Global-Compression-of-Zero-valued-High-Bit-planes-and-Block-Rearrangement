clc;
clear;
% block size
t1  = 4; 
t2 = 4;
cover = imread('.\Testimages\Lena.bmp');
cover = double(cover);
[m, n] = size(cover);
%% Generate random embedded data
num = 20000000; % 512*512 = 2097152
rand('seed', 3); % Set seed
data = round(rand(1,num)*1); % Generate random binary data

%% Set encryption key and data hiding key
Encryption_key = 7;
Data_key = 2;

%% Encrypt image and embed auxiliary information
[Encrypted_img] = owner(cover, t1, t2, Encryption_key);
imwrite(uint8(Encrypted_img), '.\Encryptedimages\Lena.bmp');
%% Embed data
[Marked_img, data_len] = Embed_data(Encrypted_img, t1, t2, data, Data_key);
imwrite(uint8(Marked_img), '.\Markedimages\Lena.bmp');
disp("The embedded capacity is:");
disp(data_len + " bits(" + data_len/(m*n) + " bpp)");
%% Extract data
[extractData] = Extract_data(Marked_img, t1, t2, Data_key);
if extractData == data(1:data_len)
    disp("The extracted data is correct!");
else
    disp("The extracted data is wrong!");
end
%% Recover image
[recoverImg] = Recover_img(Marked_img, t1, t2, Encryption_key);
recoverImg = uint8(recoverImg);
imwrite(recoverImg, '.\Recoverimages\Lena.bmp');
ps = psnr(recoverImg, cover);
if ps==Inf
    disp('Image recovery successful!');
else
    disp('Image recovery failed!');
end

