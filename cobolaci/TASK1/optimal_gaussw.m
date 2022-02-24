
sigma = 3; 
gaussFilter = gausswin(10*sigma + 1)';
gaussFilter = gaussFilter / sum(gaussFilter);
data = [zeros(1,49) 1 zeros(1,50)];
filteredData = conv(data, gaussFilter, 'same');
estimatedPSF = zeros(477,477);
estimatedPSF(238-49:238+50,238) = filteredData;
save('evals','deblurredImage','estimatedPSF');
[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('C:\Users\xziakm00\Documents\AB2_cobolaci\Lecture2\cobolaci\TASK1\evals.mat');
old_val = NRSME_PSF;
old_sigma = 4;
step = 0.1;
NRMSE_PSF = zeros(1,20);

for i = 1:20
    sigma = sigma+0.05
    save('evals','deblurredImage','estimatedPSF');
    [NRMSE_PSF(i), RMSE_Image, PSNR] = evaluateMotion('C:\Users\xziakm00\Documents\AB2_cobolaci\Lecture2\cobolaci\TASK1\evals.mat');
    
end


save('evals','deblurredImage','estimatedPSF');
[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('C:\Users\xziakm00\Documents\AB2_cobolaci\Lecture2\cobolaci\TASK1\evals.mat');