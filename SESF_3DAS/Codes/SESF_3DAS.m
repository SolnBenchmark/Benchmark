%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: SESF_3DAS 
% (1) SE - Single Emitter localization 
% (2) SF - from a Single Frame;
% (3) 3D - emitter locations
% (4) AS - Astigmatic PSF
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
% 2/17/2019
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
  case 'highSNR'    % r=1/(1/rp+1/rg), 10*log10(r)=64.77 (dB)
    b=0.05 ;        % rp=Ih/b, 10*log10(rp)=67.78 (dB)
    G=0.05 ;        % rg=Ih/G, 10*log10(rg)=67.78 (dB)
    key=key+0 ;  
  case 'mediumSNR'  % r=1/(1/rp+1/rg), 10*log10(r)=50.79 (dB)
    b=1.5 ;         % rp=Ih/b, 10*log10(rp)=53.01 (dB)
    G=1 ;           % rg=Ih/G, 10*log10(rg)=54.77 (dB)
    key=key+1 ; 
  case 'lowSNR'     % r=1/(1/rp+1/rg), 10*log10(r)=47.78 (dB)
    b=3 ;           % rp=Ih/b, 10*log10(rp)=50.00 (dB)
    G=2 ;           % rg=Ih/G, 10*log10(rg)=51.76 (dB)
    key=key+2 ; 
  otherwise
    return ;
end
rng(key) ; 
%% Optical system: 3D astigmatic PSF
c=205 ;
d=290 ;         % depth of microscope
sigmax0=280/2 ; Ax=0.05 ; Bx=0.03 ;   % nm
sigmay0=270/2 ; Ay=-0.01 ; By=0.02 ;	% 
%% show sigmax, sigmay vs. z
z=-600:600 ;
sigmax=sigmax0*(1+(z+c).^2/d^2+Ax*(z+c).^3/d^3+Bx*(z+c).^4/d^4).^0.5 ;
sigmay=sigmay0*(1+(z-c).^2/d^2+Ay*(z-c).^3/d^3+By*(z-c).^4/d^4).^0.5 ;
figure
lg=plot(z,sigmax,'r-',z,sigmay,'b--','LineWidth',2) ;
axis([-600 600 0 500])
grid on
set(gca,'FontSize',14,'FontWeight','bold') ;
legend(lg,'\sigma_x(z)','\sigma_y(z)','Location','southeast')
xlabel('z (nm)')
ylabel('\sigma_x(z), \sigma_y(z) (nm)')
%% Frame 
% sample is located at [0,Lx]x[0,Ly]x[-Lz,Lz]
Lx=6e4 ; Ly=6e4 ;     % frame size in nm
Lz=400 ;              % 2xLz - axial depth in nm
Dx=100 ; Dy=100 ;     % pixel size in nm
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
sigma=300 ;           % maximal sigmax and sigmay
eLx=2*4*sigma ;       % an emitter is located in a region of size eLx, eLy, eLy
eLy=2*4*sigma ;       % with probability of 99% 
Mx=floor(Lx/eLx) ;    % number of emitters in x direction
My=floor(Ly/eLy) ;    % number of emitters in y direction
M=Mx*My ;             % =784, number of emitters
xyz=zeros(3,M) ;       % 3D emitter locations 
for ix=1:Mx
  for iy=1:My
    xyz(:,My*(ix-1)+iy)=[eLx*(ix-1+0.5)+50*randn ; eLy*(iy-1+0.5)+50*randn ; -Lz+2*Lz*rand] ; 
  end
end
xyz0=xyz' ;             % ground truth emitter locaitons 
filename_xyz0=strcat('SESF_3DAS_',SNRr,'_xyz0','.txt') ; 
save(filename_xyz0,'-ascii','xyz0') ;
plot3(xyz(1,:),xyz(2,:),xyz(3,:),'r*')
%% Generate and save a data frame
fprintf(1,'Generate a data frame: \n') ; 
U=Frame_3DAS(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,mu,xyz) ;
U16=uint16(U) ; 
filename_Frame=strcat('SESF_3DAS_',SNRr,'_Frame','.tif') ; 
imwrite(U16,filename_Frame) ; % save data frame 
figure
imshow(U,[]) ;        % show data frame 
%% Read a data frame
U16_=imread(filename_Frame); % read data frame 
figure
imshow(U16_,[]) ; 
U=double(U16_) ; 
%% Save a 8-bit PNG image for show
Umax=max(max(U)) ; Umin=min(min(U)) ; 
U8=uint8(255*(U-Umin)/(Umax-Umin)) ;
filename_Frame=strcat('SESF_3DAS_',SNRr,'_Frame','.png') ; 
imwrite(U8,filename_Frame) ; % save data frame 
%% Localization by the UGIA-F estimator 
fprintf(1,'UGIA-F localization: \n') ; 
[xyzF,F,F_]=UGIA_F_3DAS(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz) ;
%% load emitter locations
xyz1=load(filename_xyz0,'-ascii') ;
xyz_=xyz1' ; 
%% Calculate RMSMD
[RMSMD1,RMSMD2]=RMSMD(xyz_,xyzF) ;
fprintf(1,SNRr) ; 
fprintf(1,': SNR=%5.2f (dB) M=%d RMSMD=%6.3f (nm) \n',SNR,M,RMSMD1) ; 

%% Results: UGIA-F estimator
% highSNR:    SNR=64.77 (dB) M=625 RMSMD=11.796 (nm) 
% mediumSNR:  SNR=50.79 (dB) M=625 RMSMD=29.534 (nm) 
% lowSNR:     SNR=47.78 (dB) M=625 RMSMD=39.360 (nm) 
% Average: mean([11.80 29.53 39.36])=26.90 (nm)
