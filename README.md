# Lecture2 - IMAGE RESTAURATION

## Preparation

1. Run Git bash.
2. Set username by: `$ git config --global user.name "name_of_your_GitHub_profile"`
3. Set email by: `$ git config --global user.email "email@example.com"`
4. Select some MAIN folder with write permision.
5. Clone the **Lecture2** repository from GitHub by: `$ git clone https://github.com/MPC-AB2/Lecture2.git`
6. In the MAIN folder should be new folder **Lecture2**.
7. In the **Lecture2** folder create subfolder **NAME_OF_YOUR_TEAM**.
8. In the **NAME_OF_YOUR_TEAM** folder create two subfolders: **TASK1** and **TASK2**
9. Run Git bash in **Lecture2** folder (should be *main* branch active).
10. Create a new branch for your team by: `$ git checkout -b NAME_OF_YOUR_TEAM`
11. Check that  *NAME_OF_YOUR_TEAM* branch is active.
12. Continue to First task...

## Tasks to do

### First task – experimentally defined PSF – NON-BLIND deconvolution

1. Estimate experimentally direction in which the object is moving and design an unknown PSF of degrading linear system. Try to create PSFs as much precise as possible considering both angular orientation, shape and length of the motion blur. Consider that the matrix must be of size 45x45 pixels. The sum of PSF values has to be equal to 1.

2. Apply any of deconvolution methods on the blurred images using the experimentally designed PSFs. You can choose an arbitrary “non-blind” deconvolution method (e.g. inverse filter, Wiener filter, Richardson-Lucy deconvolution, Total Variation deconvolution or their modifications). Visually evaluate the result and adapt the PSFs to get the sufficient output.

Tip:
* Segment the moving object and perform image fusion of the sharp background from the input image and the deblurred moving object in order to get sharp image. You can choose an arbitrary method to fuse the images.

Evaluation:
Use the provided MATLAB function for evaluation of the results and submit the output to lecturer. The function *evaluateMotion.p* called as:

`[deltaPSF,deltaImage,PSNR] = evaluateMotion(deblurredImage,estimatedPSF)`,

which has the following inputs and outputs:
* deblurredImage (the final output of your algorithm – restored image),
* estimatedPSF (designed/estimated PSF of the degrading system),
* deltaPSF (difference between true and estimated PSF – lower is better),
* deltaIMG (difference of true and estimated deblurred image – lower is better),
* PSNR (PSNR value of the estimated image – higher is better).

### Second task – automatically estimated PSF – BLIND deconvolution

Search for an arbitrary blind deconvolution method and use this method to estimate an unknown PSF of the degrading linear system. Apply the same steps as before using the estimated PSF instead of the experimentally designed one. Compare the results and submit the output to lecturer.

The output of the Challenge will be six evaluating values – three for each of two approaches (experimentally determined PSF and obtained by some of blind methods).

Do not forget to PUSH your program code providing the best results to GitHub!
