iterations = 5;
I = imread('image_blurred.png');
NOISEPOWER = 0.00285*prod(size(I));
[BW, maskedImage] = segmentImage(I);
iter_mot = [90  100 110 120 130];
PSNR = zeros(1,5); RMSE_Image = zeros(1,5); NRMSE_PSF = zeros(1,5);
for iter = 1:iterations
 estimatedPSF = zeros(477,477);
 estimatedPSF(238-iter_mot(iter)/2:238+iter_mot(iter)/2,238) = fspecial('motion', iter_mot(iter),90);
    final_image = deconvreg(I, estimatedPSF,NOISEPOWER);
    deblurredImage = imread('image_blurred.png');
    deblurredImage(maskedImage ~= 0) = final_image(maskedImage ~= 0);
    save('evals','deblurredImage','estimatedPSF');
    [NRMSE_PSF(iter), RMSE_Image(iter), PSNR(iter)] = evaluateMotion('C:\Users\xziakm00\Documents\AB2_cobolaci\Lecture2\cobolaci\TASK1\evals.mat');
end
