%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: SESF_2DGauss 
% (1) SE - Single Emitter localization 
% (2) SF - from a Single Frame;
% (3) 2D - emitter locations
% (4) Gaussian - PSF
% (5) 3 data frames are generated with 'high', 'medium', and 'low' SNR
% (6) b  - mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
%     G  - variance of Gaussian noise (photons/s/nm^2) 
%     mu - mean of Gaussian noise (photons/s/nm^2)
%
% References
% [1] Y. Sun, "Localization precision of stochastic optical localization 
% nanoscopy using single frames," J. Biomed. Optics, vol. 18, no. 11, pp. 
% 111418-14, Oct. 2013.
% [2] Y. Sun, "Root mean square minimum distance as a quality metric for
% stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, 
% no. 1, pp. 17211, Nov. 2018.
% 
% Yi Sun
% Electrical Engineering Department
% The City College of City University of New York
% E-mail: ysun@ccny.cuny.edu
% 11/14/2019, 02/18/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%% SNR range: choose one of three
 SNRr='highSNR' ;
% SNRr='mediumSNR' ;
% SNRr='lowSNR' ;
fprintf(1,'%s: \n',SNRr) ; 
%% Intialization 
rng('default') ; 
key=0 ;             % key for random number generators
switch SNRr
  case 'highSNR'    % r=1/(1/rp+1/rg), 10*log10(r)=54.77 (dB)
    b=0.5 ;         % rp=Ih/b, 10*log10(rp)=57.78 (dB)
    G=0.5 ;         % rg=Ih/G, 10*log10(rg)=57.78 (dB)
    key=key+0 ;  
  case 'mediumSNR'  % r=1/(1/rp+1/rg), 10*log10(r)=40.79 (dB)
    b=15 ;          % rp=Ih/b, 10*log10(rp)=43.01 (dB)
    G=10 ;          % rg=Ih/G, 10*log10(rg)=44.77 (dB)
    key=key+1 ; 
  case 'lowSNR'     % r=1/(1/rp+1/rg), 10*log10(r)=37.78 (dB)
    b=30 ;          % rp=Ih/b, 10*log10(rp)=40.00 (dB)
    G=20 ;          % rg=Ih/G, 10*log10(rg)=41.76 (dB)
    key=key+2 ; 
  otherwise
    return ;
end
rng(key) ; 
%% Optical system 
na=1.4 ; 
lambda=520 ;          % nm
a=2*pi*na/lambda ; 
% 2D Gaussian PSF; sigma is estimated from Airy PSF
sigma=1.3238/a ;      % = 78.26 nm
%% Frame 
% Region of view: [0,Lx]x[0,Ly]
Lx=25e3 ; Ly=25e3 ;   % frame size in nm
Dx=100 ; Dy=100 ;     % pixel size of cammera
Kx=Lx/Dx ; Ky=Ly/Dy ; % frame size in pixels
%% Emitter intensity and signal to noise ratio
Dt=0.01 ;             % second, time per frame (1/Dt is frame rate) 
Ih=300000 ;           % average number of detected photons per emitter per second
DtIh=Dt*Ih ;          % photon count per frame per emitter 
rp=Ih/b ;             % SPNR (nm^2/emitter) 
SPNR=10*log10(rp) ;   % SPNR (dB)
rg=Ih/G ;             % SGNR (nm^2/emitter) 
SGNR=10*log10(rg) ;   % SGNR (dB)
r=rp*rg/(rp+rg) ;     % total SNR (nm^2/emitter) 
SNR=10*log10(r) ;     % total SNR (dB)
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
filename_xy0=strcat('SESF_2DGauss_',SNRr,'_xy0','.txt') ; 
save(filename_xy0,'-ascii','xy0') ;
%% Generate and save a data frame
fprintf(1,'Generate a data frame: \n') ; 
U=Frame_2DGauss(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,G,mu,xy) ; 
U16=uint16(U) ; 
filename_Frame=strcat('SESF_2DGauss_',SNRr,'_Frame','.tif') ; 
figure
imwrite(U16,filename_Frame) ; % save data frame 
imshow(U,[]) ;        % show data frame 
%% Read a data frame
U16_=imread(filename_Frame); % read data frame 
figure
imshow(U16_,[]) ; 
U=double(U16_) ; 
%% Save a 8-bit PNG image for show
Umax=max(max(U)) ; Umin=min(min(U)) ; 
U8=uint8(255*(U-Umin)/(Umax-Umin)) ;
filename_Frame=strcat('SESF_2DGauss_',SNRr,'_Frame','.png') ; 
imwrite(U8,filename_Frame) ; % save data frame 
%% Localization by the UGIA-F estimator 
fprintf(1,'UGIA-F localization: \n') ; 
[xyF,F,F_]=UGIA_F_2DGauss(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) ;
%% load emitter locations
xy1=load(filename_xy0,'-ascii') ;
xy_=xy1' ; 
%% Calculate RMSMD
[RMSMD1,RMSMD2]=RMSMD(xy_,xyF) ;
fprintf(1,SNRr) ; 
fprintf(1,': SNR=%5.2f (dB) M=%d RMSMD=%6.3f (nm) \n',SNR,M,RMSMD1) ; 

%% Results: UGIA-F estimator
% highSNR:   SNR=54.77 (dB) M=961 RMSMD= 3.05 (nm)
% mediumSNR: SNR=40.79 (dB) M=961 RMSMD= 8.86 (nm)
% lowSNR:    SNR=37.78 (dB) M=961 RMSMD=12.41 (nm) 
% Average: mean([3.05 8.86 12.41])=8.10 (nm)
