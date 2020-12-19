%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: Airy2D_MESF 
% (1) Airy - PSF
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
% [3] Y. Sun, "Information sufficient segmentation and signal-to-noise 
% ratio in stochastic optical localization nanoscopy," Optics Letters, 
% vol. 45, no. 21, pp. 6102-6105, Nov. 1, 2020. 
% 
% Yi Sun
% Electrical Engineering Department
% The City College of City University of New York
% E-mail: ysun@ccny.cuny.edu
% 02/24/2020, 04/03/2020, 04/18/2020, 12/18/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%% Emitter density: choose one of them
 eDen=0.5 ;          % emitter density (emitters/um^2)
% eDen=1 ;            % emitter density (emitters/um^2)
% eDen=2 ;            % emitter density (emitters/um^2)
% eDen=4 ;            % emitter density (emitters/um^2)
% eDen=8 ;            % emitter density (emitters/um^2)
fprintf(1,'Density=%3.2f (emitters/um^2): \n',eDen) ; 
%% Intialization 
rng('default') ; 
key=0 ;               % key for random number generators
key=key+floor(eDen) ; 
rng(key) ; 
%% Optical system 
na=1.43 ; 
lambda=665 ;                  % Alexa647 wavelength in nm
a=2*pi*na/lambda ;  
sigma=1.3238/a ;              % sigma=97.98; 2*sigma=195.96 (nm) 
FWHM=2*sqrt(2*log(2))*sigma ; % FWHM=230.72 (nm)
%% Frame 
M=1000 ;              % number of emitters 
% Region of view: [0,Lx]x[0,Ly]
Lx=100*round(10*sqrt(M/eDen)) ; % an integer multiple of Dx
Ly=Lx ;               % frame size in nm
Dx=100 ; Dy=100 ;     % pixel size of cammera
Kx=Lx/Dx ; Ky=Ly/Dy ; % frame size in pixels
%% Emitter intensity and signal to noise ratio
Dt=0.01 ;             % second, time per frame (1/Dt is frame rate) 
Ih=300000 ;           % average number of detected photons per emitter per second
DtIh=Dt*Ih ;          % photon count per frame per emitter 
% 'mediumSNR'         % 
b=5 ;                 % 
G=3 ;                 % 
betas=0.03209 ;       % [3]
beta=a^2*betas ; 
rp=Ih/b ;             % 60000
nup=beta*rp ; 
SPNR=10*log10(nup)    % -4.54 (dB)
rg=Ih/G ;             % 100000
nug=beta*rg ; 
SGNR=10*log10(nug)    % -2.32 (dB)
r=rp*rg/(rp+rg) ;     % 37500
nu=beta*r ; 
SNR=10*log10(nu)      % -6.58 (dB)
mu=5 ;                % mean of Gaussian noise (photons/s/nm^2)
Coff=mu*Dt*Dx*Dy ;    % Coff=500 photons/pixel; Camera offset in effect
%% Emitter locations - ground truth
xy=[Lx*rand(1,M) ; Ly*rand(1,M)] ;  % randomly uniformly distributed 
xy0=xy' ;             % ground truth emitter locaitons 
filename_xy0=strcat('2DAiry_MESF_density',num2str(eDen),'_xy0','.txt') ; 
save(filename_xy0,'-ascii','xy0') ;
%% Generate and save a data frame
fprintf(1,'Generate a data frame: \n') ; 
U=Airy2D_Frame(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xy) ;
U16=uint16(U) ; 
filename_Frame=strcat('2DAiry_MESF_density',num2str(eDen),'_Frame','.tif') ; 
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
filename_Frame=strcat('2DAiry_MESF_density',num2str(eDen),'_Frame','.png') ; 
imwrite(U8,filename_Frame) ; % save data frame 
%% Localization by the UGIA-F estimator 
fprintf(1,'UGIA-F estimator: \n') ;
[xyF,F,F_]=Airy2D_UGIA_F(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) ; 
%% load emitter locations
xy1=load(filename_xy0,'-ascii') ;
xy_=xy1' ; 
%% Calculate RMSMD
[RMSMD1,RMSMD2]=RMSMD(xy_,xyF) ;
fprintf(1,'Density=%3.2f Lx=%d Ly=%d M=%d RMSMD=%6.3f (nm) \n',eDen,Lx,Ly,M,RMSMD1) ; 
%% Show estimates
figure('Position',[400 300 600 600],'Color',[1 1 1]) ;
plot(xy_(1,:),xy_(2,:),'k.') ; hold on
plot(xyF(1,:),xyF(2,:),'r.') ; hold off
xlabel('x (nm)') 
ylabel('y (nm)') ; 
axis([0 Lx 0 Ly])

%% Results, M=1000: UGIA-F estimator
% eDen        0.5   1     2     4     8     Average 
% Lx=Ly (nm)  44700 31600 22400 15800 11200 
% RMSMD (nm)  8.91  9.70  13.48 18.28 24.85 15.04
% mean([8.91  9.70  13.48 18.28 24.85]) 
