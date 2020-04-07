% F=AS3D_Fisher(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz)
%
% Calculate Fisher information matrix of 3D emitters from a data frame with 
% an astigmatic PSF. 
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
% F       - zero(3*M,3*M), Fisher information matrix of M activeated emitters 
%           in a data frame
%
% Note: (1) All distances are in nm 
%       (2) Gaussian noise is approximated by Poisson noise
%       (3) Gaussian noise mean is ignored
%
% Modifed from: CRLB3DGaussPSF.m
%
% Reference
% [1] Sun, Y. Localization precision of stochastic optical localization
% nanoscopy using single frames. J. Biomed. Optics 18, 111418.1-15 (2013)
%
% Yi Sun
% 2/16/2020

function F=AS3D_Fisher(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xyz) 

[~,M]=size(xyz) ;
if M<1
  fprintf(1,'# of dyes is zero. \n') ;
  return ;
end
r=Ih/(b+G) ;  % total SNR (nm^2/emitter) 
Q=zeros(Kx,Ky) ; 
F0=@(x)(x.^2-1).*exp(-x.^2/2) ;	% function
qx=zeros(M,Kx) ;    qy=zeros(M,Ky) ;
DqxDx=zeros(M,Kx) ; DqyDy=zeros(M,Ky) ; 
DqxDz=zeros(M,Kx) ; DqyDz=zeros(M,Ky) ; 
kx=0:Kx-1 ; ky=0:Ky-1 ; 
if M>200
  fprintf(1,'Step 1 ... \n') ;
end
for i=1:M
  if (M>200)&&(mod(i,100)==0||i==1)
    fprintf(1,'M=%3d  m=%3d\n',M,i) ;
  end
  z=xyz(3,i) ;
	sigmay=sigmay0*(1+(z-c).^2/d^2+Ay*(z-c).^3/d^3+By*(z-c).^4/d^4).^0.5 ;
	sigmax=sigmax0*(1+(z+c).^2/d^2+Ax*(z+c).^3/d^3+Bx*(z+c).^4/d^4).^0.5 ;  
	Dxk1=(Dx*(kx+1)-xyz(1,i))/sigmax ; Dxk0=(Dx*kx-xyz(1,i))/sigmax ; 
	Dyk1=(Dy*(ky+1)-xyz(2,i))/sigmay ; Dyk0=(Dy*ky-xyz(2,i))/sigmay ; 
	qx(i,:)=(Qfunc(-Dxk1)-Qfunc(-Dxk0))/Dx ;
	qy(i,:)=(Qfunc(-Dyk1)-Qfunc(-Dyk0))/Dy ;
	Q=Q+qy(i,:)'*qx(i,:) ;
% these two lines seem repitition and redundent
	Dxk1=(Dx*(kx+1)-xyz(1,i))/sigmax ; Dxk0=(Dx*kx-xyz(1,i))/sigmax ; 
	Dyk1=(Dy*(ky+1)-xyz(2,i))/sigmay ; Dyk0=(Dy*ky-xyz(2,i))/sigmay ; 
%
  DqxDx(i,:)=(1/Dx)*(-exp(-Dxk1.^2/2)+exp(-Dxk0.^2/2))/(sqrt(2*pi)*sigmax) ;
	DqyDy(i,:)=(1/Dy)*(-exp(-Dyk1.^2/2)+exp(-Dyk0.^2/2))/(sqrt(2*pi)*sigmay) ;
  Dsigmax2Dz=sigmax0^2*(2*(z+c)/d^2+3*Ax*(z+c)^2/d^3+4*Bx*(z+c)^3/d^4) ; 
  Dsigmay2Dz=sigmay0^2*(2*(z-c)/d^2+3*Ay*(z-c)^2/d^3+4*By*(z-c)^3/d^4) ; 
	for j=1:Kx
    DqxDz(i,j)=(Dsigmax2Dz/(2*Dx*sigmax^2*sqrt(2*pi)))*integral(F0,Dxk0(j),Dxk1(j)) ;
	end
	for j=1:Ky
    DqyDz(i,j)=(Dsigmay2Dz/(2*Dy*sigmay^2*sqrt(2*pi)))*integral(F0,Dyk0(j),Dyk1(j)) ;
	end
end
Qu=Q+1/r ;          % Gaussian noise is approximated as Poisson noise 
if r==inf 
  Qu=Qu+1e-10 ;     % add 1e-10 to avoid 0/0=NaN 
end
F=zeros(3*M,3*M) ;	% Fisher information matrix: x1, y1, z1, x2, y2, z2, ...
if M>200
  fprintf(1,'Step 2 ... \n') ;
end
for i=1:M	% 
  if (M>200)&&(mod(i,100)==0||i==1)
    fprintf(1,'M=%3d  m=%3d\n',M,i) ;
  end
	qyDqxDxi=qy(i,:)'*DqxDx(i,:) ; 
	DqyDyqxi=DqyDy(i,:)'*qx(i,:) ;
	qyDqxDzi=qy(i,:)'*DqxDz(i,:) ;
	DqyDzqxi=DqyDz(i,:)'*qx(i,:) ;	
	for j=i:M
		qyDqxDxj=qy(j,:)'*DqxDx(j,:) ;
		DqyDyqxj=DqyDy(j,:)'*qx(j,:) ;
		qyDqxDzj=qy(j,:)'*DqxDz(j,:) ;
		DqyDzqxj=DqyDz(j,:)'*qx(j,:) ;
% F(xi,:)
		F(3*(i-1)+1,3*(j-1)+1)=sum(sum(qyDqxDxi.*qyDqxDxj./Qu)) ;	% F(xi, xj)
		F(3*(j-1)+1,3*(i-1)+1)=F(3*(i-1)+1,3*(j-1)+1) ;						% F(xj, xi)
		F(3*(i-1)+1,3*(j-1)+2)=sum(sum(qyDqxDxi.*DqyDyqxj./Qu)) ;	% F(xi, yj)
		F(3*(j-1)+2,3*(i-1)+1)=F(3*(i-1)+1,3*(j-1)+2) ;						% F(yj, xi)
		F(3*(i-1)+1,3*(j-1)+3)=sum(sum(qyDqxDxi.*(qyDqxDzj+DqyDzqxj)./Qu)) ;	% F(xi, zj)
		F(3*(j-1)+3,3*(i-1)+1)=F(3*(i-1)+1,3*(j-1)+3) ;						% F(zj, xi)
% F(yi,:)
		F(3*(i-1)+2,3*(j-1)+1)=sum(sum(DqyDyqxi.*qyDqxDxj./Qu)) ;	% F(yi, xj)
		F(3*(j-1)+1,3*(i-1)+2)=F(3*(i-1)+2,3*(j-1)+1) ;						% F(xj, yi)
		F(3*(i-1)+2,3*(j-1)+2)=sum(sum(DqyDyqxi.*DqyDyqxj./Qu)) ;	% F(yi, yj)
		F(3*(j-1)+2,3*(i-1)+2)=F(3*(i-1)+2,3*(j-1)+2) ;						% F(yj, yi)
		F(3*(i-1)+2,3*(j-1)+3)=sum(sum(DqyDyqxi.*(qyDqxDzj+DqyDzqxj)./Qu)) ;	% F(yi, zj)
		F(3*(j-1)+3,3*(i-1)+2)=F(3*(i-1)+2,3*(j-1)+3) ;						% F(zj, yi)
% F(zi,:)
		F(3*(i-1)+3,3*(j-1)+1)=sum(sum((qyDqxDzi+DqyDzqxi).*qyDqxDxj./Qu)) ;	% F(zi, xj)
		F(3*(j-1)+1,3*(i-1)+3)=F(3*(i-1)+3,3*(j-1)+1) ;						% F(xj, zi)
		F(3*(i-1)+3,3*(j-1)+2)=sum(sum((qyDqxDzi+DqyDzqxi).*DqyDyqxj./Qu)) ;	% F(zi, yj)
		F(3*(j-1)+2,3*(i-1)+3)=F(3*(i-1)+3,3*(j-1)+2) ;						% F(yj, zi)
		F(3*(i-1)+3,3*(j-1)+3)=sum(sum((qyDqxDzi+DqyDzqxi).*(qyDqxDzj+DqyDzqxj)./Qu)) ;	% F(zi, zj)
		F(3*(j-1)+3,3*(i-1)+3)=F(3*(i-1)+3,3*(j-1)+3) ;						% F(zj, zi)
	end
end
F=Ih*Dt*Dx*Dy*F ; 

end
