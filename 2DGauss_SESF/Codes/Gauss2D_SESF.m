%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: Gauss2D_SESF 
% (1) Gaussian - PSF
% (2) 2D - emitter locations
% (3) SE - Single Emitter localization 
% (4) SF - from a Single Frame;
% (5) 3 data frames are generated with 'high', 'medium', and 'low' SNR
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
% [3] Y. Sun, "Information sufficient segmentation and signal-to-noise 
% ratio in stochastic optical localization nanoscopy," Optics Letters, 
% vol. 45, no. 21, pp. 6102-6105, Nov. 1, 2020. 
% 
% Yi Sun
% Electrical Engineering Department
% The City College of City University of New York
% E-mail: ysun@ccny.cuny.edu
% 11/14/2019, 02/18/2020, 04/01/2020, 12/17/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%% SNR range: choose one of three
 SNRr='highSNR' ;
% SNRr='mediumSNR' ;
% SNRr='lowSNR' ;
fprintf(1,'%s: \n',SNRr) ; 
%% Intialization 
rng('default') ; 
key=0 ;        % key for random number generators
switch SNRr
  case 'highSNR'    % r=500000,   SNR =5.24 (dB)
    b=0.3 ;         % rp=1000000, SPNR=8.25 (dB)
    G=0.3 ;         % rg=1000000, SGNR=8.25 (dB)
    key=key+0 ;  
  case 'mediumSNR'  % r=37500,    SNR =-6.01 (dB)
    b=5 ;           % rp=60000,   SPNR=-3.97 (dB)
    G=3 ;           % rg=100000,  SGNR=-1.75 (dB)
    key=key+1 ; 
  case 'lowSNR'     % r=9375,     SNR=-12.03 (dB)
    b=20 ;          % rp=15000,   SPNR=-9.99 (dB)
    G=12 ;          % rg=25000,   SGNR=-7.77 (dB)
    key=key+2 ; 
  otherwise
    return ;
end
rng(key) ; 
%% Optical system 
na=1.40 ; 
lambda=723 ;                  % Alexa700 wavelength in nm
a=2*pi*na/lambda ;  
% 2D Gaussian PSF; sigma is estimated from Airy PSF
sigma=1.3238/a ;              % sigma=108.81; 2*sigma=217.61 (nm) 
FWHM=2*sqrt(2*log(2))*sigma ; % FWHM=256.22 (nm)
%% Frame 
% Region of view: [0,Lx]x[0,Ly]
Lx=35e3 ; Ly=35e3 ;   % frame size in nm
Dx=100 ; Dy=100 ;     % pixel size of cammera
Kx=Lx/Dx ; Ky=Ly/Dy ; % frame size in pixels
%% Emitter intensity and signal to noise ratio
Dt=0.01 ;             % second, time per frame (1/Dt is frame rate) 
Ih=300000 ;           % average number of detected photons per emitter per second
DtIh=Dt*Ih ;          % photon count per frame per emitter 
rp=Ih/b ;             % SPNR 
betas=0.07912 ;       % [3]
beta=betas/sigma^2 ; 
nup=beta*rp ; 
SPNR=10*log10(nup) ;  % (dB)
rg=Ih/G ;             % SGNR
nug=beta*rg ; 
SGNR=10*log10(nug) ;  % (dB)
r=rp*rg/(rp+rg) ;     % total SNR 
nu=beta*r ; 
SNR=10*log10(nu) ;    % (dB)
mu=5 ;                % mean of Gaussian noise (photons/s/nm^2)
Coff=mu*Dt*Dx*Dy ;    % Coff=500 photons/pixel; Camera offset in effect
%% Emitter locations - ground truth
eLx=2*5*sigma ;       % an emitter is located in a region of size eLx, eLy
eLy=2*5*sigma ;       % with probability > 99% 
Mx=floor(Lx/eLx) ;    % number of emitters in x direction
My=floor(Ly/eLy) ;    % number of emitters in y direction
M=Mx*My ;             % number of emitters
xy=zeros(2,M) ;       % 2D emitter locations 
for ix=1:Mx
  for iy=1:My
    xy(:,My*(ix-1)+iy)=[eLx*(ix-1+0.5)+50*randn ; eLy*(iy-1+0.5)+50*randn] ; 
  end
end
xy0=xy' ;             % ground truth emitter locaitons 
filename_xy0=strcat('2DGauss_SESF_',SNRr,'_xy0','.txt') ; 
save(filename_xy0,'-ascii','xy0') ;
%% Generate and save a data frame
fprintf(1,'Generate a data frame: \n') ; 
U=Gauss2D_Frame(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xy) ; 
U16=uint16(U) ; 
filename_Frame=strcat('2DGauss_SESF_',SNRr,'_Frame','.tif') ; 
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
filename_Frame=strcat('2DGauss_SESF_',SNRr,'_Frame','.png') ; 
imwrite(U8,filename_Frame) ; % save data frame 
%% Localization by the UGIA-F estimator 
fprintf(1,'UGIA-F estimator: \n') ; 
[xyF,F,F_]=Gauss2D_UGIA_F(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) ;
%% load emitter locations
xy1=load(filename_xy0,'-ascii') ;
xy_=xy1' ; 
%% Calculate RMSMD
[RMSMD1,RMSMD2]=RMSMD(xy_,xyF) ;
fprintf(1,SNRr) ; 
fprintf(1,': SNR=%5.2f (dB) M=%d RMSMD=%6.3f (nm) \n',SNR,M,RMSMD1) ; 
%% Show estimates
figure('Position',[400 300 600 600],'Color',[1 1 1]) ;
plot(xy_(1,:),xy_(2,:),'k.') ; hold on
plot(xyF(1,:),xyF(2,:),'r.') ; hold off
xlabel('x (nm)') 
ylabel('y (nm)') ; 
axis([0 Lx 0 Ly])

%% Results, M=1024: UGIA-F estimator
%             highSNR mediumSNR lowSNR  Average 
% SNR (dB):   5.24    -6.01     -12.03
% RMSMD (nm): 4.11    9.27      17.11   10.16 
% Average: mean([4.11 9.27 17.11]) 
