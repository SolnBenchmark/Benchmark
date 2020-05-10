% [xyzM,xyzF]=AS3D_UGIA_MF(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz,a) 
%
% Produce 3D SOLN images by the UGIA-M and UGIA-F estimators with a 3D astigmatic PSF. 
% 
% Input:
% c       - z offset when x or y reaches its own focal plane with minimum width
% d       - microscope depth
% sigmax0 - PSF average xy width (equal in x, y) at focal plane (z=-c). 
%						Note: sigma0=w0/2 in Zhuang's papers
% Ax, Bx	- coefficient of higher order of sigmax
% sigmay0 - PSF average xy width (equal in x, y) at focal plane (z=c). 
%						Note: sigma0=w0/2 in Zhuang's papers
% Ay, By	- coefficient of higher order of sigmay
%	Kx, Ky	- Frame size is Ky*Kx (pixels), specimen is located at [0,Kx*Dx]x[0,Ky*Dy]
%	Dx, Dy	- Pixel size is Dx*Dy (nm^2)
% Dt      - Frame time (s), frame rate = 1/Dt (frames/s) 
% Ih      - Mean number of detected photons (photons/s/emitter) 
% b       - Mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
% G       - Variance of Gaussian noise (photons/s/nm^2)  
% xyz     - zero(3,M), ith colume of xyz is (x,y,z) coordinates of ith emitter
%           location out of M emitters
% a       - zeros(M,N): M emitters and N frames. a(m,n)=1 if mth emitter is
%           activated in nth frame
%
% Output:
% xyzM    - zeros(3,M,N), xyzM(:,:,n) are estimated emitter locations by 
%           UGIA-M estimator for movie of frames 1 through n
% xyzF    - zeros(3,max(Na),N), xyzF(:,1:Na(n),n) are estimated emitter 
%           locations by UGIA-M estimator for frame n only where Na(n) is 
%           number of activated emitters
%
% Note: (1) All distances are in nm 
%       (2) Gaussian noise is approximated by Poisson noise
%       (3) Gaussian noise mean is ignored [1]
%
% Reference
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
% 03/07/2020, 05/08/2020

function [xyzM,xyzF]=AS3D_UGIA_MF(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz,a)

[M,N]=size(a) ; 
Na=sum(a) ;             % number of activated emitters in nth frame
xyzM=zeros(3,M,N) ; 
xyzF=zeros(3,max(Na),N) ; 
FF=zeros(3*M,3*M) ; 
FM=zeros(3*M,3*M) ;     % Fisher information matrix up to nth frame
xyzA=zeros(3,max(Na)) ; % activated emitter locations in nth frame
ma=zeros(1,M) ;         % index of activated emitters in a frame 
for n=1:N
  if mod(n,10)==0||n==1
    fprintf(1,'N=%3d n=%3d Na=%d \n',N,n,Na(n)) ;
  end
  if Na(n)==0           % no activated emitter in frame n
    xyzM(:,:,n)=xyzM(:,:,n-1) ; % xyzM(:,:,n) keep same
  else                  % Na(n)>=1, at least one emitter is activated
    p=0 ;
    for m=1:M
      if a(m,n)
        p=p+1 ;
        xyzA(:,p)=xyz(:,m) ;
        ma(p)=m ;       % mth emitter is actived in nth frame
      end
    end
    % Fisher information matrix for nth frame
    F=AS3D_Fisher(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyzA(:,1:p)) ;
    F_=pinv(F) ;        % Covariance matrix of UGIA-F estimator for frame n
    for k=1:p           % update Fisher information matrix of a movie
      km1=3*(ma(k)-1) ; k1=3*(k-1) ;
      for j=1:p
        jm1=3*(ma(j)-1) ; j1=3*(j-1) ;
        % Fisher information matrix of nth frame
        FF(km1+1,jm1+1)=F(k1+1,j1+1) ;
        FF(km1+1,jm1+2)=F(k1+1,j1+2) ;
        FF(km1+1,jm1+3)=F(k1+1,j1+3) ;
        FF(km1+2,jm1+1)=F(k1+2,j1+1) ;
        FF(km1+2,jm1+2)=F(k1+2,j1+2) ;
        FF(km1+2,jm1+3)=F(k1+2,j1+3) ;
        FF(km1+3,jm1+1)=F(k1+3,j1+1) ;
        FF(km1+3,jm1+2)=F(k1+3,j1+2) ;
        FF(km1+3,jm1+3)=F(k1+3,j1+3) ;
      end
    end
    % UGIA-M estimator
    FM=FM+FF ;                % Fisher information of data movie from frame 1 to n
    FM_=pinv(FM) ;            % covariance matrix of UGIA-M estimator
    [U,L,~]=svd(FM_) ;
    W=U*L.^0.5*randn(3*M,1) ; % error vector achieving Fisher information FM
    p1=0 ; 
    for i=1:M
      i1=3*(i-1)+1 ; 
      if FM(i1,i1)~=0         % ith emitter was activated at least once
        i2=3*(i-1)+3 ;
        error=W(i1:i2) ;              % error vector for ith emitter
        p1=p1+1 ;
        xyzM(:,p1,n)=xyz(:,i)+error ; % location estimated by UGIA_M
      end
    end
    % UGIA-F estimator 
    [U,L,~]=svd(F_) ; 
    W=U*L.^0.5*randn(3*p,1) ;         % error vector achieving Fisher information F
    for i=1:p
      i1=3*(i-1)+1 ; i2=3*(i-1)+3 ;
      error=W(i1:i2) ;                % error vector for ith emitter
      xyzF(:,i,n)=xyzA(:,i)+error ;   % location estimated by UGIA_F estimator
    end
  end
end

end
