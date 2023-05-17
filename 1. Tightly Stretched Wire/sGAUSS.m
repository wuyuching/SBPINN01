%--------------------------------
function Y = sGAUSS(A,F,neq,IB)
%--------------------------------
%  Solve [A]{Y} = {F} 
%  for banded symmetric matrices   
%-------------------------------
Idiag=1;
%-------------------------
% Begin forward elimination
%-------------------------
for I = 1:(neq-1) 
   Jend=neq;
   if Jend > I+(IB-1)
      Jend = I+(IB-1);
   end

   for J=(I+1):Jend
      Kc=J-I+1;
      Aji=A(I,Kc); 
      FAC=-Aji/A(I,Idiag);
      Kbgn=J;
      Kend=Jend;
      for K=Kbgn:Kend
         IKc=K-I+1; 
         JKc=K-J+1; 
         A(J,JKc)=A(J,JKc)+FAC*A(I,IKc);
      end
      F(J)=F(J)+FAC*F(I);
   end
end
%------------------------ 
% Begin back substitution 
%------------------------ 
Y(neq)=F(neq)/A(neq,Idiag);
for Iback=2:neq
   I=neq-Iback+1;
   Jend=neq;
   if Jend > I+IB-1
      Jend = I+IB-1;
   end
   for J=(I+1):Jend
      Jc = J-I+1;
      F(I)=F(I)-A(I,Jc)*Y(J); 
   end
   Y(I)=F(I)/A(I,Idiag); 
end