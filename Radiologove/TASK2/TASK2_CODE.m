I = im2double(imread('NewImageName.png'));
% I = imresize(I,0.5);
V = .0001;
[J,psfr] = deconvblind(I,PSF,15,sqrt(V));

figure
subplot(1,2,1)
imshow(psfr,[])
subplot(1,2,2)
% figure
imshow(J)

figure
% Ir = imresize(J,2,'bicubic');
imshow(J)

load("mask2.mat");

I(mask)= J(mask);
%%
figure
subplot 121
imshow(I,[])
subplot 122
imshow(psfr,[])
%%
estimatedPSF = psfr;
deblurredImage = I;
save('results.mat','estimatedPSF','deblurredImage');

