img = imread('image_blurred.png');
load('maska_new.mat');


psf = zeros(477);
psf = fspecial('gaussian', [477 477], 5);
imshow(psf, [])


img = im2double(img);
for i = 1:3
img_filt(:,:,i) = wiener2(img(:,:,i),[12 12]);



end
%%
[img_2, psf_est] = deconvblind(img_filt, psf, 5);

imshow(img_2, [])
%%
maska = maska2;

R = img_2(:,:,1);
G = img_2(:,:,2);
B = img_2(:,:,3);

R(maska==0) = 0;
G(maska==0) = 0;
B(maska==0) = 0;

img_2_mask(:, :, 1) = R;
img_2_mask(:, :, 2) = G;
img_2_mask(:, :, 3) = B;

R_filt = img_filt(:,:,1);
G_filt = img_filt(:,:,2);
B_filt = img_filt(:,:,3);

R_filt(maska==1) = R(maska==1);
G_filt(maska==1) = G(maska==1);
B_filt(maska==1) = B(maska==1);

fuse(:, :, 1) = R_filt;
fuse(:, :, 2) = G_filt;
fuse(:, :, 3) = B_filt;


%%
okraj_masky = bwperim(maska);

spojene_okraje = imdilate(okraj_masky, strel("disk", 20));


fuse_tmp = fuse;
for i = 1:3
    gray = fuse_tmp(:,:,i);
    % Blur the entire image
    windowSize = 5;
    kernel = ones(windowSize) / windowSize^2;
    blurredImage = imfilter(gray, kernel);
    % Now replace the gray image inside the border mask with the blurred values.
    gray(spojene_okraje) = blurredImage(spojene_okraje);
    fuse_tmp(:,:,i) = gray;
end


%%

figure
subplot 121
imshow(fuse)
subplot 122
imshow(psf, [])
title('NRMSE PSF = 0.0251; RMSE Image = 4.7778; PSNR = 24.8308')

estimatedPSF = psf_est;

deblurredImage(:,:,1) = uint8(fuse_tmp(:, :, 1).*255);
deblurredImage(:,:,2) = uint8(fuse_tmp(:, :, 2).*255);
deblurredImage(:,:,3) = uint8(fuse_tmp(:, :, 3).*255);

save vysledek.mat estimatedPSF deblurredImage
[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('vysledek.mat')
