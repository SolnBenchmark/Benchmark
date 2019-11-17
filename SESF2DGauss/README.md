# SESF2DGauss: Single Emitter Single Frame 2D Gaussian PSF

## Purpose
Benchmark performance of localization algorithms in estimation of single isolated emitters from a single data frame. 

## Method
Three data frames with a high, medium, and low SNR are synthesized with the file names: **SESF2DGauss_highSNR_Frame.tif**, **SESF2DGauss_mediumSNR_Frame.tif**, **SESF2DGauss_lowSNR_Frame.tif** with 16 bits in depth. 

For each of them, the emitter locations (x,y) shall be estimated and save them row by row in a .txt file: e.g.

4.4184628e+02   5.0638849e+03

4.2119986e+02   5.8867272e+03

... ...

4.1254239e+02   6.8510823e+03

The file names in submission shall be in the format: **SESF2DGauss_highSNR_xy_algorithmName.txt**, 
**SESF2DGauss_mediumSNR_xy_algorithmName.txt**, **SESF2DGauss_lowSNR_xy_algorithmName.txt**

## Parameters
### Data frame
Pixel size: dx=100, dy=100 (nm); Frame size: Kx=200, Ky=200 pixels

### Emitter distribution 
2D specimen is located at [0,Lx]x[0,Ly]; Specimen size: Lx=25000, Ly=25000 (nm); Number of emitters: M=961; Each emitter is randomly distributed in a square of sizes 782.56x782.56 (nm^2) so that their PSFs are well isolated. 

### Emitter intensity and signal to noise ratio (SNR)
Emitter intensity (mean number of emitted photons): I=300000 (photons/s). Noise in three data frames are different.  

**SESF2DGauss_highSNR_Frame.tif**: Mean of Poisson noise: b=0.5 (photons/s/nm^2); Variance of Gaussian noise: G=0.5 (photons/s/nm^2); 
Mean of Gaussian noise: mu=0.5 (photons/s/nm^2). With these parameters, rp=? (nm^2/emitter); SPNR=57.78 (dB); rg=? (nm^2/emitter); SGNR=57.78 (dB); r=? (nm^2/emitter); SNR=54.77 (dB). 

**SESF2DGauss_mediumSNR_Frame.tif**: Mean of Poisson (autofluorescence) noise: b=15 (photons/s/nm^2); Variance of Gaussian noise: G=10 (photons/s/nm^2); Mean of Gaussian noise: mu=0.5 (photons/s/nm^2); With these parameters, rp=? (nm^2/emitter); SPNR=43.01 (dB); rg=? (nm^2/emitter); SGNR=44.77 (dB); r=? (nm^2/emitter); SNR=40.79 (dB). 

**SESF2DGauss_lowSNR_Frame.tif**: Mean of Poisson (autofluorescence) noise: b=30 (photons/s/nm^2); Variance of Gaussian noise: G=20 (photons/s/nm^2); Mean of Gaussian noise: mu=0.5 (photons/s/nm^2). With these parameters, rp=? (nm^2/emitter); SPNR=43.01 (dB); rg=? (nm^2/emitter); SGNR=44.77 (dB); r=? (nm^2/emitter); SNR=40.79 (dB).

### Optical system
na=1.4; lambda=520 (nm); a=2*pi*na/lambda; PSF: 2D Gaussian PSF; sigma is estimated from Airy PSF
Standard deviation: sigma=1.3238/a=78.26 (nm) 

### Frame 
Pixel size: Dx=100, Dy=100 (nm); Frame size: Kx=Lx/Dx=250, Ky=Ly/Dy=250 (pixels); Frame time: Dt=0.01 (s), or frame rate: 1/Dt=100 (frames/s); Photon count per frame per emitter: DtxI=3000;          

### Notes 
Poisson noise is caused by autofluorescence. PSF - point spread function. 

Signal to Poission noise ratio (SPNR): rp=I/b (nm^2/emitter); SPNR=10log10(rp) (dB) 

Signal to Gaussian noise ratio (SGNR): rg=I/G (nm^2/emitter); SGNR=10log10(rg) (dB) 

Total signal to noise ratio (SNR): r=1/(1/rp+1/rg) (nm^2/emitter); SNR=10log10(r) (dB) 
