clear
format compact
figure(1)
clf
figure(2)
clf
trans = 10;
Npts = 20;              
x0=0.1; y0=0.1;             
a=1.2; b=0.4;              
xold=x0;
yold=y0; 
for jj=1:trans              
 xn=a-xold.^2+b*yold;
 yn=xold;
 xold=xn;yold=yn;
end 
x=zeros(Npts,1);
y=zeros(Npts,1);
x(1)=xn;
y(1)=yn;
 
for jj=1:Npts-1             
 x(jj+1)=a-x(jj)^2+b*y(jj);
 y(jj+1)=x(jj);
end
 
D = sparse(Npts,Npts);          
for jj=1:Npts
 for ii=jj+1:Npts
  dd = (x(ii)-x(jj))^2 + (y(ii)-y(jj))^2;
  D(ii,jj)=dd;
 end
end
D=sqrt(D);
 
rm = double(min(min(D+(1000*D==0))));
rM = double(max(max(D)));
rM = 2^ceil(log(rM)/log(2));
ndiv = floor(double(log(rM/rm)/log(2)));
nr = ndiv+1;
rvec=rM*2.^(-((1:nr)'-1));
Npairs=Npts*(Npts-1)/2;
 
Cr=[];                  
for jj=1:nr
 r = rvec(jj)
 N = (D<r & D>0);
 S = double(sum(sum(N)));
 Cr = [Cr; S/Npairs];
end
 
figure(2)
 
plot(rvec,Cr,'o-');        
hold on
xlabel('r');
ylabel('C(r)');
grid
 
discard=3;              
n1=discard+1;
n2=nr-discard;
inside=n1:n2;
xx=log(rvec)/log(2);
yy=log(Cr)/log(2);
xxx=xx(inside);
yyy=yy(inside);
 
[coeff,temp]=polyfit(xxx,yyy,1); 
Dc=coeff(1)
yfit=Dc*xx+coeff(2);
figure(1)
 
plot(xx,yy,'o-');
hold on
plot(xx,yfit,'r-');
axis tight
plot([xx(n1),xx(n1)],[-30,30],'k--');
plot([xx(n2),xx(n2)],[-30,30],'k--');
xlabel('log_2(r)');
ylabel('log_2(C(r))');
title(['D_c=',num2str(Dc)]);
grid

