# 3DAS_MESF: 3D AS PSF Multiple Emitter Single Frame

## Purpose 
Evaluate and benchmark performance of localization algorithms in localization of multiple emitters with overlapped PSFs from a single data frame with a 3D astigmatic PSF. 

## Method
### Six data frames 

Six data frames with different emitter densities are synthesized and saved as tiff files with 16 bits in depth:

**3DAS_MESF_density0.1_Frame.tif  (For purpose of demonstration, .png images are shown here.)**

![Alt text](Doc/3DAS_MESF_density0.1_Frame.png)

**3DAS_MESF_density0.3_Frame.tif**

![Alt text](Doc/3DAS_MESF_density0.3_Frame.png)


**3DAS_MESF_density0.5_Frame.tif**

![Alt text](Doc/3DAS_MESF_density0.5_Frame.png)

**3DAS_MESF_density1_Frame.tif**

![Alt text](Doc/3DAS_MESF_density1_Frame.png)

**3DAS_MESF_density2_Frame.tif**

![Alt text](Doc/3DAS_MESF_density2_Frame.png)

**3DAS_MESF_density3_Frame.tif**

![Alt text](Doc/3DAS_MESF_density3_Frame.png)

### Submission 

For each data frame, the emitter locations (x,y,z) in nm shall be estimated and saved row by row in a .txt file: e.g.

4.4184628e+02   5.0638849e+03   1.1171183e+02

4.2119986e+02   5.8867272e+03   -3.2331955e+02

... ...

4.1254239e+02   6.8510823e+03   2.3415149e+02

The filenames in submission shall be in the format: 

**3DAS_MESF_density0.1_xyz_algorithmName.txt** 

**3DAS_MESF_density0.3_xyz_algorithmName.txt** 

**3DAS_MESF_density0.5_xyz_algorithmName.txt** 

**3DAS_MESF_density1_xyz_algorithmName.txt** 

**3DAS_MESF_density2_xyz_algorithmName.txt** 

**3DAS_MESF_density3_xyz_algorithmName.txt** 

## Parameters
The six data frames are synthesized by using the following parameters. 

### Emitter distribution and intensity (mean number of emitted photons)
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Number of emitters |M=500|  |
|Emitter intensity |I=300000|photons/sec/emitter|
|Analog digital unit |ADU=1|photons/unit|

Emitters are randomly and uniformly distributed in the cuboid [0,Lx] x [0,Ly] x [-Lz,Lz]. 

### Data frame 
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Region of view|[0,Lx] x [0,Ly] x [-Lz,Lz] |nm| 
|Size of axial view |Lz=400 |nm| 
|Pixel size |Dx=100, Dy=100|nm|
|Frame size |Kx=Lx/Dx, Ky=Ly/Dy|pixels|
|Frame time |Dt=0.01|sec|
|Correspondingly | |
|Frame rate|1/Dt=100|frames/sec|
|Photon count |Dt\*I=3000|photons/frame/emitter|

### Region of view and frame size for six data frames 
|Data frame |Parameter |Variable and value| Unit|
|:-----|:-----|:-----|:-----|
|**3DAS_MESF_density0.1_Frame.tif** |Region of view size |Lx=70700, Ly=70700|nm|
|Correspondingly |Emitter density in lateral plane|0.1|emitters/um<sup>2</sup>|
|                |Frame size |Kx=707, Ky=707|pixels|
|**3DAS_MESF_density0.3_Frame.tif** |Region of view size |Lx=40800, Ly=40800|nm|
|Correspondingly |Emitter density in lateral plane|0.3|emitters/um<sup>2</sup>|
|                |Frame size |Kx=408, Ky=408|pixels|
|**3DAS_MESF_density0.5_Frame.tif** |Region of view size |Lx=31600, Ly=31600|nm|
|Correspondingly |Emitter density in lateral plane|0.5|emitters/um<sup>2</sup>|
|                |Frame size |Kx=316, Ky=316|pixels|
|**3DAS_MESF_density1_Frame.tif** |Region of view size |Lx=22400, Ly=22400|nm|
|Correspondingly |Emitter density in lateral plane|1|emitters/um<sup>2</sup>|
|                |Frame size |Kx=224, Ky=224|pixels|
|**3DAS_MESF_density2_Frame.tif** |Region of view size |Lx=15800, Ly=15800|nm|
|Correspondingly |Emitter density in lateral plane|2|emitters/um<sup>2</sup>|
|                |Frame size |Kx=158, Ky=158|pixels|
|**3DAS_MESF_density3_Frame.tif** |Region of view size |Lx=12900, Ly=12900|nm|
|Correspondingly |Emitter density in lateral plane|3|emitters/um<sup>2</sup>|
|                |Frame size |Kx=129, Ky=129|pixels|

The corresponding 2D coordinate in a data frame is shown below. Note y axis points down. 

![Alt text](https://github.com/SolnBenchmark/Benchmark/blob/master/2DGauss_SESF/Doc/FrameCoordinates.png)

### Noise 
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Mean of Poisson noise |b=0.3|photons/sec/nm<sup>2</sup>|
|Variance of Gaussian noise |G=0.2|photons/sec/nm<sup>2</sup>| 
|Mean of Gaussian noise |mu=5|photons/sec/nm<sup>2</sup>|

**Corresponding signal to noise ratios and camera offset**

|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|Signal to Poisson noise ratio |rp=1000000|nm<sup>2</sup>/emitter|
|                             |SPNR=60.00|dB|
|Signal to Gaussian noise ratio |rg=1500000|nm<sup>2</sup>/emitter|
|                             |SGNR=61.76|dB|
|Total signal to noise ratio |r=600000|nm<sup>2</sup>/emitter|
|                           |SNR=57.78|dB|
|Effective camera offset |Coff=500 |photons/pixel|

The mean of Gaussian noise mu includes the effect of camera offset. When mu is solely contributed by the camera offset, i.e. the Gaussian noise has a zero mean, the effective camera offset is Coff=Dt\*Dx\*Dy\*mu. 

### Optical system
|Parameter |Variable and value| Unit|
|:-----|:-----|:-----|
|       |c=205, d=290|nm |
|       |sigmax0=140|nm |
|       |Ax=0.05, Bx=0.03| |
|       |sigmay0=135|nm |
|       |Ay=-0.01, By=0.02| |

PSF is 3D astigmatic [1]. The corresponding standard deviations in x and y as functions of z are shown below. 

![Alt text](Doc/sigmaxy.png)

### Definitions
|Parameter |Definition| Unit|
|:-----|:-----|:-----|
|Signal to Poisson noise ratio |rp=I/b|nm<sup>2</sup>/emitter|
| |SPNR=10log10(rp)|dB|
|Signal to Gaussian noise ratio |rg=I/G|nm<sup>2</sup>/emitter|
| |SGNR=10log10(rg)|dB|
|Total signal to noise ratio |r=rp\*rg/(rp+rg)|nm<sup>2</sup>/emitter|
| |SNR=10log10(r)|dB|
