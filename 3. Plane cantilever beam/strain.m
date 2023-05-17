%==================
% ROUTINE strain.m
%==================
   NNPE2=2*NNPE;
   NUMEQ=2*NUMNP;
   
   for I=1:NUMNP;
      NI=NWLD(I);
      NIX=2*NI-1;
      NIY=NIX+1; 
      F(NIX)=XBC(I); 
      F(NIY)=YBC(I); 
   end

%  ------------------------------- 
%  FORMATION OF ELEMENT S-MATRICES 
%  -------------------------------- 
   for I=1:NUMEL

      for J=1:NNPE2
         FE(J)=0.0;
         for K=1:NNPE2
            SE(J,K)=0.0; 
         end
      end

      for J=1:NNPE 
         NPJ=NWLD(NP(I,J)); 
         NPE(J)=NPJ*2-1;
         J1=J+NNPE; 
         NPE(J1)=NPJ*2; 
      end

%     ------------------------
%     BEGIN VOLUME QUADRATURE 
%     ------------------------
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
            RJAC(1,1)=RJAC(1,1)+SF(2,K,J)*XORD(NPK); 
            RJAC(1,2)=RJAC(1,2)+SF(3,K,J)*XORD(NPK); 
            RJAC(2,1)=RJAC(2,1)+SF(2,K,J)*YORD(NPK); 
            RJAC(2,2)=RJAC(2,2)+SF(3,K,J)*YORD(NPK); 
         end
         DETJ=RJAC(1,1)*RJAC(2,2)- ...
              RJAC(2,1)*RJAC(1,2);

         if DETJ <= 0.0
            error
         end

         RJACI(1,1)=+RJAC(2,2)/DETJ;
         RJACI(1,2)=-RJAC(1,2)/DETJ;
         RJACI(2,1)=-RJAC(2,1)/DETJ;
         RJACI(2,2)=+RJAC(1,1)/DETJ;

         for K=1:NNPE 
            DNDX(K)=RJACI(1,1)*SF(2,K,J)+ ...
                    RJACI(2,1)*SF(3,K,J); 
            DNDY(K)=RJACI(1,2)*SF(2,K,J)+ ...
                    RJACI(2,2)*SF(3,K,J); 
         end
%        --------------------------------            
%        Include user written COEF.m code
%        --------------------------------            
         COEF

         if IPROG == 1
            % Plane strain
            R(1,1)=2.0*G+LAMBDA;
            R(2,2)=R(1,1); 
            R(3,3)=G; 
            R(1,2)=LAMBDA; 
            R(2,1)=LAMBDA;
         elseif IPROG == 2 
            % Plane stress
            R(1,1)=4.0*G*(G+LAMBDA)/(2.0*G+LAMBDA);
            R(1,2)=2.0*G*LAMBDA/(2.0*G+LAMBDA);
            R(2,1)=R(1,2); 
            R(2,2)=R(1,1); 
            R(3,3)=G; 
         end

%        ---------------------------------
%        CALCULATE QUADRATURE CONTRIBUTION 
%        TO SE-MATRIX
%        ---------------------------------
         for K=1:NNPE 
            SFK=SF(1,K,J);
            K1=K;
            K2=K+NNPE; 
            for L=1:NNPE 
               L1=L;
               L2=L+NNPE; 
 
               SE(K1,L1)=SE(K1,L1)+WT(1,J)...
                       *(DNDX(K)*R(1,1)*DNDX(L)... 
                        +DNDY(K)*R(3,3)*DNDY(L))*DETJ; 
 
               SE(K1,L2)=SE(K1,L2)+WT(1,J)...
                       *(DNDX(K)*R(1,2)*DNDY(L)... 
                        +DNDY(K)*R(3,3)*DNDX(L))*DETJ; 
 
               SE(K2,L2)=SE(K2,L2)+WT(1,J)...
                        *(DNDY(K)*R(2,2)*DNDY(L)... 
                        + DNDX(K)*R(3,3)*DNDX(L))*DETJ; 
 
               SE(L2,K1)=SE(K1,L2); 
            end
 

   
            FE(K1)=FE(K1)+WT(1,J)*SFK*GAMX*DETJ;
            FE(K2)=FE(K2)+WT(1,J)*SFK*GAMY*DETJ;
         end
      end
%     -----------    end of volume quadrature

%     ------------------------------ 
%     BEGIN SURFACE QUADRATURE ON 
%     EACH SIDE OF ELEMENT I
%     ------------------------------ 

      for J=1:NSPE
%        --------------------------------
%        CHECK IF QUADRATURE IS NECESSARY 
%        --------------------------------
         CHKTX=1.0;
         CHKTY=1.0;
         for K=1:NNPS
            J1=NP(I,NPSIDE(J,K));
            CHKTX=CHKTX*TX(J1);  
            CHKTY=CHKTY*TY(J1);  
         end

         if CHKTX ~= 0 ||  CHKTY ~= 0 
%           ---------------------------------------
%           BEGIN SURFACE QUADRATURE ON SIDE J
%           ---------------------------------------
%           >   Note: Input data is rotated to    <
%           >         global coordinates for      <
%           >         integration.                <
%           ---------------------------------------
            KEND=NUMQPT(2);
            for K=1:KEND 
%              ----------------------------------------
%              DETERMINE PARAMETERS AT QUADRATURE POINT
%              ----------------------------------------
               DXDXI=0.0; 
               DYDXI=0.0; 
               TXK=0.0; 
               TYK=0.0; 
               UXK=0.0;
               UYK=0.0;
   
               for L=1:NNPS 
                  L1=NPSIDE(J,L); 
                  NPL=NP(I,L1);
                  TH=THETA(NPL); 
                  C=cos(TH); 
                  S=sin(TH); 

                  DXDXI=DXDXI+SF(5,L,K)*XORD(NPL); 
                  DYDXI=DYDXI+SF(5,L,K)*YORD(NPL); 
    
                  if CHKTX ~= 0 
                     TXK=TXK+SF(4,L,K)*(C*TX(NPL)...
                                    -S*TY(NPL)); 
                  end
                  if CHKTY ~= 0 
                     TYK=TYK+SF(4,L,K)*(S*TX(NPL)...
                                    +C*TY(NPL)); 
                  end
               end

               DETJS=sqrt(DXDXI^2+DYDXI^2); 
               for L=1:NNPS 
                  COMM=WT(2,K)*SF(4,L,K)*DETJS;
                  L1=NPSIDE(J,L); 
                  L2=L1+NNPE;
                  FE(L1)=FE(L1)+ COMM*TXK;
                  FE(L2)=FE(L2)+ COMM*TYK;
               end
            end
         end
      end
%     ----------  end of surface quadrature


%     -------------------------------
%     ROTATE SE and FE TO X'-Y' AXES 
%         (Local Coordinates) 
%     -------------------------------
      for J=1:NNPE 
         TH=THETA(NP(I,J)); 
         if TH ~= 0
            C=cos(TH); 
            S=sin(TH); 

            J1=J;
            J2=J+NNPE; 
            FEX =  C*FE(J1) + S*FE(J2);
            FEY = -S*FE(J1) + C*FE(J2);
            FE(J1) = FEX;
            FE(J2) = FEY;

            for K=1:NNPE; 
               K1=K;
               K2=K+NNPE; 
               XX=+C*SE(J1,K1)+S*SE(J2,K1); 
               XY=+C*SE(J1,K2)+S*SE(J2,K2); 
               YX=-S*SE(J1,K1)+C*SE(J2,K1); 
               YY=-S*SE(J1,K2)+C*SE(J2,K2); 
               SE(J1,K1)=XX;
               SE(J1,K2)=XY;
               SE(J2,K1)=YX;
               SE(J2,K2)=YY;
               XX=+SE(K1,J1)*C+SE(K1,J2)*S; 
               XY=-SE(K1,J1)*S+SE(K1,J2)*C;
               YX=+SE(K2,J1)*C+SE(K2,J2)*S;
               YY=-SE(K2,J1)*S+SE(K2,J2)*C;
               SE(K1,J1)=XX;
               SE(K1,J2)=XY;
               SE(K2,J1)=YX;
               SE(K2,J2)=YY;
            end
	 end
      end

%     -----------------------------------
%     PLACE SE and FE IN GLOBAL SK MATRIX
%     -----------------------------------
      for J=1:NNPE2
         NPJ=NPE(J);
         F(NPJ)=F(NPJ) + FE(J);
         for K=1:NNPE2
            NPK=NPE(K);
            if NPK >= NPJ
               JK=(NPK-NPJ)+1; 
               SK(NPJ,JK)=SK(NPJ,JK)+SE(J,K); 
            end
         end
      end
   end
%  --------  all elements are now assembled 

%  ----------------------------
%  SPECIFY BOUNDARY CONDITIONS
%  ----------------------------
   for I=1:NUMNP
      NBCI=NPBC(I);
      if NBCI == 3 | NBCI == 1
         NPX=2*NWLD(I)-1; 
         SK(NPX,1)=SK(NPX,1)*1.0E+12; 
         F(NPX) =SK(NPX,1)*XBC(I);
      end

     if NBCI == 3 | NBCI == 2
        NPY=2*NWLD(I); 
        SK(NPY,1)=SK(NPY,1)*1.0E+12; 
        F(NPY) =SK(NPY,1)*YBC(I);
      end
   end


%  --------------------- 
%  SOLVE MATRIX EQUATION
%  --------------------- 
   LU=1;
   U =  sGAUSS(SK,F,NUMEQ,IB);


%  ---------------------------- 
%  PLACE SOLUTION IN ORDER OF 
%       ORIGINAL NODE NUMBERS
%       AND GLOBAL COORDINATES
%  ---------------------------- 
   for I=1:NUMEQ
      F(I)=U(I); 
   end
   for I=1:NUMNP
      IY =2*I; 
      IX =IY-1;
      TH =THETA(I);
      C  =cos(TH);
      S  =sin(TH);
      NI =NWLD(I); 
      NIY=2*NI;
      NIX=NIY-1; 
      U(IX)=F(NIX)*C-F(NIY)*S;
      U(IY)=F(NIX)*S+F(NIY)*C;
   end
