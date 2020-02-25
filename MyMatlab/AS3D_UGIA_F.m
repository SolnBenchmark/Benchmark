% [xyzF,F,F_]=AS3D_UGIA_F(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz) 
%
% Produce a 3D SOLN image by the UGIA-F estimator and its covariance
% matrix with a 3D astigmatic PSF
% 
% Input:
% c       - z offset when x or y reaches its own focal plane with minimum width
% d       - microscope depth
% sigmax0 - PSF average xy width (equal in x, y) at focal plane (z=-c). 
%						Note: sigma0=w0/2 in Zhuang's papers
% Ax, Bx	- coefficient of higher order of sigmax
% sigmay0 - PSF average xy width (equal in x, y) at focal plane (z=c). 
%							Note: sigma0=w0/2 in Zhuang's papers
% Ay, By	- coefficient of higher order of sigmay
%	Kx, Ky	- Image size is Ky*Kx in pixels
%     			sample is located at [0,Kx*Dx]x[0,Ky*Dy]x[-Lz,Lz] 
%	Dx, Dy	- Pixel size is Dx*Dy square nanometers (nm^2)
% Dt   		- imaging time in second
% Ih		  - Number of detected photons per second from one emitter 
% b       - Mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
% G       - Variance of Gaussian noise (photons/s/nm^2)  
% xyz     - zero(3,M), ith colume of xyz is (x,y,z) coordinates of ith emitter
%           location out of M emitters
%
% Output:
% xyzF    - zeros(3,M), emitter locations estimated by UGIA-F estimator 
% F       - zero(3*M,3*M), Fisher information matrix 
% F_      - zero(3*M,3*M), inverse of F 
%
% Note: (1) All distances are in nm 
%       (2) Gaussian noise is approximated by Poisson noise
%       (3) Gaussian noise mean is ignored
%
% Reference
% [1] Sun, Y. Localization precision of stochastic optical localization
% nanoscopy using single frames. J. Biomed. Optics 18, 111418.1-15 (2013)
%
% Yi Sun
% 2/16/2020

function [xyzF,F,F_]=AS3D_UGIA_F(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz) 

[~,M]=size(xyz) ;
if M<1
  fprintf(1,'# of dyes is zero. \n') ;
  return ;
end
F=AS3D_Fisher(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz) ;
F_=pinv(F) ;
% UGIA-F estimator
xyzF=zeros(3,M) ; 
[U,L,~]=svd(F_) ;
W=U*L.^0.5*randn(3*M,1) ;       % error vector achieving Fisher information F
for i=1:M
  i1=3*(i-1)+1 ; i3=3*(i-1)+3 ; 
  error=W(i1:i3) ;              % error vector for ith emitter
  xyzF(:,i)=xyz(:,i)+error ;   % location estimated by UGIA_F estimator
end

end
