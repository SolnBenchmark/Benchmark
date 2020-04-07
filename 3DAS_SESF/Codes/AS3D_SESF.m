%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: AS3D_SESF 
% (1) AS - Astigmatic PSF
% (2) 3D - emitter locations
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
% 2/17/2019, 04/06/2020
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
  case 'highSNR'    % r=3000000,  SNR=64.77 (dB)
    b=0.05 ;        % rp=6000000, SPNR=67.78 (dB)
    G=0.05 ;        % rg=6000000, SGNR=67.78 (dB)
    key=key+0 ;  
  case 'mediumSNR'  % r=375000,   SNR=55.74 (dB)
    b=0.5 ;         % rp=600000,  SPNR=57.78 (dB)
    G=0.3 ;         % rg=1000000, SGNR=60.00 (dB)
    key=key+1 ; 
  case 'lowSNR'     % r=120000,   SNR=50.79 (dB)
    b=1.5 ;         % rp=200000,  SPNR=53.01 (dB)
    G=1.0 ;         % rg=300000,  SGNR=54.77 (dB)
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
Lx=60e3 ; Ly=60e3 ;     % frame size in nm
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
mu=5 ;                % mean of Gaussian noise (photons/s/nm^2)
Coff=mu*Dt*Dx*Dy ;    % Coff=500 photons/pixel; Camera offset in effect
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
filename_xyz0=strcat('3DAS_SESF_',SNRr,'_xyz0','.txt') ; 
save(filename_xyz0,'-ascii','xyz0') ;
%% Generate and save a data frame
fprintf(1,'Generate a data frame: \n') ; 
U=AS3D_Frame(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xyz) ;
U16=uint16(U) ; 
filename_Frame=strcat('3DAS_SESF_',SNRr,'_Frame','.tif') ; 
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
filename_Frame=strcat('3DAS_SESF_',SNRr,'_Frame','.png') ; 
imwrite(U8,filename_Frame) ; % save data frame 
%% Localization by the UGIA-F estimator 
fprintf(1,'UGIA-F estimator: \n') ; 
[xyzF,F,F_]=AS3D_UGIA_F(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz) ;
%% load emitter locations
xyz1=load(filename_xyz0,'-ascii') ;
xyz_=xyz1' ; 
%% Calculate RMSMD
[RMSMD1,RMSMD2]=RMSMD(xyz_,xyzF) ;
fprintf(1,SNRr) ; 
fprintf(1,': SNR=%5.2f (dB) M=%d RMSMD=%6.3f (nm) \n',SNR,M,RMSMD1) ; 
%% Show estimates
figure('Position',[400 300 600 600],'Color',[1 1 1]) ;
plot3(xyz_(1,:),xyz_(2,:),xyz_(3,:),'k.') ; hold on
plot3(xyzF(1,:),xyzF(2,:),xyzF(3,:),'r.') ; hold off
xlabel('x (nm)') 
ylabel('y (nm)')
ylabel('z (nm)') ; 
axis([0 Lx 0 Ly -Lz Lz])

%% Results, M=625: UGIA-F estimator
%             highSNR	mediumSNR lowSNR  Average 
% SNR (dB):   64.77   55.74     50.79
% RMSMD (nm): 11.80   18.79     30.30   20.30
% Average: mean([11.80 18.79 30.30])
