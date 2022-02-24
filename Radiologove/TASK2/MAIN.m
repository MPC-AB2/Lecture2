% load('PSF.mat');
%% PSF 
PSF = zeros(477,477);
PSF(238,238) = 1;
%% Resize
blurred = im2double(imread('NewImageName.png'));
blurred_res = imresize(blurred,0.5, "bicubic", 'Antialiasing',true);
[J,psfr] = deconvblind(blurred_res,PSF,30,sqrt(V));

% figure
% subplot(1,2,1)
% imshow(psfr,[])
% subplot(1,2,2)
% figure
% imshow(J)

% figure
Ir = imresize(J,2,'bicubic', 'Antialiasing',true);
% imshow(J)

load("mask.mat");

blurry(mask)= Ir(mask);

figure
imshow(blurry,[])


estimatedPSF = psfr;
deblurredImage = uint8(blurry);

save('results2.mat','estimatedPSF','deblurredImage');

[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('C:\Users\xdufko01\Desktop\lecture2\Lecture2_data\results2.mat')