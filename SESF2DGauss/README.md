# SESF2DGauss: Single Emitter Single Frame 2D Gaussian PSF

# Purpose
Benchmark performance of localization algorithms in estimation of single isolated emitters from a single data frame. 

# Method
Three data frames with a high, medium, and low SNR are synthesized with the file names: 

**SESF2DGauss_highSNR_Frame.tif**

**SESF2DGauss_mediumSNR_Frame.tif**

**SESF2DGauss_lowSNR_Frame.tif**

The emitter locations (x,y) shall be estimated from each of them. 

For each data frame, save the 2D emitter locations row by row in a .txt file: e.g.

4.4184628e+02   5.0638849e+03

4.2119986e+02   5.8867272e+03

... ...

4.1254239e+02   6.8510823e+03

The file names in submission shall be in the form: 

**SESF2DGauss_highSNR_xy_algorithmName.txt**

**SESF2DGauss_mediumSNR_xy_algorithmName.txt**

**SESF2DGauss_lowSNR_xy_algorithmName.txt**

# Parameters
### Optical system 

### Data frame

Pixel size: dx=100, dy=100 (nm)

Frame size: Kx=200, Ky=200 pixels


### Emitter distribution 
Number of emitters: M=961

2D sample size: Lx=25000, Ly=25000 (nm)

Each emitter is randomly distributed in a square of size 782.56x782.56 (nm^2)

### Emitter intensity and signal to noise ratio (SNR)
Emitter intensity (mean number of emitted photons): I=300000 (photons/s)

Three data frames generated with a high, medium, and low level of noise:  

**SESF2DGauss_highSNR_Frame.tif** 

Mean of Poisson (autofluorescence) noise: b=0.5 (photons/s/nm^2); 

Variance of Gaussian noise: G=0.5 (photons/s/nm^2) 

Mean of Gaussian noise: mu=0.5 (photons/s/nm^2) 

With these parameters, 

rp=? (nm^2/emitter); SPNR=57.78 (dB); rg=? (nm^2/emitter); SGNR=57.78 (dB); r=? (nm^2/emitter); SNR=54.77 (dB)

**SESF2DGauss_mediumSNR_Frame.tif** 

Mean of Poisson (autofluorescence) noise: b=15 (photons/s/nm^2); 

Variance of Gaussian noise: G=10 (photons/s/nm^2) 

Mean of Gaussian noise: mu=0.5 (photons/s/nm^2) 

With these parameters, 

rp=? (nm^2/emitter); SPNR=43.01 (dB); rg=? (nm^2/emitter); SGNR=44.77 (dB); r=? (nm^2/emitter); SNR=40.79 (dB)

**SESF2DGauss_lowSNR_Frame.tif** 

Mean of Poisson (autofluorescence) noise: b=30 (photons/s/nm^2); 

Variance of Gaussian noise: G=20 (photons/s/nm^2) 

Mean of Gaussian noise: mu=0.5 (photons/s/nm^2) 

With these parameters, 

rp=? (nm^2/emitter); SPNR=43.01 (dB); rg=? (nm^2/emitter); SGNR=44.77 (dB); r=? (nm^2/emitter); SNR=40.79 (dB)



case 'lowSNR'     % r=1/(1/rp+1/rg), 10*log10(r)=37.78 (dB)
    rng(key+2) ;
    b=30 ;          % rp=Ih/b, 10*log10(rp)=40.00 (dB)
    G=20 ;          % rg=Ih/G, 10*log10(rg)=41.76 (dB)
  otherwise
    return ;
end



### Optical system
na=1.4 ; lambda=520 (nm) ; a=2*pi*na/lambda ; 
Point spread function (PSF): 2D Gaussian PSF; sigma is estimated from Airy PSF
Standard deviation: sigma=1.3238/a=78.26 (nm)


% rng(0) ;            % reiniitalize 
%% Frame 
% Specimen is located at [0,Lx]x[0,Ly]
Lx=25e3 ; Ly=25e3 ;   % frame size in nm
Dx=100 ; Dy=100 ;     % pixel size of cammera
Kx=Lx/Dx ; Ky=Ly/Dy ; % frame size in pixels
%% Emitter intensity and signal to noise ratio
Dt=0.01 ;             % second, time per frame (1/Dt is frame rate) 

DtIh=Dt*Ih ;          % photon count per frame per emitter 
rp=Ih/b ;             % SPNR (nm^2/emitter) 
rg=Ih/G ;             % SGNR (nm^2/emitter) 
gamma=rp*rg/(rp+rg) ; % total SNR (nm^2/emitter) 
SNR=10*log10(gamma) ; % total SNR (dB)
mu=0.5 ;              % mean of Gaussian noise (photons/s/nm^2)
%% Emitter locations - ground truth
eLx=2*5*sigma ;       % an emitter is located in a region of size eLx, eLy
eLy=2*5*sigma ;       % with probability of 99% 
Mx=floor(Lx/eLx) ;    % number of emitters in x direction
My=floor(Ly/eLy) ;    % number of emitters in y direction
M=Mx*My ;             % number of emitters
xy=zeros(2,M) ;       % 2D emitter locations 
for ix=1:Mx
  for iy=1:My
    xy(:,My*(ix-1)+iy)=[eLx*(ix-1+0.5)+sigma*rand ; eLy*(iy-1+0.5)+sigma*randn] ; 
  end
end
xy0=xy' ;             % ground truth emitter locaitons 
filename_xy0=strcat('SESF2DGauss_',SNRr,'_xy0','.txt') ; 
save(filename_xy0,'-ascii','xy0') ;

### Definitions 
Signal to Poission noise ratio (SPNR): rp=I/b (nm^2/emitter); SPNR=10log10(rp) (dB) 

Signal to Gaussian noise ratio (SGNR): rg=I/G (nm^2/emitter); SGNR=10log10(rg) (dB) 

Total SNR: r=1/(1/rp+1/rg) (nm^2/emitter); SNR=10log10(r) (dB) 
