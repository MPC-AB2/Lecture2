import cv2
import numpy as np
import scipy.io as sio
from matplotlib import pyplot as plt
from scipy import signal, fft
from skimage.restoration import denoise_tv_chambolle, denoise_wavelet, richardson_lucy
from scipy.ndimage import gaussian_filter
from scipy.signal import fftconvolve

if __name__ == '__main__':
    img = cv2.imread('/Users/ondra/dev/school/Lecture2/prvni/task1/Lecture2_data/image_blurred.png')
    tmp = sio.loadmat("/Users/ondra/dev/school/Lecture2/prvni/task1/bin-maska.mat")
    mask = tmp["BW"]
    crop = img * np.dstack((mask, mask, mask))
    mu = 0
    sig = 2
    x = np.linspace(-3, 3, 301)
    gauss = np.exp(-np.power(x - mu, 2.) / (2 * np.power(sig, 2.)))
    psf = np.zeros((477, 477))
    psf[87:388, int(np.round(psf.shape[0] / 2))] = gauss
    psf[87:388, int(np.round(psf.shape[0] / 2)) - 1] = gauss
    psf[87:388, int(np.round(psf.shape[0] / 2)) + 1] = gauss
    # psf[87:388, int(np.round(psf.shape[0] / 2)) - 2] = 1 - gauss
    # psf[87:388, int(np.round(psf.shape[0] / 2)) + 2] = 1 - gauss
    # psf[87:388, int(np.round(psf.shape[0] / 2)) - 3] = 1 - gauss
    # psf[87:388, int(np.round(psf.shape[0] / 2)) + 3] = 1 - gauss

    psf = psf / np.sum(psf)

    img = gaussian_filter(img, 15)


    def richardson_lucy_blind(image, psf, num_iter=30):
        im_deconv = np.full(image.shape, 0.1, dtype='float')  # init output
        for i in range(num_iter):
            psf_mirror = np.flip(psf)
            conv = fftconvolve(im_deconv, psf, mode='same')
            relative_blur = image / conv
            im_deconv *= fftconvolve(relative_blur, psf_mirror, mode='same')
            im_deconv_mirror = np.flip(im_deconv)
            psf *= fftconvolve(relative_blur, im_deconv_mirror, mode='same')
        return im_deconv, psf


    # tmp = richardson_lucy_blind(img, psf, num_iter=1)

    new_psf = np.zeros((img.shape[0], img.shape[1]))

    nb = new_psf.shape[0]
    na = psf.shape[0]
    lower = (nb) // 2 - (na // 2)
    upper = (nb // 2) + (na // 2) + 1
    new_psf[lower:upper, lower:upper] = psf

    deconvolved_RL, final_psf = richardson_lucy_blind(img[:, :, 0], new_psf, num_iter=1)
    final_psf_new = final_psf[lower:upper, lower:upper]

    crop_unblur = deconvolved_RL * mask

    new_final = img

    new_final[:, :, 0] = np.where(mask == 1, crop_unblur, img[:, :, 0])
    new_final[:, :, 1] = np.where(mask == 1, crop_unblur, img[:, :, 1])
    new_final[:, :, 2] = np.where(mask == 1, crop_unblur, img[:, :, 2])

    np.savez("results5.npz", estimatedPSF=final_psf_new, deblurredImage=new_final)

    plt.figure()
    plt.imshow(new_final)
    plt.show()

    plt.figure()
    plt.imshow(final_psf_new)
    plt.show()

    plt.figure()
    plt.imshow(new_final)
    plt.savefig("deblurredImage2.tiff")
