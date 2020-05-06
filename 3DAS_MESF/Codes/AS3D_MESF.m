%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: AS3D_MESF 
% (1) AS - Astigmatic PSF
% (2) 3D - emitter locations
% (3) ME - Multiple Emitter localization 
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
% 03/01/2019, 04/07/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%% Emitter density: choose one of them
 eDen=0.1 ;            % emitter density (emitters/um^2)
% eDen=0.3 ;            % emitter density (emitters/um^2)
% eDen=0.5 ;            % emitter density (emitters/um^2)
% eDen=1 ;              % emitter density (emitters/um^2)
% eDen=2 ;              % emitter density (emitters/um^2)
% eDen=3 ;              % emitter density (emitters/um^2)
fprintf(1,'Density=%3.1f (emitters/um^2): \n',eDen) ; 
%% Intialization 
rng('default') ; 
key=0 ;                 % key for random number generators
key=key+round(1e2*eDen) ; 
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
M=500 ;               % number of emitters 
% sample is located at [0,Lx]x[0,Ly]x[-Lz,Lz]
Lx=100*round(10*sqrt(M/eDen)) ; % an integer multiple of Dx
Ly=Lx ;               % frame size in nm
Dx=100 ; Dy=100 ;     % pixel size of cammera
Kx=Lx/Dx ; Ky=Ly/Dy ; % frame size in pixels
Lz=400 ;              % 2xLz - axial depth in nm
%% Emitter intensity and signal to noise ratio
Dt=0.01 ;             % second, time per frame (1/Dt is frame rate) 
Ih=300000 ;           % average number of detected photons per emitter per second
DtIh=Dt*Ih ;          % photon count per frame per emitter 
% 'mediumSNR'         % r=600000,   SNR=57.78 (dB)
b=0.3 ;               % rp=1000000,  SPNR=60.00 (dB)
G=0.2 ;               % rg=1500000, SGNR=61.76 (dB)
rp=Ih/b ;             % SPNR (nm^2/emitter) 
SPNR=10*log10(rp) ;   % SPNR (dB)
rg=Ih/G ;             % SGNR (nm^2/emitter) 
SGNR=10*log10(rg) ;   % SGNR (dB)
r=rp*rg/(rp+rg) ;     % total SNR (nm^2/emitter) 
SNR=10*log10(r) ;     % total SNR (dB)
mu=5 ;                % mean of Gaussian noise (photons/s/nm^2)
Coff=mu*Dt*Dx*Dy ;    % Coff=500 photons/pixel; Camera offset in effect
%% Emitter locations - ground truth
xyz=[Lx*rand(1,M)     % randomly uniformly distributed in [0,Lx]x[0,Ly]x[-Lz,Lz]
     Ly*rand(1,M)
    -Lz+2*Lz*rand(1,M)] ;  
xyz0=xyz' ;           % ground truth emitter locaitons 
filename_xyz0=strcat('3DAS_MESF_density',num2str(eDen),'_xyz0','.txt') ; 
save(filename_xyz0,'-ascii','xyz0') ;
%% Generate and save a data frame
fprintf(1,'Generate a data frame: \n') ; 
U=AS3D_Frame(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xyz) ;
U16=uint16(U) ; 
filename_Frame=strcat('3DAS_MESF_density',num2str(eDen),'_Frame','.tif') ; 
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
filename_Frame=strcat('3DAS_MESF_density',num2str(eDen),'_Frame','.png') ; 
imwrite(U8,filename_Frame) ; % save data frame 
%% Localization by the UGIA-F estimator 
fprintf(1,'UGIA-F estimator: \n') ; 
[xyzF,F,F_]=AS3D_UGIA_F(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz) ;
%% load emitter locations
xyz1=load(filename_xyz0,'-ascii') ;
xyz_=xyz1' ; 
%% Calculate RMSMD
[RMSMD1,RMSMD2]=RMSMD(xyz_,xyzF) ;
fprintf(1,'Density=%2.1f Lx=%d Ly=%d M=%d RMSMD=%6.3f (nm) \n',eDen,Lx,Ly,M,RMSMD1) ; 
%% Show estimates
figure('Position',[400 300 600 600],'Color',[1 1 1]) ;
plot3(xyz_(1,:),xyz_(2,:),xyz_(3,:),'k.') ; hold on
plot3(xyzF(1,:),xyzF(2,:),xyzF(3,:),'r.') ; hold off
xlabel('x (nm)') 
ylabel('y (nm)')
ylabel('z (nm)') ; 
axis([0 Lx 0 Ly -Lz Lz])

%% Results, M=500: UGIA-F estimator
% eDen        0.1   0.3   0.5   1     2     3     Average 
% Lx=Ly (nm)  70700 40800 31600 22400 15800 12900
% RMSMD (nm)  16.90 21.44 22.51 25.37 42.85 68.90 33.00
% mean([16.90 21.44 22.51 25.37 42.85 68.90])
