%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SolnBenchmark: MEMF_2DGauss 
% (1) ME - Multiple Emitter localization 
% (2) MF - from a data movie of multiple frame
% (3) 2D - emitter locations 
% (4) Gaussian - PSF
% (5) 3 data movies are synthesized with adjacent emitter distances of 40, 
%     30, 20 nm 
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
% [3] Y. Sun, "Spatiotemporal resolution as an information theoretical 
% property of stochastic optical localization nanoscopy," 2020 Quantitative 
% BioImaging Conf., QBI 2020, Oxford, UK, Jan. 6-9, 2020.
% 
% Yi Sun
% Electrical Engineering Department
% The City College of City University of New York
% E-mail: ysun@ccny.cuny.edu
% 01/18/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%% Emitter distance: choose one of three
 eD=40 ;            % nm 
% eD=30 ;          % nm 
% eD=20 ;          % nm 
%% Intialization 
rng('default') ; 
key=0 ;           % key for random number generators
switch eD
  case 40
    key=key+0 ; 
  case 30
    key=key+1 ; 
  case 20
    key=key+2 ; 
  otherwise
    return ;
end
rng(key) ; 
fprintf(1,'Emitter distance: %d (nm) \n',eD) ; 
%% Optical system 
na=1.4 ; 
lambda=520 ;          % nm
a=2*pi*na/lambda ; 
% 2D Gaussian PSF; sigma is estimated from Airy PSF
sigma=1.3238/a ;      % = 78.26 nm
%% Frame 
% Region of view: [0,Lx]x[0,Ly]
Lx=2^11 ;
Ly=Lx ;               % frame size in nm
Dx=2^7 ; Dy=2^7 ;     % pixel size of cammera
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
M=200 ;               % # of emitters
t1=0:1/M:1-1/M ; 
D=(1000*t1).^0.96+48 ;% nm, distance from emitters to origin
xy=zeros(2,M) ;       % locations of 2D emitters 
theta1=2*pi*rand ;    % random initial angle and distance to origin
xy(:,1)=[(0+20*randn)*cos(theta1) ; (D(1)+20*randn)*sin(theta1)] ;
for i=2:M, 
  theta0=atan2(xy(2,i-1),xy(1,i-1)) ; % angle of previous location
  d0=sqrt(xy(:,i-1)'*xy(:,i-1)) ;     % length of previous location
  d1m=D(i) ;                            % distance of current location
  Dtheta=acos((d0^2+d1m^2-eD^2)/(2*d0*d1m)) ; % angle increment from previous to current location
  theta1=theta0+Dtheta ;                % angle of current location
  xy(:,i)=[d1m*cos(theta1) ; d1m*sin(theta1)] ; 
end
xy=xy+[Lx/2 ; Ly/2]*ones(1,M) ; % adjust to the frame center 
xy0=xy' ;                         % ground truth emitter locaitons 
filename_xy0=strcat('MEMF_2DGauss_eD',num2str(eD),'nm_xy0','.txt') ; 
save(filename_xy0,'-ascii','xy0') ;

%% emitters located on a circle with equal distance
% M=150 ; % # of emitters
% Dd=40 ; % nm, distance between adjacent emitters 
% rd=Dd/(2*sin(pi/M)) ; % radius
% theta=2*pi*(0:M-1)/M ; 
% xy=[rd.*cos(theta)+Lx/2 ; rd.*sin(theta)+Ly/2] ; 

%% Emitter activations
Nape=10 ;   % average number of activations per emitter in data movie
J=4 ;       % Maximum state
r00=0.96 ;  % (1-p0)*M=15.7
r01=0.5 ;   r02=0.7 ;   r03=0.8 ;   r04=1.0 ; 
r10=1-r00 ; r21=1-r01 ; r32=1-r02 ; r43=1-r03 ;  
R=[r00 r01 r02 r03 r04 % matrix of state transition probabilities
   r10 0   0   0   0
   0   r21 0   0   0
   0   0   r32 0   0
   0   0   0   r43 0] ;
den=1+r10+r10*r21+r10*r21*r32+r10*r21*r32*r43 ; 
p0=1/den ;  % probability of de-activation
            % Average # of activated emitters/frame: M*(1-p0)=12.59  
N=fix(Nape/(1-p0)) ; % =158, # of frames in data movie
N=150 ;     % corresponding Nape=9.45 
c0=zeros(M,N+1) ; % states of Markov chains in data movie
for n=2:N+1
  for m=1:M
    c0(m,n)=(c0(m,n-1)+1)*(1-(rand<R(1,c0(m,n-1)+1))) ; % state transitions
  end
end
c=c0(:,2:N+1) ;         % remove initial all-0 state

%% Generate and save a data movie
fprintf(1,'Generate a data movie: \n') ; 
a=(c~=0) ;    % a(m,n)=1 if activated; a(m,n)=0 otherwise  
Na=sum(a) ;   % number of activated emitters in nth frame
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
  U=Frame_2DGauss(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,G,mu,xyActive(:,1:p,n)) ;
  U16=uint16(U) ;
  filename_Frame=strcat('MEMF_2DGauss_eD',num2str(eD),'nm_Frame',num2str(n),'.tif') ;
  imwrite(U16,filename_Frame) ;       % save data frame
  if mod(n,10)==0
    fprintf(1,'eD=%2d N=%3d n=%3d Na=%d \n',eD,N,n,Na(n)) ;
  end
end

%% Read 10th data frame
Fig=figure('Position',[400 200 400 400],'Color',[1 1 1]) ;
filename_Frame=strcat('MEMF_2DGauss_eD',num2str(eD),'nm_Frame',num2str(10),'.tif') ;
U16=imread(filename_Frame); % read 10th data frame 
U=double(U16) ; 
show8bimage(U,'Yes','gray','No') ;  % show data frame

%% Save 10th data frame as a 8-bit PNG for show
Umax=max(max(U)) ; Umin=min(min(U)) ; 
U8=upsample2D(8,8,U) ;
U88=uint8(255*(U8-Umin)/(Umax-Umin)) ;
filename_Frame=strcat('MEMF_2DGauss_eD',num2str(eD),'nm_Frame',num2str(10),'.png') ;
imwrite(U88,filename_Frame) ; % save data frame 

%% Localization by the UGIA-M and UGIA-F estimators 
fprintf(1,'IAUG localization: \n') ; 
[xyM,xyF,FF,FF_]=UGIA_MF_2DGauss(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy,a) ;

%% show sequence
Fig=figure('Position',[400 50 600 600],'Color',[1 1 1]) ;
sft=0.07 ; 
xyFa=zeros(2,sum(Na)) ; 
RMSMD_M=zeros(1,N) ; 
RMSMD_F=zeros(1,N) ; 
pF=0 ;        % number of activated emitters from 1st to nth frames
Ia=uint8(zeros(M,1)) ;   % indices of activated emitter of a movie
for n=1:N
  % 
  Figa=subplot(2,2,1) ;
  whitebg([0 0 0]) ;
  show8bNanoscopyImage(xy,Lx,Ly,1,1,7,'Yes','gray','No') ; hold on
  plot(xyActive(1,1:Na(n),n),xyActive(2,1:Na(n),n),'r.') ;
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
  if Na(n)>0
    V=Frame_2DGauss(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,G,mu,xyActive(:,1:Na(n),n)) ;
  else
    V=zeros(Ky,Kx) ;
  end
  show8bimage(V,'Yes','gray','No') ;
  text(1,15.5,compose('TR=%5.2f (sec)',Dt*n),'Color','white') %,'FontSize',8)
  axis off
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  set(Figb,'OuterPosition',[0.5-(1-0.25)*sft+0.0115,0.5-(1-0.25)*sft+0.005,0.5+1.25*sft,0.5+1.25*sft]);
%
  Figc=subplot(2,2,3) ; % show current estimated locations
  Ia=(Ia | a(:,n)) ;
  pM=sum(Ia) ;    % # of emitters that were activated at least once in frames 1 to  n 
  show8bNanoscopyImage(xyM(:,1:pM,n),Lx,Ly,1,1,7,'Yes','gray','No') ;
  [RMSMD_M(n),~]=RMSMD(xyM(:,1:pM,n),xy) ;
  text(0.5*Dx,1*Dy,'UGIA-M','Color','white') %,'FontSize',8)
  text(0.5*Dx,15*Dy,compose('RMSMD=%4.1f (nm)',RMSMD_M(n)),'Color','white') %,'FontSize',8)
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  axis off
  set(Figc,'OuterPosition',[-sft,-sft+0.01,0.5+1.25*sft,0.5+1.25*sft]);
%
  Figd=subplot(2,2,4) ; % show all estimated locations
  xyFa(:,pF+1:pF+Na(n))=xyF(:,1:Na(n),n) ; 
  pF=pF+Na(n) ;         % # of locations in frames 1 to n
  [RMSMD_F(n),~]=RMSMD(xyFa(:,1:pF),xy) ;
  show8bNanoscopyImage(xyFa(:,1:pF),Lx,Ly,1,1,7,'Yes','gray','No') ; 
  text(0.5*Dx,1*Dy,'UGIA-F','Color','white') %,'FontSize',8)
  text(0.5*Dx,15*Dy,compose('RMSMD=%4.1f (nm)',RMSMD_F(n)),'Color','white') %,'FontSize',8)
  set(gca,'XTick',[]) ; % Turn off X and Y ticks
  set(gca,'YTick',[]) ;
  axis off
  set(Figd,'OuterPosition',[0.5-(1-0.25)*sft+0.0115,-sft+0.01,0.5+1.25*sft,0.5+1.25*sft]);
  getframe(gcf) ;
  fprintf(1,'eD=%2d N=%3d n=%3d pM=%d pF=%d \n',eD,N,n,pM,pF) ;
end

%% Show RMSMDs
figure
whitebg([1 1 1]) ;
lg=loglog(Dt*(1:N),RMSMD_M,'r-',Dt*(1:N),RMSMD_F,'k-') ;
legend(lg,'UGIA-M','UGIA-F') ; 
ylabel('RMSMD (nm)') ; 
xlabel('Temporal resolution (s)') ; 

%% Results: RMSMD vs emitter distance 
% M=200; N=150 
% Distance: 40      30      20      Average (nm)
% UGIA-M:   3.96    4.08    3.82    3.95
% UGIA-F:   15.97   26.11   75.28   39.12
% Average RMSMD-M: mean([3.96 4.08 3.82])=3.95 (nm) 
% Average RMSMD-F: mean([15.97 26.11 75.28])=39.12 (nm)
