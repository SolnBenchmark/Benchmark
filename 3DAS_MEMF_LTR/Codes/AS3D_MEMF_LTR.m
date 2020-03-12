%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: AS3D_MEMF_LTR 
% (1) Astigmatic - PSF
% (2) 3D - emitter locations 
% (3) ME - Multiple Emitter localization 
% (4) MF - from a data movie of multiple frame
% (5) LTR - Low temporal resolution 
% (6) 3 data movies are synthesized with adjacent emitter distances of 40, 
%     30, 20 nm 
% (7) b  - mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
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
% [3] Y. Sun, "Spatiotemporal resolution as an information theoretical 
% property of stochastic optical localization nanoscopy," 2020 Quantitative 
% BioImaging Conf., QBI 2020, Oxford, UK, Jan. 6-9, 2020.
% 
% Yi Sun
% Electrical Engineering Department
% The City College of City University of New York
% E-mail: ysun@ccny.cuny.edu
% 03/07/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%% Emitter distance: choose one of three
 eD=40 ;             % nm 
% eD=30 ;             % nm 
% eD=20 ;             % nm 
%% Intialization 
rng('default') ; 
key=0 ;               % key for random number generators
key=key+eD ; 
rng(key) ; 
fprintf(1,'Emitter lateral distance: %d (nm) \n',eD) ; 
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
Lx=2^11 ; 
Ly=Lx ;               % frame size in nm
Dx=2^7 ; Dy=2^7 ;     % pixel size of cammera
Kx=Lx/Dx ; Ky=Ly/Dy ; % frame size in pixels
Lz=400 ;              % 2xLz - axial depth in nm
%% Emitter intensity and signal to noise ratio
Dt=0.01 ;             % second, time per frame (1/Dt is frame rate) 
Ih=300000 ;           % average number of detected photons per emitter per second
DtIh=Dt*Ih ;          % photon count per frame per emitter 
% 'mediumSNR'         % r=1/(1/rp+1/rg), 10*log10(r)=57.78 (dB)
b=0.3 ;               % rp=Ih/b, 10*log10(rp)=60.00 (dB)
G=0.2 ;               % rg=Ih/G, 10*log10(rg)=61.76 (dB)
rp=Ih/b ;             % SPNR (nm^2/emitter) 
SPNR=10*log10(rp) ;   % SPNR (dB)
rg=Ih/G ;             % SGNR (nm^2/emitter) 
SGNR=10*log10(rg) ;   % SGNR (dB)
r=rp*rg/(rp+rg) ;     % total SNR (nm^2/emitter) 
SNR=10*log10(r) ;     % total SNR (dB)
mu=0.5 ;              % mean of Gaussian noise (photons/s/nm^2)
%% Emitter locations - ground truth
fprintf(1,'Emitter locations: \n') ;
M=250 ; 
beta=4 ; phi=0.1 ;    % helix parameters 
xy1=zeros(3,M) ; 
t=zeros(1,M) ; 
m=1 ; t(m)=2 ;        % 1st emitter locaiton
xy1(:,m)=[beta*t(m)*cos(phi*t(m))  
          beta*t(m)*sin(phi*t(m))
          -Lz+(m-0.5)*(2*Lz/M)] ; 
for m=2:M
  if mod(m,10)==0||m==1
    fprintf(1,'M=%3d m=%3d \n',M,m) ;
  end
  syms t0
  St=vpasolve((beta*t0*cos(phi*t0)-xy1(1,m-1))^2+(beta*t0*sin(phi*t0)-xy1(2,m-1))^2==eD^2,t0,t(m-1)+0.1) ;
  t(m)=St ;
  xy1(:,m)=[beta*t(m)*cos(phi*t(m)) 
            beta*t(m)*sin(phi*t(m))
            -Lz+(m-0.5)*(2*Lz/M)] ; 
end
phi_=2*pi*rand ;        % random initial position in lateral plane
xy_=[cos(phi_) -sin(phi_) 
     sin(phi_) cos(phi_)]*xy1(1:2,:)+2*randn(2,1) ; 
xy_=xy_+[Lx/2 ; Ly/2] ; % adjust to frame center in lateral plane
xyz=[xy_ ; xy1(3,:)] ; 
% show emitter locations
figure 
plot3(xyz(1,:),xyz(2,:),xyz(3,:),'r*') ; 
axis([0 Lx 0 Ly -Lz Lz]) ; 
% save emitter locations 
xyz0=xyz' ;             % ground truth emitter locaitons 
filename_xyz0=strcat('3DAS_MEMF_LTR_eD',num2str(eD),'nm_xyz0','.txt') ; 
save(filename_xyz0,'-ascii','xyz0') ;

%% Emitter activations
N=1000 ;    % Temporal resolution (TR): N*Dt=10 sec
Nape=12 ;   % Average # of activations per emitter in data movie
            % =(1-p0)*N ; ensure each emitter is activated at least once 
J=4 ;       % Maximum state
r01=0.5 ;   r02=0.7 ;   r03=0.8 ;   r04=1.0 ; 
r21=1-r01 ; r32=1-r02 ; r43=1-r03 ;  
r00=1-Nape/((N-Nape)*(1+r21+r21*r32+r21*r32*r43)) ; % =0.9928
r10=1-r00 ; 
R=[r00 r01 r02 r03 r04 % matrix of state transition probabilities
   r10 0   0   0   0
   0   r21 0   0   0
   0   0   r32 0   0
   0   0   0   r43 0] ;
den=1+r10+r10*r21+r10*r21*r32+r10*r21*r32*r43 ; 
p0=1/den ;        % =0.9880, probability of de-activation
Naae=(1-p0)*M ;   % =Nape*M/N=3, average # of activated emitters/frame
pd=1-(1-p0^N)^M ; % =1.4275e-03, probability that at least one emitter 
                  % is not activated in data movie
c0=zeros(M,N+1) ; % states of Markov chains in data movie
for n=2:N+1
  for m=1:M
    c0(m,n)=(c0(m,n-1)+1)*(1-(rand<R(1,c0(m,n-1)+1))) ; % state transitions
  end
end
ca=c0(:,2:N+1) ;   % remove initial all-0 state
if sum(ca(:,1))==0 % avoid all zeros in 1st frame!
  ca(1,1)=1 ; 
end

%% Generate and save a data movie
fprintf(1,'Generate a data movie: \n') ; 
a=(ca~=0) ;     % a(m,n)=1 if activated; a(m,n)=0 otherwise  
                % sum(sum(a')==0): # of emitters never activated 
Na=sum(a) ;     % number of activated emitters in nth frame
xyzActive=zeros(3,M,N) ; % activated emitter locations in nth frame
ma=zeros(M,N) ; % index of activated emitters in a frame 
for n=1:N
  p=0 ; 
  if Na(n)>0
    for m=1:M
      if a(m,n)
        p=p+1 ;
        xyzActive(:,p,n)=xyz(:,m) ;
        ma(p,n)=m ;               % mth emitter is actived in nth frame
      end
    end
  end
  U=AS3D_Frame(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xyzActive(:,1:p,n)) ;
  U16=uint16(U) ;
  filename_Frame=strcat('3DAS_MEMF_LTR_eD',num2str(eD),'nm_Frame',num2str(n),'.tif') ;
  imwrite(U16,filename_Frame) ;       % save data frame
  if mod(n,10)==0||n==1
    fprintf(1,'eD=%2d N=%3d n=%3d Na=%d \n',eD,N,n,Na(n)) ;
  end
end

%% Read 10th data frame
Fig=figure('Position',[400 200 400 400],'Color',[1 1 1]) ;
filename_Frame=strcat('3DAS_MEMF_LTR_eD',num2str(eD),'nm_Frame',num2str(10),'.tif') ;
U16=imread(filename_Frame); % read 10th data frame 
U=double(U16) ; 
show8bimage(U,'Yes','gray','No') ;  % show data frame

%% Save 10th data frame as a 8-bit PNG for show
Umax=max(max(U)) ; Umin=min(min(U)) ; 
U8=upsample2D(8,8,U) ;
U88=uint8(255*(U8-Umin)/(Umax-Umin)) ;
filename_Frame=strcat('3DAS_MEMF_LTR_eD',num2str(eD),'nm_Frame',num2str(10),'.png') ;
imwrite(U88,filename_Frame) ; % save data frame 

%% Localization by the UGIA-M and UGIA-F estimators 
fprintf(1,'UGIA-M and UGIA-F estimators: \n') ; 
[xyzM,xyzF,FF,FF_]=AS3D_UGIA_MF(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz,a) ;
%% Calculate RMSMD and show sequence
Fig=figure('Position',[400 50 600 600],'Color',[1 1 1]) ;
sft=0.07 ; 
xyzFa=zeros(3,sum(Na)) ; 
RMSMD_M=zeros(1,N) ; 
RMSMD_F=zeros(1,N) ; 
pF=0 ;                  % number of activated emitters from 1st to nth frames
Ia=uint8(zeros(M,1)) ;  % indices of activated emitter of a movie
for n=1:N
% 
  Figa=subplot(2,2,1) ;
  whitebg([0 0 0]) ;
  show8bNanoscopyImage(xyz(1:2,:),Lx,Ly,1,1,7,'Yes','gray','No') ; hold on
  plot(xyzActive(1,1:Na(n),n),xyzActive(2,1:Na(n),n),'r.') ;
  plot([100 400],Ly-[100 100],'w-',[100 100],Ly-[100-30 100+30],'w-',[400 400],Ly-[100-30 100+30],'w-') ;
  hold off
  text(105,Ly-200,'300 nm','Color','white') % ,'FontSize',8)
  axis([0 Lx 0 Ly])
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  axis off
  set(Figa,'OuterPosition',[-sft,0.5-(1-0.25)*sft+0.005,0.5+1.25*sft,0.5+1.25*sft]);
%
  Figb=subplot(2,2,2) ;
  filename_Frame=strcat('3DAS_MEMF_LTR_eD',num2str(eD),'nm_Frame',num2str(n),'.tif') ;
  V16=imread(filename_Frame); % read 10th data frame
  V=double(V16) ;
  show8bimage(V,'Yes','gray','No') ;
  text(1,15.5,compose('TR=%5.2f (sec)',Dt*n),'Color','white') %,'FontSize',8)
  axis off
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  set(Figb,'OuterPosition',[0.5-(1-0.25)*sft+0.0115,0.5-(1-0.25)*sft+0.005,0.5+1.25*sft,0.5+1.25*sft]);
%
  Figc=subplot(2,2,3) ; % show current estimated locations
  Ia=(Ia | a(:,n)) ;
  pM=sum(Ia) ;        % # of emitters that were activated at least once in frames 1 to  n
  [RMSMD_M(n),~]=RMSMD(xyzM(:,1:pM,n),xyz) ;
  show8bNanoscopyImage(xyzM(1:2,1:pM,n),Lx,Ly,1,1,7,'Yes','gray','No') ;
  text(0.5*Dx,1*Dy,'UGIA-M','Color','white') %,'FontSize',8)
  text(0.5*Dx,15*Dy,compose('RMSMD=%4.2f (nm)',RMSMD_M(n)),'Color','white') %,'FontSize',8)
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  axis off
  set(Figc,'OuterPosition',[-sft,-sft+0.01,0.5+1.25*sft,0.5+1.25*sft]);
%
  Figd=subplot(2,2,4) ; % show all estimated locations
  xyzFa(:,pF+1:pF+Na(n))=xyzF(:,1:Na(n),n) ;  % No action if Na(n)=0
  pF=pF+Na(n) ;         % # of locations in frames 1 to n
  % remove estimated locations outside [0,Lx]x[0,Ly]x[-Lz,Lz] !
  xyzT=zeros(3,pF) ;    
  p=0 ;                 % # of estimated locations inside [0,Lx]x[0,Ly]x[-Lz,Lz]
  for i=1:pF
    if xyzFa(1,i)>=0&&xyzFa(1,i)<=Lx ...
       &&xyzFa(2,i)>=0&&xyzFa(2,i)<=Ly ...
       &&xyzFa(3,i)>=-Lz&&xyzFa(3,i)<=Lz
      p=p+1 ;
      xyzT(:,p)=xyzFa(:,i) ; 
    end
  end
  [RMSMD_F(n),~]=RMSMD(xyzT(:,1:p),xyz) ;
  %[RMSMD_F(n),~]=RMSMD(xyzFa(:,1:pF),xyz) ;
  show8bNanoscopyImage(xyzFa(1:2,1:pF),Lx,Ly,1,1,7,'Yes','gray','No') ;
  text(0.5*Dx,1*Dy,'UGIA-F','Color','white') %,'FontSize',8)
  text(0.5*Dx,15*Dy,compose('RMSMD=%4.2f (nm)',RMSMD_F(n)),'Color','white') %,'FontSize',8)
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  axis off
  set(Figd,'OuterPosition',[0.5-(1-0.25)*sft+0.0115,-sft+0.01,0.5+1.25*sft,0.5+1.25*sft]);
  getframe(gcf) ;
  fprintf(1,'eD=%2d N=%3d n=%3d pM=%d pF=%d p=%d \n',eD,N,n,pM,pF,p) ;
end

%% Show RMSMDs
figure
whitebg([1 1 1]) ;
lg=loglog(Dt*(1:N),RMSMD_M,'r-',Dt*(1:N),RMSMD_F,'k-') ;
axis([0.01 N*Dt 1 1e3])
legend(lg,'UGIA-M','UGIA-F') ; 
ylabel('RMSMD (nm)') ; 
xlabel('Temporal resolution (s)') ; 

%% Show SOLN images
figure
plot3(xyzF(1,1:pF),xyzF(2,1:pF),xyzF(3,1:pF),'g+') ; hold on
plot3(xyzM(1,1:pM,n),xyzM(2,1:pM,n),xyzM(3,1:pM,n),'bx') ; 
plot3(xyz(1,:),xyz(2,:),xyz(3,:),'r*') ; 
hold off
axis([0 Lx 0 Ly -Lz Lz]) ; 

%% Results: RMSMD vs emitter distance 
% M=250; N=200; TR=2 sec
% pM: # of emitters activated at least once in a movie
% Distance: 40    30    20    Average (nm)
% pM:       250   250   250     
% UGIA-M:   6.12  6.03  6.45  6.20
% UGIA-F:   38.35 47.28 57.15 47.59
% Average RMSMD-M: mean([6.12  6.03  6.45])
% Average RMSMD-F: mean([38.35 47.28 57.15])
