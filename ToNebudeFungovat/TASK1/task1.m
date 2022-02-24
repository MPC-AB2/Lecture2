
addpath('C:\Users\xsando01\Documents\AB2\Lecture2')
obr = imread("image_blurred.png");

% obr_0 = rgb2gray(obr);
% figure; imshow(imread("image_blurred.png"),[])


% sum = imcrop(imread("image_blurred.png"));
load('sum_wiener.mat')

load('segmentace2.mat')
%% získání PSF
vel = 477;
f = fspecial('motion',260,90); %nejlepší 260, uloženo výsledek

x = linspace(1,20,length(f));
y = gaussmf(x,[5 10]);
% plot(x,y)
% f = f*y';

PSF = padarray(y',[(vel-size(f,1))/2,(vel-size(f,2))/2],0,'both');
PSF = PSF./sum(PSF(:));

%% odhad  postup č.1
% noise_var = 0.008;
% nsr = noise_var / var(im2double(sum_obr(:)));

%% odhad postup č.2
IMAGE = im2double(rgb2gray(sum_obr));
maxs=max(IMAGE(:));
mins=min(IMAGE(:));
stdr=std(IMAGE(:));
nsr=inv(20*log10((maxs-mins)/stdr));


wnr = deconvwnr(obr, PSF, nsr);

% figure; imshow(wnr,[]);

%% Uprava BW
% navrhni gaus filtr a vyfiltruj tím BW abys pak jen nenahrazovala ale
% trochu váhovala
% matice = [];
sigma=500;
BW = imgaussfilt(double(BW1),sigma);
%% SPOJENI obr
vysl_obr = zeros(size(obr));
obr = imnlmfilt(obr);

for i=1:3
    tmp_okoli = obr(:,:,i);
    tmp_stred = wnr(:,:,i);
    tmp_okoli = double(tmp_okoli).*(1-BW);
    tmp_stred = (double(tmp_stred).*(BW));
    final = tmp_okoli + tmp_stred;
    vysl_obr(:,:,i) = final;
end

% vysl_obr(~BW) = obr(~BW);
% vysl_obr(BW) = wnr(BW);
vysledek = uint8(vysl_obr);
% figure; imshow(vysledek,[])

estimatedPSF = PSF;
deblurredImage = vysledek;

save('vysledek2.mat','estimatedPSF','deblurredImage')

cesta = "C:\Users\xsando01\Documents\AB2\Lecture2\ToNebudeFungovat\TASK1\vysledek2.mat";
[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion(cesta)


subplot(121)
imshow(estimatedPSF,[])
title("PSF")
subplot(122)
imshow(deblurredImage,[])
title("Rekonstruovaný obraz")

