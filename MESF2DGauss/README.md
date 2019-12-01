# MESF2DGauss: Multiple Emitter Single Frame 2D Gaussian PSF

## Purpose
Evaluate and benchmark performance of localization algorithms in localization of multiple emitters with overlapped PSFs from a single data frame. 

## Method
### Six data frames 

Emitters are randomly and uniformly distributed in a region of view. Six data frames with different emitter densities are synthesized and saved as tiff files with 16 bits in depth:

**MESF2DGauss_density1_Frame.tif**

![Alt text](MESF2DGauss_density1_Frame.png)

**MESF2DGauss_density2_Frame.tif**

![Alt text](MESF2DGauss_density2_Frame.png)

**MESF2DGauss_density6_Frame.tif**

![Alt text](MESF2DGauss_density6_Frame.png)

**MESF2DGauss_density10_Frame.tif**

![Alt text](MESF2DGauss_density10_Frame.png)

**MESF2DGauss_density15_Frame.tif**

![Alt text](MESF2DGauss_density15_Frame.png)

### Submission 

For each data frame, the emitter locations (x,y) shall be estimated and saved  row by row in a .txt file: e.g.

4.4184628e+02   5.0638849e+03

4.2119986e+02   5.8867272e+03

... ...

4.1254239e+02   6.8510823e+03

The file names in submission shall be in the format: 

**MESF2DGauss_density1_xy_algorithmName.txt** 

**MESF2DGauss_density2_xy_algorithmName.txt** 

**MESF2DGauss_density6_xy_algorithmName.txt** 

**MESF2DGauss_density10_xy_algorithmName.txt** 

**MESF2DGauss_density15_xy_algorithmName.txt** 

## Parameters
The three data frames are synthesized by using the following parameters. 

### Data frame 
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Region of view|[0,Lx] x [0,Ly] |nm| 
|Pixel size |Dx=100, Dy=100|nm|
|Frame size |Kx=Lx/Dx=250, Ky=Ly/Dy=250|pixels|
|Frame time |Dt=0.01|s|
|Correspondingly | |
|Frame rate|1/Dt=100|frames/s|
|Photon count |Dt\*I=3000|photons/frame/emitter|

### Region of view size for five data frames 
|Data frame |Parameter |Variable and value| Unit|
|:-----|:-----|:-----|:-----|
|**MESF2DGauss_density1_Frame.tif.tif** |Region of view size |Lx=32000, Ly=32000|nm|
|Correspondingly |Emitter density |1|emitters/um<sup>2</sup>|
|**MESF2DGauss_density2_Frame.tif.tif** |Region of view size |Lx=22000, Ly=22000|nm|
|Correspondingly |Emitter density |2|emitters/um<sup>2</sup>|
|**MESF2DGauss_density6_Frame.tif.tif** |Region of view size |Lx=13000, Ly=13000|nm|
|Correspondingly |Emitter density |6|emitters/um<sup>2</sup>|
|**MESF2DGauss_density10_Frame.tif.tif**|Region of view size |Lx=10000, Ly=10000|nm|
|Correspondingly |Emitter density |10|emitters/um<sup>2</sup>|
|**MESF2DGauss_density15_Frame.tif.tif**|Region of view size |Lx=8000, Ly=8000|nm|
|Correspondingly |Emitter density |15|emitters/um<sup>2</sup>|

The corresponding 2D coordinate in a data frame is shown below. Note y axis points down. 

![Alt text](https://github.com/SolnBenchmark/Benchmark/blob/master/SESF2DGauss/FrameCoordinates.png)

### Emitter distribution and intensity (mean number of emitted photons)
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Number of emitters |M=1000| |
|Emitter intensity |I=300000|photons/s/emitter|

Within the region of view, each emitter is randomly distributed in a square of sizes 783x783 (nm<sup>2</sup>) so that their PSFs are well isolated. 

### Noise 
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Mean of Poisson noise |b=15|photons/s/nm<sup>2</sup>|
|Variance of Gaussian noise |G=10|photons/s/nm<sup>2</sup>| 
|Mean of Gaussian noise |mu=0.5|photons/s/nm<sup>2</sup>|

### Corresponding signal to noise ratios 
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Signal to Poisson noise ratio |rp=20000|nm<sup>2</sup>/emitter|
|                             |SPNR=43.01|dB|
|Signal to Gaussian noise ratio |rg=30000|nm<sup>2</sup>/emitter|
|                             |SGNR=44.77|dB|
|Total signal to noise ratio |r=12000|nm<sup>2</sup>/emitter|
|                           |SNR=40.79|dB|

### Optical system
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Numerical aperture |na=1.4| |
|Fluorescence wavelength |lambda=520|nm|
|Standard deviation|78.26|nm|

PSF is 2D Gaussian PSF and its standard deviation is estimated from an Airy PSF by sigma=1.3238/a where a=2\*pi\*na/lambda. 

### Definitions
|Parameter |Definition| Unit|
|:-----|:-----|:-----|
|Signal to Poisson noise ratio |rp=I/b|nm<sup>2</sup>/emitter|
| |SPNR=10log10(rp)|dB|
|Signal to Gaussian noise ratio |rg=I/G|nm<sup>2</sup>/emitter|
| |SGNR=10log10(rg)|dB|
|Total signal to noise ratio |r=rp\*rg/(rp+rg)|nm<sup>2</sup>/emitter|
| |SNR=10log10(r)|dB|
