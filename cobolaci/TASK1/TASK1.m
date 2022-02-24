I = imread('image_blurred.png');
% PSF = zeros(477,477);
% PSF(238-50:238+50,238) = fspecial('motion', 100, 90);



NOISEPOWER = 0.00285*prod(size(I));
% figure; imshow(deconvreg(maskedImage, PSF,NOISEPOWER)); title('Tikhonov regularization');
final_image = deconvreg(I, estimatedPSF,NOISEPOWER);
% restored_Image(maskedImage ~= 0) = final_image(maskedImage ~= 0);












% final_image = deconvreg(maskedImage, PSF,NOISEPOWER);
% [BW, maskedImage] = segmentImage(I);
% 
% restored_Image = im2double(imread('image_blurred.png'));
% 
% restored_Image(maskedImage ~= 0) = final_image(maskedImage ~= 0);
