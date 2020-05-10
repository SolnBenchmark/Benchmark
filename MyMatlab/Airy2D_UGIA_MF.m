% [xyM,xyF]=Airy2D_UGIA_MF(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy,a)
%
% Produce 2D SOLN images by the UGIA-M and UGIA-F estimators with a 2D Airy PSF. 
% 
% Input:
% na      - Numerical aperture
% lambda  - emission wavelength
%	Kx, Ky	- Frame size is Ky*Kx (pixels), specimen is located at [0,Kx*Dx]x[0,Ky*Dy]
%	Dx, Dy	- Pixel size is Dx*Dy (nm^2)
% Dt      - Frame time (s), frame rate = 1/Dt (frames/s) 
% Ih      - Mean number of detected photons (photons/s/emitter) 
% b       - Mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
% G       - Variance of Gaussian noise (photons/s/nm^2)  
% xy      - ith colume is 2D coordinate (x,y)' of ith emitter location
% a       - zeros(M,N): M emitters and N frames. a(m,n)=1 if mth emitter is
%           activated in nth frame
%
% Output:
% xyM     - zeros(2,M,N), xyM(:,:,n) are estimated emitter locations by 
%           UGIA-M estimator for movie of frames 1 through n. 
%           If Na(n)=0, then xyM(:,:,n)=xyM(:,:,n-1) keep the same. 
%           Na(n) is number of activated emitters in nth frame. 
% xyF     - zeros(2,max(Na),N), xyF(:,1:Na(n),n) are estimated emitter 
%           locations by UGIA-F estimator for frame n only. 
%           If Na(n)=0, then xyF(:,:,n)=zeros(2,M).
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
% 01/19/2020, 02/21/2020, 05/08/2020

function [xyM,xyF]=Airy2D_UGIA_MF(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy,a) 

[M,N]=size(a) ; 
Na=sum(a) ;             % number of activated emitters in nth frame
xyM=zeros(2,M,N) ; 
xyF=zeros(2,max(Na),N) ; 
FF=zeros(2*M,2*M) ; 
FM=zeros(2*M,2*M) ;     % Fisher information matrix up to nth frame
xyA=zeros(2,max(Na)) ;  % activated emitter locations in nth frame
ma=zeros(1,M) ;         % index of activated emitters in a frame 
for n=1:N
  if mod(n,10)==0||n==1
    fprintf(1,'N=%3d n=%3d Na=%d \n',N,n,Na(n)) ;
  end
  if Na(n)==0           % no activated emitter in frame n
    xyM(:,:,n)=xyM(:,:,n-1) ; % xyM(:,:,n) keep same 
  else                  % Na(n)>=1, at least one emitter is activated 
    p=0 ;
    for m=1:M
      if a(m,n)
        p=p+1 ;
        xyA(:,p)=xy(:,m) ;
        ma(p)=m ;       % mth emitter is actived in nth frame
      end
    end
    % Fisher information matrix for nth frame
    F=Airy2D_Fisher(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyA(:,1:p)) ;
    F_=pinv(F) ;        % Covariance matrix of UGIA-F estimator for frame n
    for k=1:p           % update Fisher information matrix of a movie
      km1=2*(ma(k)-1) ; k1=2*(k-1) ;
      for j=1:p
        lm1=2*(ma(j)-1) ; j1=2*(j-1) ;
        % Fisher information matrix of nth frame
        FF(km1+1,lm1+1)=F(k1+1,j1+1) ;
        FF(km1+1,lm1+2)=F(k1+1,j1+2) ;
        FF(km1+2,lm1+1)=F(k1+2,j1+1) ;
        FF(km1+2,lm1+2)=F(k1+2,j1+2) ;
      end
    end
    % UGIA-M estimator
    FM=FM+FF ;   % Fisher information of data movie from frames 1 to n
    FM_=pinv(FM) ;      % covariance matrix of UGIA-M estimator
    [U,L,~]=svd(FM_) ;
    W=U*L.^0.5*randn(2*M,1) ; % error vector achieving Fisher information FM
    p1=0 ; 
    for i=1:M
      i1=2*(i-1)+1 ; 
      if FM(i1,i1)~=0         % ith emitter was activated at least once
        i2=2*(i-1)+2 ;
        error=W(i1:i2) ;            % error vector for ith emitter
        p1=p1+1 ;
        xyM(:,p1,n)=xy(:,i)+error ; % location estimated by UGIA_M
      end
    end
    % UGIA-F estimator 
    [U,L,~]=svd(F_) ; 
    W=U*L.^0.5*randn(2*p,1) ;       % error vector achieving Fisher information F
    for i=1:p
      i1=2*(i-1)+1 ; i2=2*(i-1)+2 ;
      error=W(i1:i2) ;              % error vector for ith emitter
      xyF(:,i,n)=xyA(:,i)+error ;   % location estimated by UGIA_F estimator
    end
  end
end

end
