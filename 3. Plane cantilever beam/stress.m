
% =================     
% ROUTINE stress.m
% =================     

   NNPE2=2*NNPE;
   NUMEQ=NUMNP;

   for I=1:NUMNP
      SIGXX(I)=0.0;
      SIGXY(I)=0.0;
      SIGYY(I)=0.0;
      SIGZZ(I)=0.0;
      SGEFF(I)=0.0;
      SMAX(I)=0.0;
      SKD(I)=0.0; 
   end

   for I=1:NUMEL
     
%     ------------------------------ 
%     Begin calculation of strain
%     and stress at each quadrature 
%     point in each element.
%     ------------------------------ 
      JEND=NUMQPT(1);
      for J=1:JEND 
         XJ       =0.0; 
         YJ       =0.0;
         RJAC(1,1)=0.0;
         RJAC(1,2)=0.0;
         RJAC(2,1)=0.0;
         RJAC(2,2)=0.0;

         for K=1:NNPE 
            NPK=NP(I,K); 
            XJ = XJ + SF(1,K,J)*XORD(NPK);
            YJ = YJ + SF(1,K,J)*YORD(NPK);
            RJAC(1,1)=RJAC(1,1) + SF(2,K,J)*XORD(NPK);
            RJAC(1,2)=RJAC(1,2) + SF(3,K,J)*XORD(NPK);
            RJAC(2,1)=RJAC(2,1) + SF(2,K,J)*YORD(NPK);
            RJAC(2,2)=RJAC(2,2) + SF(3,K,J)*YORD(NPK);
         end

         DETJ=RJAC(1,1)*RJAC(2,2) - RJAC(2,1)*RJAC(1,2);
        if DETJ <= 0.0
           error
        end

        RJACI(1,1)=+RJAC(2,2)/DETJ;
        RJACI(1,2)=-RJAC(1,2)/DETJ;
        RJACI(2,1)=-RJAC(2,1)/DETJ;
        RJACI(2,2)=+RJAC(1,1)/DETJ;

        for K=1:NNPE 
           DNDX(K)=RJACI(1,1)*SF(2,K,J) + RJACI(2,1)*SF(3,K,J); 
           DNDY(K)=RJACI(1,2)*SF(2,K,J) + RJACI(2,2)*SF(3,K,J); 
        end

%       ------------------------------------ 
%       Include user written COEF.m code
%       ------------------------------------ 
        COEF

%       --------------------------------- 
%       Determine R-matrix corresponding
%       to analysis being performed
%       --------------------------------- 
%       IPROG = 1    PLANE STRAIN ELASTICITY 
%       IPROG = 2    PLANE STRESS ELASTICITY 
%       ------------------------------------ 
        if IPROG == 1        
           R(1,1)=2.0*G+LAMBDA;
           R(2,2)=R(1,1); 
           R(3,3)=G;
           R(1,2)=LAMBDA;
           R(2,1)=LAMBDA;
           Mu = LAMBDA/(2*(LAMBDA+G));
        elseif IPROG == 2
           R(1,1)=4.0*G*(G+LAMBDA)/(2.0*G+LAMBDA);
           R(1,2)=2.0*G*LAMBDA/(2.0*G+LAMBDA);
           R(2,1)=R(1,2);
           R(2,2)=R(1,1);
           R(3,3)=G;
           Mu = LAMBDA/(2*(LAMBDA+G));
        end

%       --------------------------------
%       CALCULATE CONTRIBUTION TO RHS 
%       FOR STRESS
%       --------------------------------
        EPXX=0.0;
        EPXY=0.0;
        EPYY=0.0;
        for K=1:NNPE 
           KY=NP(I,K)*2;
           KX=KY-1;
           UXK=U(KX);
           UYK=U(KY);
           EPXX=EPXX+DNDX(K)*UXK;
           EPYY=EPYY+DNDY(K)*UYK;
           EPXY=EPXY+(DNDY(K)*UXK+...
                      DNDX(K)*UYK)/2.0; 
        end

        SGXX=R(1,1)*EPXX+R(1,2)*EPYY;
        SGYY=R(2,1)*EPXX+R(2,2)*EPYY;
        SGXY=2.0*R(3,3)*EPXY;

        if IPROG == 1
           SGZZ=Mu*(SGXX+SGYY);
        else
           SGZZ=0;
        end

        for K=1:NNPE 
           NPK=NP(I,K);
           XK=XORD(NPK);
           YK=YORD(NPK);
           wght=(XK-XJ)^2 + (YK-YJ)^2;
           wght=1.0/(sqrt(wght));
           SIGXX(NPK)=SIGXX(NPK)+wght*SGXX;
           SIGYY(NPK)=SIGYY(NPK)+wght*SGYY;
           SIGXY(NPK)=SIGXY(NPK)+wght*SGXY;
           SIGZZ(NPK)=SIGZZ(NPK)+wght*SGZZ;
           SKD(NPK)=SKD(NPK)+wght;
        end
     end
%    ---------   end of volume quadrature
   end
%  ---------   end of element loop


% ----------------------------------
% Solve for nodal values of stress
% components by dividing by diagonal
% ----------------------------------
   for I=1:NUMNP
     SIGXX(I)=SIGXX(I)/SKD(I);
     SIGYY(I)=SIGYY(I)/SKD(I);
     SIGXY(I)=SIGXY(I)/SKD(I);
     SIGZZ(I)=SIGZZ(I)/SKD(I);
   end

% --------------------------------
%  Calculate nodal point value of 
%  effective stress 
% --------------------------------
   for I=1:NUMNP
      XX=SIGXX(I);
      YY=SIGYY(I);
      XY=SIGXY(I);
      ZZ=SIGZZ(I);
      XP=XORD(I);
      YP=YORD(I);
 
      SG=((XX-YY)^2 +(YY-ZZ)^2 ...
         +(ZZ-XX)^2 +6.0*XY^2);

      SGEFF(I)=sqrt(SG/2.0);
      SMAX(I)=sqrt((XX-YY)^2/4+XY^2);
   end


