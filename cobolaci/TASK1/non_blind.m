I = imread('image_blurred.png');

[BW,maskedImage] = segmentImage(I);
part_PSF = fspecial('motion',100,5);
part_PSF = part_PSF';
% PSF = fspecial('log',[477 477],0.5); 

PSF = zeros(477,477);
PSF( 188:288, 233:243) = part_PSF;

noise_var = 0.0001;
estimated_nsr = noise_var / var(im2double(maskedImage(:)));

wnr1 = deconvwnr(maskedImage(:,:,1),PSF, estimated_nsr(:,:,1));

figure
imshow(wnr1)
title('Restored Blurred Image')


[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion(deblurredPathName);