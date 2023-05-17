% 计算精确解
syms a b x;
% 位移条件x=0,13:y=0; x=3:y=a; x=7:y=b 
y1=dsolve('D2y1=5/6000','y1(0)=0.0','y1(3)=a','x');
y2=dsolve('D2y2=10/6000','y2(3)=a','y2(7)=b','x');
y3=dsolve('D2y3=8/6000','y3(7)=b','y3(13)=0.0','x');
% 一阶导数连续条件 x=3:y'-=y'+; x=7:y'-=y'+
S=solve(subs(diff(y1),x,3)==subs(diff(y2),x,3),subs(diff(y2),x,7)==subs(diff(y3),x,7),a,b);
x1=0:0.2:3;
x2=3:0.2:7;
x3=7:0.2:13;

load XORD_1.txt -ASCII
load U_1.txt -ASCII
load XORD_2.txt -ASCII
load U_2.txt -ASCII
load XORD_3.txt -ASCII
load U_3.txt -ASCII

plot([x1 x2 x3],[subs(y1,{a,x},{S.a,x1}) subs(y2,{a,b,x},{S.a,S.b,x2}) subs(y3,{b,x},{S.b,x3})],'r-',XORD_1,U_1,XORD_2,U_2,XORD_3,U_3)
xlim([0 13]);
xlabel('Distance along wire');
ylabel('Deflection of wire');
legend('Exact Solution','7 Elements','13 Elements','3 Elements')
title('Deflection of a tightly stretched wire');
