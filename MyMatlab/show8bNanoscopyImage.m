% img=show8bNanoscopyImage(XY,Lx,Ly,Dx,Dy,sigma,rescale,color,addColormap)
%
% show 8 bit nanocopy image of emitter locations using Gaussian shape 
%		
%	Input:	XY      -	Each column is an emitter location, (x,y)' 
%                   XY=[] is allowed
%         Lx, Ly  - Image size in nm
%         Dx, Dy  - Pixel sizes in nm
%         sigma   - nm, STD of a Gaussian spot 
%					rescale	- ='Yes': The image is scaled to the full range of 8 bits = {0,2^8-1} before shown
%										otherwise:	The image is shown as is.
%         color   - ='gray', the 'gray' colormap is used 
%                 - Otherwise, 'jet' colormap is used
%    addColormap  - ='No', no colormap is added to image
%                 - Otherwise, colormap is added to image
% Output: img     - Nanoscopy image 
%
% Yi Sun
% 10/31/2013, 5/3/2018
% Modified from show8bSTORMimage(XY,Lx,Ly,Dx,Dy,sigma)

function img=show8bNanoscopyImage(XY,Lx,Ly,Dx,Dy,sigma,rescale,color,addColormap)

[D N]=size(XY) ;
Kx=fix(Lx/Dx) ; Ky=fix(Ly/Dy) ; % size of image in pixels
img=zeros(Ky,Kx) ;
if N==0,                        % no emitter 
  show8bimage(img,'No',color,addColormap) ;
  return ;
end
Mx=ceil(3*sigma/Dx) ; My=ceil(3*sigma/Dy) ;
x=Dx*(-Mx:Mx) ; y=Dy*(-My:My) ;
PSF=exp(-y.^2/(2*sigma^2))'*exp(-x.^2/(2*sigma^2)) ;
A=PSF/sum(sum(PSF)) ;
[Ay Ax]=size(A) ; Ay=(Ay-1)/2 ; Ax=(Ax-1)/2 ;
for m=1:N,
  ky=fix(XY(2,m)/Dy)+1 ; kx=fix(XY(1,m)/Dx)+1 ;
  if ky-Ay>=1 && ky+Ay<=Ky && kx-Ax>=1 && kx+Ax<=Kx,
    for r=-Ay:Ay,
      for c=-Ax:Ax,
        img(ky+r,kx+c)=max(img(ky+r,kx+c),A(r+Ay+1,c+Ax+1)) ;
      end
    end
  end
end
show8bimage(img,rescale,color,addColormap) ;

end

