# SESF2DGauss: Single Emitter Single Frame 2D Gaussian PSF

## Purpose
Benchmark performance of localization algorithms in estimation of single isolated emitters from a single data frame. 

## Method
Three data frames with a high, medium, and low SNR are synthesized and saved as tiff files with 16 bits in depth:

**SESF2DGauss_highSNR_Frame.tif**

**SESF2DGauss_mediumSNR_Frame.tif**

**SESF2DGauss_lowSNR_Frame.tif**

For each of them, the emitter locations (x,y) shall be estimated and save them row by row in a .txt file: e.g.

4.4184628e+02   5.0638849e+03

4.2119986e+02   5.8867272e+03

... ...

4.1254239e+02   6.8510823e+03

The file names in submission shall be in the format: 

**SESF2DGauss_highSNR_xy_algorithmName.txt** 

**SESF2DGauss_mediumSNR_xy_algorithmName.txt**

**SESF2DGauss_lowSNR_xy_algorithmName.txt**.

## Parameters
### Data frame
|Parameter|variable and value| unit|
|:-----|:-----|:-----|
|Pixel size| dx=100, dy=100 |nm|
|Frame size|Kx=200, Ky=200 |pixels|

### Emitter distribution 
|Parameter|variable and value| unit|
|:-----|:-----|:-----|
|Region of view| [0,Lx]x[0,Ly] |nm| 
|Region of view size|Lx=25000, Ly=25000| nm|
|Number of emitters|M=961| |

Each emitter is randomly distributed in a square of sizes 782.56x782.56 (nm<sup>2</sup>) so that their PSFs are well isolated. 

### Emitter intensity 
|Parameter|variable and value| unit|
|:-----:|:-----:|:-----:|
|Emitter intensity (mean number of emitted photons)|I=300000|photons/s|

### Noise and signal to noise ratio in three data frames  
|Data frame|Parameter|variable and value| unit|
|:-----|:-----|:-----|:-----|
|**SESF2DGauss_highSNR_Frame.tif**|Mean of Poisson noise|b=0.5|photons/s/nm<sup>2</sup>|
| |Variance of Gaussian noise|G=0.5|photons/s/nm<sup>2</sup>| 
| |Mean of Gaussian noise|mu=0.5|photons/s/nm<sup>2</sup>|
|Corresponding SNRs|Signal to Poisson noise ratio|rp=600000|nm<sup>2</sup>/emitter|
| |                             |SPNR=57.78|dB|
| |Signal to Gaussian noise ratio|rg=600000|nm<sup>2</sup>/emitter|
| |                             |SGNR=57.78|dB|
| |Total signal to noise ratio|r=300000|nm<sup>2</sup>/emitter|
| |                           |SNR=54.77|dB|
|**SESF2DGauss_mediumSNR_Frame.tif**|Mean of Poisson noise|b=15|photons/s/nm<sup>2</sup>|
| |Variance of Gaussian noise|G=10|photons/s/nm<sup>2</sup>| 
| |Mean of Gaussian noise|mu=0.5|photons/s/nm<sup>2</sup>|
|Corresponding SNRs|Signal to Poisson noise ratio|rp=20000|nm<sup>2</sup>/emitter|
| |                             |SPNR=43.01|dB|
| |Signal to Gaussian noise ratio|rg=30000|nm<sup>2</sup>/emitter|
| |                             |SGNR=44.77|dB|
| |Total signal to noise ratio|r=12000|nm<sup>2</sup>/emitter|
| |                           |SNR=40.79|dB|
|**SESF2DGauss_lowSNR_Frame.tif**|Mean of Poisson noise|b=30|photons/s/nm<sup>2</sup>|
| |Variance of Gaussian noise|G=20|photons/s/nm<sup>2</sup>| 
| |Mean of Gaussian noise|mu=0.5|photons/s/nm<sup>2</sup>|
|Corresponding SNRs|Signal to Poisson noise ratio|rp=10000|nm<sup>2</sup>/emitter|
| |                             |SPNR=40.00|dB|
| |Signal to Gaussian noise ratio|rg=15000|nm<sup>2</sup>/emitter|
| |                             |SGNR=41.76|dB|
| |Total signal to noise ratio|r=6000|nm<sup>2</sup>/emitter|
| |                           |SNR=37.78|dB|

### Optical system
|Parameter|variable and value| unit|
|:-----|:-----|:-----|
|numerical aperture|na=1.4| |
|Fluorescence wavelength|lambda=520|nm|
|Standard deviation|78.26|nm|

PSF is 2D Gaussian PSF and its standard deviation is estimated from an Airy PSF by sigma=1.3238/a where a=2*pi*na/lambda. 

### Frame 
|Parameter|variable and value| unit|
|:-----|:-----|:-----|
|Pixel size|Dx=100, Dy=100|nm|
|Frame size|Kx=Lx/Dx=250, Ky=Ly/Dy=250|pixels|
|Frame time|Dt=0.01|s|
|Correspondingly | |
|Frame rate|1/Dt=100|frames/s|
|Photon count|DtxI=3000|photons/frame/emitter|

### Definitions
|Parameter|Definition| unit|
|:-----|:-----|:-----|
|Signal to Poission noise ratio|rp=I/b|nm<sup>2</sup>/emitter|
| |SPNR=10log10(rp)|dB|
|Signal to Gaussian noise ratio|rg=I/G|nm<sup>2</sup>/emitter|
| |SGNR=10log10(rg)|dB|
|Total signal to noise ratio|r=rp\*rg/(rp+rg)|nm<sup>2</sup>/emitter|
| |SNR=10log10(r)|dB|
