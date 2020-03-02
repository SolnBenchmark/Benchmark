% [xyF,F,F_]=Airy2D_UGIA_F(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy)
%
% Produce a 2D SOLN image by the UGIA-F estimator and its covariance
% matrix with a 2D Airy PSF
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
%           xy can be empty, i.e. xy=[]
%
% Output:
% xyF     - zeros(2,M), emitter locations estimated by UGIA-F estimator 
% F       - zero(2*M,2*M), Fisher information matrix 
% F_      - zero(2*M,2*M), inverse of F 
%
% Note: (1) All distances are in nm 
%       (2) Gaussian noise is approximated by Poisson noise
%       (3) Gaussian noise mean is ignored
%
% Reference
% [1] Sun, Y. Localization precision of stochastic optical localization
% nanoscopy using single frames. J. Biomed. Optics 18, 111418.1-15 (2013)
% [2] Y. Sun, "Root mean square minimum distance as a quality metric for
% stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, 
% no. 1, pp. 17211, Nov. 2018.
%
% Yi Sun
% 02/22/2020

function [xyF,F,F_]=Airy2D_UGIA_F(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) 

[~,M]=size(xy) ;
if M<1
  xyF=[] ; F=[] ; F_=[] ; 
  fprintf(1,'# of emitter is zero. \n') ;
  return ;
end
F=Airy2D_Fisher(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) ; 
F_=pinv(F) ;
% UGIA-F estimator
xyF=zeros(2,M) ; 
[U,L,~]=svd(F_) ;
W=U*L.^0.5*randn(2*M,1) ;       % error vector achieving Fisher information F
for i=1:M
  i1=2*(i-1)+1 ; i2=2*(i-1)+2 ; 
  error=W(i1:i2) ;              % error vector for ith emitter
  xyF(:,i)=xy(:,i)+error ;      % location estimated by UGIA_F estimator
end

end
