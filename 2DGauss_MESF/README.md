# 2DGauss_MESF: 2D Gaussian PSF Multiple Emitter Single Frame

## Purpose 
Evaluate and benchmark performance of localization algorithms in localization of multiple emitters with overlapped PSFs from a single data frame. 

## Method
### Five data frames 

Five data frames with different emitter densities are synthesized and saved as tiff files with 16 bits in depth:

**2DGauss_MESF_density0.5_Frame.tif  (For purpose of demonstration, .png images are shown here.)**

![Alt text](Doc/2DGauss_MESF_density0.5_Frame.png)

**2DGauss_MESF_density1_Frame.tif  (For purpose of demonstration, .png images are shown here.)**

![Alt text](Doc/2DGauss_MESF_density1_Frame.png)

**2DGauss_MESF_density2_Frame.tif**

![Alt text](Doc/2DGauss_MESF_density2_Frame.png)

**2DGauss_MESF_density4_Frame.tif**

![Alt text](Doc/2DGauss_MESF_density4_Frame.png)

**2DGauss_MESF_density8_Frame.tif**

![Alt text](Doc/2DGauss_MESF_density8_Frame.png)

### Submission 

For each data frame, the emitter locations (x,y) in nm shall be estimated and saved row by row in a .txt file: e.g.

4.4184628e+02   5.0638849e+03

4.2119986e+02   5.8867272e+03

... ...

4.1254239e+02   6.8510823e+03

The filenames in submission shall be in the format: 

**2DGauss_MESF_density0.5_xy_algorithmName.txt** 

**2DGauss_MESF_density1_xy_algorithmName.txt** 

**2DGauss_MESF_density2_xy_algorithmName.txt** 

**2DGauss_MESF_density4_xy_algorithmName.txt** 

**2DGauss_MESF_density8_xy_algorithmName.txt** 

## Parameters
The five data frames are synthesized by using the following parameters. 

### Emitter distribution and intensity (mean number of emitted photons)
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Number of emitters |M=1000|  |
|Emitter intensity |I=300000|photons/sec/emitter|
|Analog digital unit |ADU=1|photons/unit|

Emitters are randomly and uniformly distributed in the field of view. 

### Data frame 
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Field of view |[0,Lx] x [0,Ly] |nm| 
|Pixel size |Dx=100, Dy=100|nm|
|Frame size |Kx=Lx/Dx, Ky=Ly/Dy |pixels |
|Frame time |Dt=0.01|sec|
|Correspondingly | |
|Frame rate|1/Dt=100|frames/sec|
|Photon count |Dt\*I=3000|photons/frame/emitter|

### Field of view and frame size for five data frames 
|Data frame |Parameter |Variable and value| Unit|
|:-----|:-----|:-----|:-----|
|**2DGauss_MESF_density0.5_Frame.tif** |Field of view size |Lx=44700, Ly=44700|nm|
|Correspondingly |Emitter density |0.5|emitters/um<sup>2</sup>|
|                |Frame size |Kx=447, Ky=447|pixels|
|**2DGauss_MESF_density1_Frame.tif** |Field of view size |Lx=31600, Ly=31600|nm|
|Correspondingly |Emitter density |1|emitters/um<sup>2</sup>|
|                |Frame size |Kx=316, Ky=316|pixels|
|**2DGauss_MESF_density2_Frame.tif** |Field of view size |Lx=22400, Ly=22400|nm|
|Correspondingly |Emitter density |2|emitters/um<sup>2</sup>|
|                |Frame size |Kx=224, Ky=224|pixels|
|**2DGauss_MESF_density4_Frame.tif** |Field of view size |Lx=15800, Ly=15800|nm|
|Correspondingly |Emitter density |4|emitters/um<sup>2</sup>|
|                |Frame size |Kx=158, Ky=158|pixels|
|**2DGauss_MESF_density8_Frame.tif**|Field of view size |Lx=11200, Ly=11200|nm|
|Correspondingly |Emitter density |8|emitters/um<sup>2</sup>|
|                |Frame size |Kx=112, Ky=112|pixels|

The corresponding 2D coordinate in a data frame is shown below. Note y axis points down. 

![Alt text](https://github.com/SolnBenchmark/Benchmark/blob/master/2DGauss_SESF/Doc/FrameCoordinates.png)

### Optical system
|Parameter |Variable and value|Unit | |
|:-----|:-----|:-----|:-----|
|Numerical aperture |na=1.40| | |
|Fluorescence wavelength |lambda=723|nm|Dye Alexa 700 |
|Correspondingly| | | |
|Standard deviation |sigma=108.81|nm| |
|Full-width half-maximum |FWHM=256.22|nm| |

PSF is 2D Gaussian and its standard deviation is estimated from an Airy PSF by sigma=1.3238/a where a=2\*pi\*na/lambda [1]. 

### Noise 
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Mean of Poisson noise |b=5|photons/sec/nm<sup>2</sup>|
|Variance of Gaussian noise |G=3|photons/sec/nm<sup>2</sup>| 
|Mean of Gaussian noise |mu=5|photons/sec/nm<sup>2</sup>|

**Corresponding signal to noise ratios and camera offset**

|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Signal to Poisson noise ratio |rp=60000|nm<sup>2</sup>/emitter|
|                             |SPNR=-3.97|dB|
|Signal to Gaussian noise ratio |rg=100000|nm<sup>2</sup>/emitter|
|                             |SGNR=-1.75|dB|
|Total signal to noise ratio |r=37500|nm<sup>2</sup>/emitter|
|                           |SNR=-6.01|dB|
|Effective camera offset |Coff=500 |photons/pixel|

The mean of Gaussian noise mu includes the effect of camera offset. When mu is solely contributed by the camera offset, i.e. the Gaussian noise has a zero mean, the effective camera offset is Coff=Dt\*Dx\*Dy\*mu. 

SPNR, SGNR, and SNR are defined in [4]. 
