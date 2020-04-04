# 2DAiry_SESF: 2D Airy PSF Single Emitter Single Frame 

## Purpose 
Evaluate and benchmark performance of localization algorithms in estimation of single isolated emitters from a single data frame. 

## Method
### Three data frames 

Three data frames with a high, medium, and low SNR are synthesized and saved as tiff files with 16 bits in depth:

**2DAiry_SESF_highSNR_Frame.tif (For purpose of demonstration, .png images are shown here.)**

![Alt text](Doc/2DAiry_SESF_highSNR_Frame.png)

**2DAiry_SESF_mediumSNR_Frame.tif**

![Alt text](Doc/2DAiry_SESF_mediumSNR_Frame.png)

**2DAiry_SESF_lowSNR_Frame.tif**

![Alt text](Doc/2DAiry_SESF_lowSNR_Frame.png)

### Submission 

For each data frame, the emitter locations (x,y) in nm shall be estimated and saved  row by row in a .txt file: e.g.

4.4184628e+02   5.0638849e+03

4.2119986e+02   5.8867272e+03

... ...

4.1254239e+02   6.8510823e+03

The filenames in submission shall be in the format: 

**2DAiry_SESF_highSNR_xy_algorithmName.txt** 

**2DAiry_SESF_mediumSNR_xy_algorithmName.txt**

**2DAiry_SESF_lowSNR_xy_algorithmName.txt**.

## Parameters
The three data frames are synthesized by using the following parameters. 

### Emitter distribution and intensity (mean number of emitted photons)
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Number of emitters |M=1024 |  |
|Emitter intensity |I=300000|photons/s/emitter|
|Analog digital unit |ADU=1|photons/unit|

Within the region of view, each emitter is randomly distributed in a square of sizes 980\*980 (nm<sup>2</sup>) so that their PSFs are well isolated. 

### Data frame 
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Region of view|[0,Lx] x [0,Ly] |nm| 
|Region of view size |Lx=31400, Ly=31400| nm|
|Pixel size |Dx=100, Dy=100|nm|
|Frame size |Kx=Lx/Dx=314, Ky=Ly/Dy=314|pixels|
|Frame time |Dt=0.01|s|
|Correspondingly | |
|Frame rate|1/Dt=100|frames/s|
|Photon count |Dt\*I=3000|photons/frame/emitter|

The corresponding 2D coordinate in a data frame is shown below. Note y axis points down. 

![Alt text](https://github.com/SolnBenchmark/Benchmark/blob/master/2DGauss_SESF/Doc/FrameCoordinates.png)

### Noise and signal to noise ratio in three data frames  
|Data frame |Parameter |Variable and value| Unit|
|:-----|:-----|:-----|:-----|
|**2DAiry_SESF_highSNR_Frame.tif**|Mean of Poisson noise |b=0.3|photons/s/nm<sup>2</sup>|
| |Variance of Gaussian noise |G=0.3|photons/s/nm<sup>2</sup>| 
| |Mean of Gaussian noise |mu=5|photons/s/nm<sup>2</sup>|
|Correspondingly |Signal to Poisson noise ratio |rp=1000000|nm<sup>2</sup>/emitter|
| |                             |SPNR=60.00|dB|
| |Signal to Gaussian noise ratio |rg=1000000|nm<sup>2</sup>/emitter|
| |                             |SGNR=60.00|dB|
| |Total signal to noise ratio |r=500000|nm<sup>2</sup>/emitter|
| |                           |SNR=56.99|dB|
| |Effective camera offset |Coff=500 |photons/pixel|
|**2DAiry_SESF_mediumSNR_Frame.tif**|Mean of Poisson noise |b=5|photons/s/nm<sup>2</sup>|
| |Variance of Gaussian noise |G=3|photons/s/nm<sup>2</sup>| 
| |Mean of Gaussian noise |mu=5|photons/s/nm<sup>2</sup>|
|Correspondingly |Signal to Poisson noise ratio |rp=60000|nm<sup>2</sup>/emitter|
| |                             |SPNR=47.78|dB|
| |Signal to Gaussian noise ratio |rg=100000|nm<sup>2</sup>/emitter|
| |                             |SGNR=50.00|dB|
| |Total signal to noise ratio |r=37500|nm<sup>2</sup>/emitter|
| |                           |SNR=45.74|dB|
| |Effective camera offset |Coff=500 |photons/pixel|
|**2DAiry_SESF_lowSNR_Frame.tif**|Mean of Poisson noise |b=20|photons/s/nm<sup>2</sup>|
| |Variance of Gaussian noise |G=12|photons/s/nm<sup>2</sup>| 
| |Mean of Gaussian noise |mu=5|photons/s/nm<sup>2</sup>|
|Correspondingly |Signal to Poisson noise ratio |rp=15000|nm<sup>2</sup>/emitter|
| |                             |SPNR=41.76|dB|
| |Signal to Gaussian noise ratio |rg=25000|nm<sup>2</sup>/emitter|
| |                             |SGNR=43.98|dB|
| |Total signal to noise ratio |r=9375|nm<sup>2</sup>/emitter|
| |                           |SNR=39.72|dB|
| |Effective camera offset |Coff=500 |photons/pixel|

The mean of Gaussian noise mu includes the effect of camera offset. When mu is solely contributed by the camera offset, i.e. the Gaussian noise has a zero mean, the effective camera offset is Coff=Dt\*Dx\*Dy\*mu. 

### Optical system
|Parameter |Variable and value|Unit | |
|:-----|:-----|:-----|:-----|
|Numerical aperture |na=1.43| | |
|Fluorescence wavelength |lambda=665|nm|Dye Alexa647 |
|Correspondingly| | | |
|Standard deviation |sigma=97.98 |nm| |
|Full-width half-maximum |FWHM=230.72 |nm| |

PSF is 2D Airy and its standard deviation is estimated by sigma=1.3238/a where a=2\*pi\*na/lambda [1]. 

### Definitions
|Parameter |Definition| Unit|
|:-----|:-----|:-----|
|Signal to Poisson noise ratio |rp=I/b|nm<sup>2</sup>/emitter|
| |SPNR=10log10(rp)|dB|
|Signal to Gaussian noise ratio |rg=I/G|nm<sup>2</sup>/emitter|
| |SGNR=10log10(rg)|dB|
|Total signal to noise ratio |r=rp\*rg/(rp+rg)|nm<sup>2</sup>/emitter|
| |SNR=10log10(r)|dB|
