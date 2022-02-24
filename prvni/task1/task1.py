import cv2
import numpy as np
import scipy.io as sio
from matplotlib import pyplot as plt
from scipy import signal, fft
from skimage.restoration import denoise_tv_chambolle, denoise_wavelet
from scipy.ndimage import gaussian_filter

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

    plt.figure()
    plt.imshow(img[:, :, ::-1])
    plt.show()

    plt.figure()
    plt.imshow(psf)
    plt.show()

    # img = cv2.bilateralFilter(img, 10, 90, 90)
    # img = denoise_tv_chambolle(img, weight=0.1)
    img = gaussian_filter(img, 5)

    img_f_r = np.fft.fft2(img[:, :, 0], s=(img.shape[0], img.shape[1]))
    img_f_g = np.fft.fft2(img[:, :, 1], s=(img.shape[0], img.shape[1]))
    img_f_b = np.fft.fft2(img[:, :, 2], s=(img.shape[0], img.shape[1]))

    psf_f = np.fft.fft2(psf, s=(img.shape[0], img.shape[1]))

    ro = 0.0000000000000001

    psf_f_abs = abs(psf_f)
    psf_f_angle = np.angle(psf_f)
    psf_f_abs[psf_f_abs == 0] = ro

    psf_f = psf_f_abs * np.exp(1j * psf_f_angle)

    psf_inv_f = np.where(abs(1 / psf_f) > ro, 1 / psf_f, ro * np.exp(np.angle(1 / psf_f)))

    psf_inv_f[psf_f_abs == 0] = ro

    unblur_r = abs(np.fft.ifft2(img_f_r * psf_inv_f))
    unblur_g = abs(np.fft.ifft2(img_f_g * psf_inv_f))
    unblur_b = abs(np.fft.ifft2(img_f_b * psf_inv_f))

    unblur = np.dstack((unblur_r, unblur_g, unblur_b)).astype("uint8")

    plt.figure()
    plt.imshow(unblur)
    plt.show()

    crop_unblur = unblur * np.dstack((mask, mask, mask))

    final = img
    new_final = np.where(np.dstack((mask, mask, mask)) == 1, crop_unblur, final)

    plt.figure(figsize=(16, 9), dpi=100)
    ax1 = plt.subplot(1, 2, 1)
    ax1.imshow(img[:, :, ::-1])
    ax1.set_title(f"Original")
    ax1.axis('off')

    ax2 = plt.subplot(1, 2, 2)
    ax2.imshow(new_final[:, :, ::-1])
    ax2.set_title(f"Unblurred")
    ax2.axis('off')

    plt.show()

    plt.figure()
    plt.imshow(new_final)
    plt.savefig("deblurredImage.tiff")

    np.savez("results.npz", estimatedPSF=psf, deblurredImage=new_final)
