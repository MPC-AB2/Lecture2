% TV denoising demo using tvrestore, Pascal Getreuer 2010
%
% This is a MATLAB script.  To run it, enter on the MATLAB console
%   >> tvdenoise_demo

PSF = zeros(477,477);
PSF(239,239) = 1;
PSF = imgaussfilt(PSF,100);
PSF(:,1:238) = 0;
PSF(:,240:477) = 0;
PSF = PSF/sum(sum(PSF));
imshow(PSF,[]);

NoiseLevel = 0.06; 
lambda = 8;

% Simulate a noisy image
uexact = double(imread('image_blurred.png'))/255;
f = uexact; %+ randn(size(uexact))*NoiseLevel;

% Make a figure 
clf;
set(gcf,'Color',[1,1,1],'NumberTitle','off','Name','TV Denoising');
compareimages(f,'Input',f,'Denoised');
shg;

% Denoise
u = tvdenoise(f,lambda,[],[],[],@tvregsimpleplot);

%compareimages(f,'Input',u,'Denoised');
%%
load('mask.mat')
blurred = u;
R = blurred(:,:,1);
G = blurred(:,:,2);
B = blurred(:,:,3);

R_z = uint8(zeros(size(R)));
G_z = uint8(zeros(size(G)));
B_z = uint8(zeros(size(B)));

R_z(mask) = R(mask);
G_z(mask) = G(mask);
B_z(mask) = B(mask);

mask_blurred = cat(3,R_z,G_z,B_z);

PSF = fspecial('motion',203,90);

wnr1 = deconvlucy(mask_blurred,PSF);
%%
blurred = imread('NewImageName.png');
% PSF = zeros(477,477);
% PSF(239,239) = 1;
% PSF = imgaussfilt(PSF,100);
% PSF(:,1:238) = 0;
% PSF(:,240:477) = 0;
% PSF = PSF/sum(sum(PSF));
% imshow(PSF,[]);

% PSF = fspecial('motion',200,-85);

wnr1 = deconvlucy(blurred,PSF);
