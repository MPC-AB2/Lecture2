
obr = imread('C:\Users\xsando01\Documents\AB2\Lecture2\ToNebudeFungovat\TASK1\image_blurred.png');

load('C:\Users\xsando01\Documents\AB2\Lecture2\ToNebudeFungovat\TASK1\sum_wiener.mat')

load('C:\Users\xsando01\Documents\AB2\Lecture2\ToNebudeFungovat\TASK1\segmentace2.mat')
obr_sum = maskedImage1;

sigma=500;
BW = imgaussfilt(double(BW1),sigma);



psfi = fspecial('motion',175,90); 
[J,psfr] = deconvblind(rgb2gray(obr),psfi);

vel = 477;
f = psfr;
PSF = padarray(f,[(vel-size(f,1))/2,(vel-size(f,2))/2],0,'both');
PSF = PSF./sum(PSF(:));

% noise_var = 0.008;
% nsr = noise_var / var(im2double(sum_obr(:)));

IMAGE = im2double(rgb2gray(obr));
maxs=max(IMAGE(:));
mins=min(IMAGE(:));
stdr=std(IMAGE(:));
y=inv(20*log10((maxs-mins)/stdr));

%wnr = deconvwnr(obr_sum, PSF, nsr);
wnr2 = deconvwnr(obr, PSF, y);

%figure; imshow(wnr2,[]);



%% SPOJENI obr
vysl_obr = zeros(size(obr));

for i=1:3
    tmp_okoli = obr(:,:,i);
    tmp_stred = wnr2(:,:,i);
    tmp_okoli = double(tmp_okoli).*(1-BW);
    tmp_stred = (double(tmp_stred).*(BW));
    final = tmp_okoli + tmp_stred;
    vysl_obr(:,:,i) = final;
end

% vysl_obr(~BW) = obr(~BW);
% vysl_obr(BW) = wnr(BW);
vysledek = uint8(vysl_obr);
figure;
subplot(1,2,1)
imshow(PSF,[])
title('PSF')
subplot(1,2,2)
imshow(vysledek,[])
title('restaurovany obraz')



estimatedPSF = PSF;
deblurredImage = vysledek;

save('vysledek.mat','estimatedPSF','deblurredImage')

addpath('C:\Users\xsando01\Documents\AB2\Lecture2')
addpath 'C:\Users\xsando01\Documents\AB2\Lecture2\ToNebudeFungovat\TASK1'
[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('C:\Users\xsando01\Documents\AB2\Lecture2\ToNebudeFungovat\TASK2\vysledek.mat')




