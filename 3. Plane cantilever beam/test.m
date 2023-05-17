R=2;
nx=4;ny=4;
xcord=zeros(1,nx-1);
a=zeros(1,nx-1);b=zeros(1,nx-1);c=zeros(1,nx-1);d=zeros(1,nx-1);
p=0;q=1;
theta=(logspace(p,q,nx+1)-10^p)/(10^q-10^p);
for i=1:nx-1
    x1=R/nx*i;y1=0;
    x2=0;y2=R;
%     M=[y1^2,y1,1;y2^2,y2,1;2*y1,1,0;];
%     N=[x1;x2;0];
    M=[y1^3,y1^2,y1,1;y2^3,y2^2,y2,1;3*y1^2,2*y1,1,0;3*y2^2,2*y2,1,0];
    N=[x1;x2;0;-tan(pi/2*theta(i+1))];
    xishu=M\N;
    a(i)=xishu(1);b(i)=xishu(2);c(i)=xishu(3);d(i)=xishu(4);
end
aa=zeros(1,ny-1);bb=zeros(1,ny-1);cc=zeros(1,ny-1);
for i=1:ny-1
    x1=0;y1=R/ny*i;
    x2=R*cos(pi/2/ny*i);y2=R*sin(pi/2/ny*i);
    M=[x1^2,x1,1;x2^2,x2,1;2*x1,1,0];
    N=[y1;y2;0];
    xishu=M\N;
    aa(i)=xishu(1);bb(i)=xishu(2);cc(i)=xishu(3);
end

y=0:0.1:R;
x=sqrt(R^2-y.^2);
xx=zeros(1,R/0.1+1);
plot(xx,y,x,y)
hold on
for i=1:nx-1
    x=a(i)*y.^3+b(i)*y.^2+c(i)*y+d(i);
    plot(x,y)
    axis equal
    hold on
end
x=0:0.1:R;
for i=1:ny-1
    y=aa(i)*x.^2+bb(i)*x+cc(i);
    plot(x,y)
    hold on
end

% 11111
AA=[];
eps=1e-8;
for i=1:nx-1
    y=R:-0.001:0;
    x=a(i)*y.^3+b(i)*y.^2+c(i)*y+d(i);
    for j=1:ny-1
        xx=0:0.001:R;
        yy=aa(j)*xx.^2+bb(j)*xx+cc(j);
        d=yy./(y+eps);
        ix=find(d>0.99 & d<1.02);
        x1=xx(ix(1));
        y1=aa(j)*x1.^2+bb(j)*x1+cc(j);
        plot(x1,y1,'rx')
        hold on
    end
end
