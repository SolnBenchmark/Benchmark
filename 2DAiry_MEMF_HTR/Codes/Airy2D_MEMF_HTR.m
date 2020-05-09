%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: Airy2D_MEMF_HTR 
% (1) Airy - PSF
% (2) 2D - emitter locations 
% (3) ME - Multiple Emitter localization 
% (4) MF - from a data movie of multiple frame
% (5) HTR - high temporal resolution 
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
% 02/26/2020, 04/05/2020, 05/07/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%% Emitter distance: choose one of three
 eD=40 ;     % nm 
% eD=30 ;     % nm 
% eD=20 ;     % nm 
%% Intialization 
rng('default') ; 
key=0 ;       % key for random number generators
key=key+eD ; 
rng(key) ; 
fprintf(1,'Emitter distance: %d (nm) \n',eD) ; 
%% Optical system 
na=1.43 ; 
lambda=665 ;                  % Alexa647 wavelength in nm
a=2*pi*na/lambda ;  
% 2D Gaussian PSF; sigma is estimated from Airy PSF
sigma=1.3238/a ;              % sigma=97.98; 2*sigma=195.96 (nm) 
FWHM=2*sqrt(2*log(2))*sigma ; % FWHM=230.72 (nm)
%% Frame 
% Region of view: [0,Lx]x[0,Ly]
Lx=2^12 ;
Ly=Lx ;               % frame size in nm
Dx=2^7 ; Dy=2^7 ;     % pixel size of cammera
Kx=Lx/Dx ; Ky=Ly/Dy ; % frame size in pixels
%% Emitter intensity and signal to noise ratio
Dt=0.01 ;             % second, time per frame (1/Dt is frame rate) 
Ih=300000 ;           % average number of detected photons per emitter per second
DtIh=Dt*Ih ;          % photon count per frame per emitter 
% 'mediumSNR'         % r=37500,    SNR=45.74 (dB)
b=5 ;                 % rp=60000,   SPNR=47.78 (dB)
G=3 ;                 % rg=100000,  SGNR=50.00 (dB)
rp=Ih/b ;             % SPNR (nm^2/emitter) 
SPNR=10*log10(rp) ;   % SPNR (dB)
rg=Ih/G ;             % SGNR (nm^2/emitter) 
SGNR=10*log10(rg) ;   % SGNR (dB)
r=rp*rg/(rp+rg) ;     % total SNR (nm^2/emitter) 
SNR=10*log10(r) ;     % total SNR (dB)
mu=5 ;                % mean of Gaussian noise (photons/s/nm^2)
Coff=mu*Dt*Dx*Dy ;    % Coff=819.2 photons/pixel; Camera offset in effect
%% Emitter locations - ground truth
fprintf(1,'Emitter locations: \n') ;
M=500 ;
phi=0.1 ; beta=7+0.5*rand ;  % helix parameters xy1=zeros(2,M) ;
xy1=zeros(2,M) ; 
t=zeros(1,M) ; 
m=1 ; t(m)=2 ;        % 1st emitter locaiton
xy1(:,m)=[beta*t(m)*cos(phi*t(m)) ; beta*t(m)*sin(phi*t(m))] ; 
for m=2:M
  if mod(m,10)==0||m==1
    fprintf(1,'M=%3d m=%3d \n',M,m) ;
  end
  syms t0
  St=vpasolve((beta*t0*cos(phi*t0)-xy1(1,m-1))^2+(beta*t0*sin(phi*t0)-xy1(2,m-1))^2==eD^2,t0,t(m-1)+0.1) ;
  t(m)=St ;
  xy1(:,m)=[beta*t(m)*cos(phi*t(m)) ; beta*t(m)*sin(phi*t(m))] ;
end
phi_=2*pi*rand ;      % random initial position 
xy_=2*randn(2,1) ;  
xy=[[cos(phi_) -sin(phi_)] ; [sin(phi_) cos(phi_)]]*xy1+xy_ ; 
xy=xy+[Lx/2 ; Ly/2] ; % adjust to frame center 
% save emitter locations 
xy0=xy' ;             % ground truth emitter locaitons 
filename_xy0=strcat('2DAiry_MEMF_HTR_eD',num2str(eD),'nm_xy0','.txt') ; 
save(filename_xy0,'-ascii','xy0') ;

%% Emitter activations
N=100 ;     % Temporal resolution (TR): N*Dt=1 sec
Nape=12 ;   % Average # of activations per emitter in data movie
            % =(1-p0)*N ; ensure each emitter is activated at least once 
J=4 ;       % Maximum state
r01=0.5 ;   r02=0.7 ;   r03=0.8 ;   r04=1.0 ; 
r21=1-r01 ; r32=1-r02 ; r43=1-r03 ;  
r00=1-Nape/((N-Nape)*(1+r21+r21*r32+r21*r32*r43)) ; % =0.9188
r10=1-r00 ; 
R=[r00 r01 r02 r03 r04 % matrix of state transition probabilities
   r10 0   0   0   0
   0   r21 0   0   0
   0   0   r32 0   0
   0   0   0   r43 0] ;
den=1+r10+r10*r21+r10*r21*r32+r10*r21*r32*r43 ; 
p0=1/den ;                % =0.8800, probability of deactivation, i.e. state 0
p1=r10/den ;              % =0.0714, probability of state 1
p2=r10*r21/den ;          % =0.0357, probability of state 2
p3=r10*r21*r32/den ;      % =0.0107, probability of state 3
p4=r10*r21*r32*r43/den ;  % =0.0022, probability of state 4
pa=1-p0 ;                 % =0.1200, probability of activation 
Naae=(1-p0)*M ;           % =Nape*M/N=60, average # of activated emitters/frame
pd=1-(1-p0^N)^M ;         % =1.4026e-3, probability that at least one emitter
                          % is not activated in data movie
c0=zeros(M,N+1) ; % states of Markov chains in data movie
for n=2:N+1
  for m=1:M
    c0(m,n)=(c0(m,n-1)+1)*(1-(rand<R(1,c0(m,n-1)+1))) ; % state transitions
  end
end
c=c0(:,2:N+1) ;   % remove initial all-0 state
if sum(c(:,1))==0 % avoid all zeros in 1st frame!
  c(1,1)=1 ; 
end

%% Generate and save a data movie
fprintf(1,'Generate a data movie: \n') ; 
a=(c~=0) ;      % a(m,n)=1 if activated; a(m,n)=0 otherwise  
                % sum(sum(a')==0): # of emitters never activated 
Na=sum(a) ;     % number of activated emitters in nth frame
xyActive=zeros(2,M,N) ; % activated emitter locations in nth frame
ma=zeros(M,N) ; % index of activated emitters in a frame 
for n=1:N
  p=0 ; 
  if Na(n)>0
    for m=1:M
      if a(m,n)
        p=p+1 ;
        xyActive(:,p,n)=xy(:,m) ;
        ma(p,n)=m ;               % mth emitter is actived in nth frame
      end
    end
  end
  U=Airy2D_Frame(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xyActive(:,1:p,n)) ;
  U16=uint16(U) ;
  filename_Frame=strcat('2DAiry_MEMF_HTR_eD',num2str(eD),'nm_Frame',num2str(n),'.tif') ;
  imwrite(U16,filename_Frame) ;       % save data frame
  if mod(n,10)==0||n==1
    fprintf(1,'eD=%2d N=%3d n=%3d Na=%d \n',eD,N,n,Na(n)) ;
  end
end

%% Read 10th data frame
Fig=figure('Position',[400 200 400 400],'Color',[1 1 1]) ;
filename_Frame=strcat('2DAiry_MEMF_HTR_eD',num2str(eD),'nm_Frame',num2str(10),'.tif') ;
U16=imread(filename_Frame); % read 10th data frame 
U=double(U16) ; 
show8bimage(U,'Yes','gray','No') ;  % show data frame

%% Save 10th data frame as a 8-bit PNG for show
Umax=max(max(U)) ; Umin=min(min(U)) ; 
U8=upsample2D(8,8,U) ;
U88=uint8(255*(U8-Umin)/(Umax-Umin)) ;
filename_Frame=strcat('2DAiry_MEMF_HTR_eD',num2str(eD),'nm_Frame',num2str(10),'.png') ;
imwrite(U88,filename_Frame) ; % save data frame 

%% Localization by the UGIA-M and UGIA-F estimators 
fprintf(1,'UGIA-M and UGIA-F estimators: \n') ; 
[xyM,xyF]=Airy2D_UGIA_MF(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy,a) ;
%% Calculate RMSMD and show sequence
Fig=figure('Position',[300 200 600 600],'Color',[0 0 0]) ;
sft=0.075 ;     % Figure setup
C1=-sft ; C2=0.5-(1-0.25)*sft+0.006;
R1=0.5-(1-0.25)*sft+0.009 ; R2=-sft+0.011 ;
W1=0.5+1.25*sft-0.008 ; W2=0.5+1.25*sft+0.012 ;
H1=0.5+1.25*sft-0.001 ; H2=0.5+1.25*sft-0.001 ;

xyFa=zeros(2,sum(Na)) ; 
RMSMD_M=zeros(1,N) ; RMSMD_F=zeros(1,N) ; 
pF=0 ;        % number of activated emitters from 1st to nth frames
Ia=uint8(zeros(M,1)) ;  % indices of activated emitter of a movie
for n=1:N
% 
  Figa=subplot(2,2,1) ;
  plot(xy(1,:),Ly-xy(2,:),'w.','MarkerSize',4) ; hold on
  plot(xyActive(1,1:Na(n),n),Ly-xyActive(2,1:Na(n),n),'r.') ;
  plot([0 Lx Lx 0 0],[0 0 Ly Ly 0],'w-','MarkerSize',2)
  plot([200 700],[200 200],'w-',[200 200],[200-60 200+60],'w-',[700 700],[200-60 200+60],'w-') ;
  hold off
  text(180,420,'500 nm','Color','white') ;
  axis([0 Lx 0 Ly])
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  axis off
  set(Figa,'OuterPosition',[C1,R1,W1,H1]) ;
%
  Figb=subplot(2,2,2) ;
  filename_Frame=strcat('2DAiry_MEMF_HTR_eD',num2str(eD),'nm_Frame',num2str(n),'.tif') ;
  V16=imread(filename_Frame); % read data frame
  V=double(V16) ;
  show8bimage(V,'Yes','gray','No') ; hold on
  plot([0 Lx/Dx Lx/Dx 0 0]+0.5,[0 0 Ly/Dy Ly/Dy 0]+0.5,'w-','MarkerSize',2) ; hold off
  text(1+0.5,30+0.3,compose('TR=%5.2f (sec)',Dt*n),'Color','white') ;
  axis off
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  set(Figb,'OuterPosition',[C2,R1,W2,H1]) ;
%
  Figc=subplot(2,2,3) ; % show current estimated locations
  Ia=(Ia | a(:,n)) ;
  pM=sum(Ia) ;        % # of emitters that were activated at least once in frames 1 to  n
  [RMSMD_M(n),~]=RMSMD(xyM(:,1:pM,n),xy) ;
  plot(xyM(1,1:pM,n),Ly-xyM(2,1:pM,n),'w.','MarkerSize',4) ; hold on
  plot([0 Lx Lx 0 0],[0 0 Ly Ly 0],'w-','MarkerSize',2) ; hold off
  axis([0 Lx 0 Ly])
  text(1*Dx,Ly-2*Dy,'UGIA-M','Color','white') ;
  text(1*Dx,Ly-30*Dy,compose('RMSMD=%4.2f (nm) ',RMSMD_M(n)),'Color','white') ;
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  axis off
  set(Figc,'OuterPosition',[C1,R2,W1,H2]) ;
%
  Figd=subplot(2,2,4) ; % show all estimated locations
  xyFa(:,pF+1:pF+Na(n))=xyF(:,1:Na(n),n) ;  % No action if Na(n)=0
  pF=pF+Na(n) ;         % # of locations in frames 1 to n
  % remove estimated locations outside [0,Lx]x[0,Ly]x[-Lz,Lz] !
  xyT=zeros(2,pF) ;    
  p=0 ;                 % # of estimated locations inside [0,Lx]x[0,Ly]x[-Lz,Lz]
  for i=1:pF
    if xyFa(1,i)>=0&&xyFa(1,i)<=Lx ...
       &&xyFa(2,i)>=0&&xyFa(2,i)<=Ly
      p=p+1 ;
      xyT(:,p)=xyFa(:,i) ; 
    end
  end
  [RMSMD_F(n),~]=RMSMD(xyT(:,1:p),xy) ;
  %[RMSMD_F(n),~]=RMSMD(xyFa(:,1:pF),xy) ;
  plot(xyFa(1,1:pF),Ly-xyFa(2,1:pF),'w.','MarkerSize',4) ; hold on
  plot([0 Lx Lx 0 0],[0 0 Ly Ly 0],'w-','MarkerSize',2) ; hold off
  axis([0 Lx 0 Ly])
  text(1*Dx,Ly-2*Dy,'UGIA-F','Color','white') ;
  text(1*Dx,Ly-30*Dy,compose('RMSMD=%4.2f (nm) ',RMSMD_F(n)),'Color','white') ;
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  axis off
  set(Figd,'OuterPosition',[C2,R2,W2,H2]) ;
  getframe(gcf) ;
  fprintf(1,'eD=%2d N=%3d n=%3d pM=%d pF=%d p=%d \n',eD,N,n,pM,pF,p) ;
end

%% Show RMSMDs
figure
lg=loglog(Dt*(1:N),RMSMD_M,'r-',Dt*(1:N),RMSMD_F,'k-') ; 
legend(lg,'UGIA-M','UGIA-F','location','southwest') ; 
axis([Dt Dt*N min(RMSMD_M) max(RMSMD_M)]) ;
ylabel('RMSMD (nm)') ; 
xlabel('Temporal resolution (s)') ; 

%% Results: RMSMD vs emitter distance 
% M=500; N=100; TR=1 sec
% pM: # emitters activated at least once in a movie
% Distance:     40    30    20      Average (nm)
% pM:           499   500   500
% UGIA-M (nm):  3.10  3.02  3.45
% UGIA-F (nm):  43.37 88.96 191.08
% mean([]) 
