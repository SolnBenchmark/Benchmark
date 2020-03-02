%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: Gauss2D_MESF 
% (1) Gaussian - PSF
% (2) 2D - emitter locations with random uniform distribution 
% (3) ME - Multiple Emitter localization 
% (4) SF - from a Single Frame;
% (5) 3 data frames are synthesized with 'low', 'medium', and 'high'
% density of emitters and medium SNR
% (6) b  - mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
%     mu - mean of Gaussian noise (photons/s/nm^2)
%     G  - variance of Gaussian noise (photons/s/nm^2) 
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
% 11/24/2019, 02/19/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%% Range emitter density: choose one of them
 eDen=1 ;            % emitter density (emitters/um^2)
% eDen=2 ;          % emitter density (emitters/um^2)
% eDen=6 ;          % emitter density (emitters/um^2)
% eDen=10 ;         % emitter density (emitters/um^2)
% eDen=15 ;         % emitter density (emitters/um^2)
fprintf(1,'Density=%2d (emitters/um^2): \n',eDen) ; 
%% Intialization 
rng('default') ; 
key=0 ;             % key for random number generators
switch eDen
  case 1
    key=key+0 ;  
  case 2
    key=key+1 ;  
  case 6
    key=key+3 ;  
  case 10
    key=key+4 ;  
  case 15
    key=key+5 ;  
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
M=1000 ;              % number of emitters 
% Region of view: [0,Lx]x[0,Ly]
Lx=1e3*round(sqrt(M/eDen)) ;
Ly=Lx ;               % frame size in nm
Dx=100 ; Dy=100 ;     % pixel size of cammera
Kx=Lx/Dx ; Ky=Ly/Dy ; % frame size in pixels
%% Emitter intensity and signal to noise ratio
Dt=0.01 ;             % second, time per frame (1/Dt is frame rate) 
Ih=300000 ;           % average number of detected photons per emitter per second
DtIh=Dt*Ih ;          % photon count per frame per emitter 
% 'mediumSNR'         % r=1/(1/rp+1/rg), 10*log10(r)=40.79 (dB)
b=15 ;                % rp=Ih/b, 10*log10(rp)=43.01 (dB)
G=10 ;                % rg=Ih/G, 10*log10(rg)=44.77 (dB)
rp=Ih/b ;             % SPNR (nm^2/emitter) 
SPNR=10*log10(rp) ;   % SPNR (dB)
rg=Ih/G ;             % SGNR (nm^2/emitter) 
SGNR=10*log10(rg) ;   % SGNR (dB)
r=rp*rg/(rp+rg) ;     % total SNR (nm^2/emitter) 
SNR=10*log10(r) ;     % total SNR (dB)
mu=0.5 ;              % mean of Gaussian noise (photons/s/nm^2)
%% Emitter locations - ground truth
xy=[Lx*rand(1,M) ; Ly*rand(1,M)] ;  % randomly uniformly distributed 
xy0=xy' ;             % ground truth emitter locaitons 
filename_xy0=strcat('2DGauss_MESF_density',num2str(eDen),'_xy0','.txt') ; 
save(filename_xy0,'-ascii','xy0') ;
%% Generate and save a data frame
fprintf(1,'Generate a data frame: \n') ; 
U=Gauss2D_Frame(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xy) ; 
U16=uint16(U) ; 
filename_Frame=strcat('2DGauss_MESF_density',num2str(eDen),'_Frame','.tif') ; 
imwrite(U16,filename_Frame) ; % save data frame 
figure
imshow(U,[]) ;                % show data frame 
%% Read a data frame
U16_=imread(filename_Frame); % read data frame 
figure
imshow(U16_,[]) ; 
U=double(U16_) ; 
%% Save a 8-bit PNG image for show
Umax=max(max(U)) ; Umin=min(min(U)) ; 
U8=uint8(255*(U-Umin)/(Umax-Umin)) ;
filename_Frame=strcat('2DGauss_MESF_density',num2str(eDen),'_Frame','.png') ; 
imwrite(U8,filename_Frame) ; % save data frame 
%% Localization by the UGIA-F estimator 
fprintf(1,'UGIA-F estimator: \n') ;
[xyF,F,F_]=Gauss2D_UGIA_F(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) ;
%% load emitter locations
xy1=load(filename_xy0,'-ascii') ;
xy_=xy1' ; 
%% Calculate RMSMD
[RMSMD1,RMSMD2]=RMSMD(xy_,xyF) ;
fprintf(1,'Density=%2d Lx=%d Ly=%d M=%d RMSMD=%6.3f (nm) \n',eDen,Lx,Ly,M,RMSMD1) ; 

%% Results, M=1000: UGIA-F estimator
% eDen      1     2     6     10    15    Average 
% RMSMD     9.39  10.07 12.16 18.96 28.35 15.79 (nm) 
% mean([9.39  10.07 12.16 18.96 28.35])=15.79 

