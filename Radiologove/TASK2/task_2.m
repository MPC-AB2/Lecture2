I = im2double(imread('image_blurred.png')); % load image
PSF = fspecial('disk', 8); % define PSF
Blurred = imfilter(I, PSF,'circular','conv' ); % create blured image
Blurred = imnoise(Blurred, 'gaussian', 0, 0.00001); % Add noise
figure();
subplot 121
imshow(Blurred); title('Blurred image'); % IMAGE
subplot 122
imshow(deconvreg(Blurred, PSF)); title('Tikhonov regularization');
sgtitle('Axial scane of CT from MPC VIZ') 
%%
I = im2double(imread('NewImageName.png'));
%%
a = imread('C:/Users/xkanto13/Desktop/ABO2/Lecture2/Lecture2/Radiologove/TASK1/NewImageName.png');

load('mask.mat')

R = a(:,:,1);
G = a(:,:,2);
B = a(:,:,3);

R_z = uint8(zeros(size(R)));
G_z = uint8(zeros(size(G)));
B_z = uint8(zeros(size(B)));

R_z(mask) = R(mask);
G_z(mask) = G(mask);
B_z(mask) = B(mask);

mask_blurred = cat(3,R_z,G_z,B_z);



PSF = fspecial('motion',203,-90);
imshow(deconvlucy(mask_blurred, PSF)); title('Tikhonov regularization');
%wnr1 = deconvwnr(mask_blurred,PSF);
%%
mask_blurred = im2double(mask_blurred);
a= im2double(a);


PSF = zeros(477,477);
PSF(180:300, 238) = 1;
PSF = imgaussfilt(PSF,10);
PSF = PSF./ sum(sum(PSF));
%%PSF = imgaussfilt(PSF,10);
wnr1 = deconvlucy(a, PSF);
imshow(wnr1,[])
%%
%PSF = fspecial('motion',200,90);
PSF = zeros(477,477);
n = 100;
PSF(239-(n/2):239+(n/2), 239) = 0.01;

wnr4 = deconvlucy(a, PSF);


%%
blurred = im2double(imread('NewImageName.png'));
PSF = zeros(477,477);
PSF(239,239) = 1;
PSF = imgaussfilt(PSF,100);
PSF(1:180,1:237) = 0;
PSF(300:477,239:477) = 0;
PSF = PSF/(sum(sum(PSF)));
imshow(PSF,[]);

% PSF = fspecial('motion',200,-85);

wnr3 = deconvlucy(blurred,PSF);
figure
imshow(wnr1,[]);

% PSF(1:477, 239) = 1;
% PSF = imgaussfilt(PSF,5);
PSF = PSF./sum(PSF(:));
imshow(PSF,[])

wnr2 = deconvwnr(im2double(a),PSF);

figure;
imshow(wnr1,[])
%%
a(mask)= wnr3(mask);
%%
a = imread('C:/Users/xkanto13/Desktop/ABO2/Lecture2/Lecture2/Radiologove/TASK1/NewImageName.png');
a = im2double(a);
imshow(a)
 h = drawfreehand;
 %%
 mask=createMask(h);
 a(mask)= wnr3(mask);
 %%
 estimatedPSF= load("estimatedPSF.mat");
 deblurredImage = load("deblurredImage.mat");
 %%
a = imread('C:/Users/xkanto13/Desktop/ABO2/Lecture2/Lecture2/Radiologove/TASK1/obr.png');
%a = im2double(a);
deblurredImage = a;
%%
PSF = zeros(477,477);
PSF(239,239) = 1;
PSF = imgaussfilt(PSF,100);
PSF(:,1:238) = 0;
PSF(:,240:477) = 0;
PSF = PSF/sum(sum(PSF));
imshow(PSF,[]);
estimatedPSF = PSF;
%%
deblurredImage =imread("obr.png");
%%
a= uint8(a);
deblurredImage = a;

%%

%%
figure
subplot 121
imshow(a);
subplot 122
PSF = zeros(477,477);
PSF(239,239) = 1;
PSF = imgaussfilt(PSF,100);
PSF(:,1:238) = 0;
PSF(:,240:477) = 0;
PSF = PSF/sum(sum(PSF));
imshow(PSF,[]);
%%
deblurredImage = load("I.mat");
estimatedPSF = load("psfr.mat");
deblurredImage = uint8(deblurredImage.I);
estimatedPSF = estimatedPSF.psfr;
save('results.mat','estimatedPSF','deblurredImage');
%%

[a,PSNR,RMSE]=evaluateMotion("C:\Users\xkanto13\Desktop\ABO2\Lecture2\Lecture2\Radiologove\TASK2\results.mat")

