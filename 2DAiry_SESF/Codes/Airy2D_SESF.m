%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: Airy2D_SESF 
% (1) Airy - PSF
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
% 
% Yi Sun
% Electrical Engineering Department
% The City College of City University of New York
% E-mail: ysun@ccny.cuny.edu
% 11/23/2019, 02/22/2020, 04/02/2020
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
  case 'highSNR'    % r=500000,   SNR=56.99 (dB)
    b=0.3 ;         % rp=1000000, SPNR=60.00 (dB)
    G=0.3 ;         % rg=1000000, SGNR=60.00 (dB)
    key=key+0 ;  
  case 'mediumSNR'  % r=37500,    SNR=45.74 (dB)
    b=5 ;           % rp=60000,   SPNR=47.78 (dB)
    G=3 ;           % rg=100000,  SGNR=50.00 (dB)
    key=key+1 ; 
  case 'lowSNR'     % r=9375,     SNR=39.72 (dB)
    b=20 ;          % rp=15000,   SPNR=41.76 (dB)
    G=12 ;          % rg=25000,   SGNR=43.98 (dB)
    key=key+2 ; 
  otherwise
    return ;
end
rng(key) ; 
%% Optical system 
na=1.43 ; 
lambda=665 ;                  % Alexa647 wavelength in nm
a=2*pi*na/lambda ;  
% 2D Gaussian PSF; sigma is estimated from Airy PSF
sigma=1.3238/a ;              % sigma=97.98; 2*sigma=195.96 (nm) 
FWHM=2*sqrt(2*log(2))*sigma ; % FWHM=230.72 (nm)
%% Frame 
% Region of view: [0,Lx]x[0,Ly]
Lx=31400 ; Ly=31400 ; % frame size in nm
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
mu=5 ;                % mean of Gaussian noise (photons/s/nm^2)
Coff=mu*Dt*Dx*Dy ;    % Coff=500 photons/pixel; Camera offset in effect
%% Emitter locations - ground truth
eLx=2*5*sigma ;       % an emitter is located in a region of size eLx, eLy
eLy=2*5*sigma ;       % with probability of 99% 
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
filename_xy0=strcat('2DAiry_SESF_',SNRr,'_xy0','.txt') ; 
save(filename_xy0,'-ascii','xy0') ;
%% Generate and save a data frame
fprintf(1,'Generate a data frame: \n') ; 
U=Airy2D_Frame(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xy) ;
U16=uint16(U) ; 
filename_Frame=strcat('2DAiry_SESF_',SNRr,'_Frame','.tif') ; 
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
filename_Frame=strcat('2DAiry_SESF_',SNRr,'_Frame','.png') ; 
imwrite(U8,filename_Frame) ; % save data frame 
%% Localization by the UGIA-F estimator 
fprintf(1,'UGIA-F estimator: \n') ; 
[xyF,F,F_]=Airy2D_UGIA_F(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) ; 
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
% SNR (dB):   56.99   45.74     39.72 
% RMSMD (nm): 3.75    8.53      15.86   9.38
% Average: mean([3.75    8.53      15.86]) 
