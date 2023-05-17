%---------------------------------------------------------------------- 
%                           PROGRAM mesh.m
%                                                                      
%      This program generates finite element meshes for either         
%      3, 4, 6, or 8 node elements.                                    
%                                                                      
%      NNPE    = nodes per element (3, 4, 6 or 8)                      
%      NUMLPS  = number of LOOPS to be used for current mesh           
%                                                                     
%      NDIV(I,J) = number of divisions on side J of LOOP I            
%                     J=1 refers to side defined by first three       
%                         (XCOR,YCOR).  Will automatically            
%                         designate side 3 as having the same          
%                         number of divisions                          
%                     J=2 refers to side defined by (XCOR,YCOR)        
%                         2,3 AND 4.  Will designate side 4 as         
%                         having the same number of divisions          
%      JOIN(I,J,K) = current LOOP (LOOP I) SIDE K is joined to         
%                         side JOIN(I,J,2) of LOOP JOIN(I,J,1)         
%      XCOR(I,J)   = the 8 X-coordinates of LOOP I                     
%      YCOR(I,J)   = the 8 Y-coordinates of LOOP I                     
%---------------------------------------------------------------------- 

      clear
%     -----------------------
%     READ DATA FOR ALL LOOPS 
%     -----------------------
      load LOOPS.txt
      load JOIN.txt 
      load COORD.txt

      NUMLPS = LOOPS(1,1);
      NNPE   = LOOPS(1,2);
      
      NDIV=zeros(NUMLPS,4);

      for i=1:NUMLPS
          NDIV(i,1) = LOOPS(i+1,1);
          NDIV(i,2) = LOOPS(i+1,2);
          NDIV(i,3) = LOOPS(i+1,1);
          NDIV(i,4) = LOOPS(i+1,2);
      end

      icnt=0;
      XCOR=zeros(NUMLPS,8);
      YCOR=zeros(NUMLPS,8);
      for i=1:NUMLPS
         for j=1:8
	    icnt=icnt+1;
	    XCOR(i,j)=COORD(icnt,1);
	    YCOR(i,j)=COORD(icnt,2);
         end
      end

%     ---------------------------------------------
%     CALCULATE NUMBER OF NODAL POINTS AND ELEMENTS 
%     ---------------------------------------------
%         I7 -> NUMNP,  I8 -> NUMEL, in each loop 
%     ---------------------------------------------
      NUMNP=0; 
      NUMEL=0; 
      NNLOOP=zeros(NUMLPS,1);
      for I=1:NUMLPS
         ILMNT=NNPE;
         if ILMNT == 3
            I7=(NDIV(I,1)+1)*(NDIV(I,2)+1);
            I8=2*NDIV(I,1)*NDIV(I,2);
         elseif ILMNT == 4
            I7=(NDIV(I,1)+1)*(NDIV(I,2)+1);
            I8=NDIV(I,1)*NDIV(I,2);
         elseif ILMNT == 6
            I7=(2*NDIV(I,1)+1)*(2*NDIV(I,2)+1);
            I8=2*NDIV(I,1)*NDIV(I,2);
         elseif ILMNT == 8
            I7=(2*NDIV(I,1)+1)*(2*NDIV(I,2)+1)-(NDIV(I,1)*NDIV(I,2));
            I8=NDIV(I,1)*NDIV(I,2);
         end

         NNLOOP(I)=I7;
         J1   = 4;
         for J=1:4
            if JOIN(I,2*J-1) > 0
	       if ILMNT == 3 
                  I7=I7-(NDIV(I,J)+1);
	       elseif ILMNT == 4 
                  I7=I7-(NDIV(I,J)+1);
	       elseif ILMNT == 6 
                  I7=I7-(2*NDIV(I,J)+1); 
	       elseif ILMNT == 8 
                  I7=I7-(2*NDIV(I,J)+1);  
	       end

               if JOIN(I,2*J1-1) > 0
                 I7=I7+1; 
               end
            end 
            J1=J;
         end
         NUMNP=NUMNP+I7;
         NUMEL=NUMEL+I8;
      end

%     ------------------------------------------------
%     CHECK JOIN ARRAY FOR COMPATIBILITY BETWEEN LOOPS
%     ------------------------------------------------
      for I=1:NUMLPS
         for J=1:4
            if JOIN(I,2*J-1) ~=  0
               JI=JOIN(I,2*J-1);
               JJ=JOIN(I,2*J);
               J1=NDIV( I, J);
               J2=NDIV(JI,JJ);
	           if J1 ~= J2 
	              error (' Error in JOIN array')
               end
	       end
        end
      end


%     -------------------------------------
%     BEGIN MASTER LOOP OVER ALL MESH LOOPS 
%     -------------------------------------
      INP=0; 
      IEL=0; 
      DFACT=-0.0001; 

      for I=1:NUMLPS
         ILMNT=NNPE;
         NNL  =NNLOOP(I);
         ND1=NDIV(I,1); 
         ND2=NDIV(I,2); 
         ND3=NDIV(I,3); 
         ND4=NDIV(I,4);
         if ILMNT == 6
            NP1=2*ND1+1;
            NP2=2*ND2+1;
            NP3=2*ND3+1;
            NP4=2*ND4+1;
         elseif ILMNT == 8
            NP1=2*ND1+1;
            NP2=2*ND2+1;
            NP3=2*ND3+1;
            NP4=2*ND4+1;
         elseif ILMNT == 3
            NP1=ND1+1;
            NP2=ND2+1;
            NP3=ND3+1;
            NP4=ND4+1;
         elseif ILMNT == 4
            NP1=ND1+1;
            NP2=ND2+1;
            NP3=ND3+1;
            NP4=ND4+1;
         end

%        ---------------------
%        CALCULATE SIDE ARRAYS 
%        ---------------------
         for J=1:NP1
            LNR(1,J)=J;
         end
        
         for J=1:NP3
            LNR(3,J)=(NNL+1-J);
         end
         
         if ILMNT ~= 8 
            for J=1:NP2
               LNR(2,J)=J*NP1;
            end
         else
            LNR(2,1)=NP1;
            for J=3:2:NP2
               JM1=J-1; 
               JM2=J-2; 
               LNR(2,JM1)=LNR(2,JM2)+ND1+1; 
               LNR(2,J  )=LNR(2,JM1)+NP1; 
            end
         end
         
         
         LNR(4,NP4)=1;
         J1=NP4;
         for J=2:NP2
            J1=J1-1; 
            LNR(4,J1)=LNR(2,J-1)+1;
         end

%        -------------------------------
%        CALCULATE NODES PER ROW (NNROW) 
%        -------------------------------
         J4=NP4+1;
         NN=ND1;
         for J=1:NP2
            J2=J;
            J4=J4-1; 
            NNROW(I,J)=LNR(2,J2)-LNR(4,J4)+1;
         end


%        -------------------
%        CALCULATE NPN ARRAY 
%        -------------------
         for J=1:NNL
            NPN(J)=0;
         end
	
         for J=1:4
            if JOIN(I,2*J-1) ~= 0
               J1=JOIN(I,2*J-1);
               J2=JOIN(I,2*J);
               if ILMNT == 3
                  KEND=NDIV(I,J)+1;
	       elseif ILMNT == 4
                  KEND=NDIV(I,J)+1;
               elseif ILMNT == 6
                  KEND=2*NDIV(I,J)+1;
               elseif ILMNT == 8
                  KEND=2*NDIV(I,J)+1;
               end
	      
               K2=KEND+1;
               for K=1:KEND
                  K1=LNR(J,K);
                  K2=K2-1;
                  NPN(K1)=LNP(J1,J2,K2);
               end
            end
         end
	
         for J=1:NNL
            if NPN(J) == 0
               INP=INP+1;
               NPN(J)=INP;
            end
         end
%        ----------------------------
%        DEFINE PERMANENT SIDE ARRAYS
%        ----------------------------
         for J=1:NP1
            LNP(I,1,J)=NPN(LNR(1,J));
         end

         for J=1:NP2
            LNP(I,2,J)=NPN(LNR(2,J));
            LNP(I,4,J)=NPN(LNR(4,J));
         end

         for J=1:NP3
            LNP(I,3,J)=NPN(LNR(3,J));
         end

%        ---------------------------------
%        CALCULATE NODAL POINT COORDINATES 
%        ---------------------------------
            if ILMNT ==     3
               R=ND2;
            elseif ILMNT == 4
               R=ND2;
            elseif ILMNT == 6
               R=2*ND2;
            elseif ILMNT == 8
               R=2*ND2;
            end
	   
            DY=1.0/R;
            J4=NP4+1;
            K1=0;
            for J=1:NP2
               R   =J-1;
               RY  =R*DY; 
               RYM1=1.0-RY; 
               RY2 =2.0*RY; 
               J2=J;
               J4=J4-1; 
               R=NNROW(I,J)-1;
               DX=1.0/R;
               KEND=NNROW(I,J); 
               for K=1:KEND 
                  R=K-1; 
                  RX=R*DX; 
                  RXM1=1.0-RX; 
                  RX2=2.0*RX;
                  RX2RY2=RX2*RY2;  
                  RXRYM1=RXM1*RYM1;
                  RN(1)=RXRYM1*(1.0-RX2-RY2);
                  RN(2)=+4.0*RX*RXRYM1;
                  RN(3)=RX*RYM1*(-1.0+RX2-RY2);
                  RN(4)=RX2RY2*RYM1; 
                  RN(5)=RX*RY*(-3.0+RX2+RY2);
                  RN(6)=RX2RY2*RXM1; 
                  RN(7)=RXM1*RY*(-1.0-RX2+RY2);
                  RN(8)=+4.0*RXRYM1*RY;
                  K1=K1+1; 
                  K2=NPN(K1);
                  XORD(K2)=0.0;
                  YORD(K2)=0.0;
                  for L=1:8
                     XORD(K2)=XORD(K2)+RN(L)*XCOR(I,L); 
                     YORD(K2)=YORD(K2)+RN(L)*YCOR(I,L); 
                  end
		 
               end
            end
	   

%        ------------------------------------
%        CALCULATION OF NP ARRAY 
%        ------------------------------------
         if ILMNT == 6
            K2=0;
            K3=NP1;
            for J=1:ND2
               K1=K2+1; 
               K2=K3+1;
               K3=K2+NP1; 
               for K=1:ND1
                  IEL=IEL+2; 
                  N1=IEL-1;
                  N2=IEL;
                  NTR=NPN(K3+2);
                  NTL=NPN(K3);
                  NBL=NPN(K1);
                  NBR=NPN(K1+2);
                  D1=(XORD(NTR)-XORD(NBL))^2 ...
                    +(YORD(NTR)-YORD(NBL))^2;
                  D2=(XORD(NTL)-XORD(NBR))^2 ...
                    +(YORD(NTL)-YORD(NBR))^2;
                  D1=D1+DFACT*D1;  
                  DFACT=-DFACT;
                  if D2 >= D1
                     NP(N1,1)=NPN(K1);
                     NP(N1,2)=NPN(K2+1);
                     NP(N1,3)=NPN(K3+2);
                     NP(N1,4)=NPN(K3+1);
                     NP(N1,5)=NPN(K3);
                     NP(N1,6)=NPN(K2);
                     NP(N2,1)=NPN(K1);
                     NP(N2,2)=NPN(K1+1);
                     NP(N2,3)=NPN(K1+2);
                     NP(N2,4)=NPN(K2+2);
                     NP(N2,5)=NPN(K3+2);
                     NP(N2,6)=NPN(K2+1);
                  else
                     NP(N1,1)=NPN(K1);
                     NP(N1,2)=NPN(K1+1);
                     NP(N1,3)=NPN(K1+2);
                     NP(N1,4)=NPN(K2+1);
                     NP(N1,5)=NPN(K3);
                     NP(N1,6)=NPN(K2);
                     NP(N2,1)=NPN(K1+2);
                     NP(N2,2)=NPN(K2+2);
                     NP(N2,3)=NPN(K3+2);
                     NP(N2,4)=NPN(K3+1);
                     NP(N2,5)=NPN(K3);
                     NP(N2,6)=NPN(K2+1);
                  end
		 
                  K1=K1+2; 
                  K2=K2+2;
                  K3=K3+2;
               end
            end


         elseif ILMNT == 8
            K2=0;
            K3=NP1;
            for J=1:ND2
               K1=K2+1; 
               K2=K3+1;
               K3=K2+ND1+1;
               for K=1:ND1
                  IEL=IEL+1; 
                  NP(IEL,1)=NPN(K1);
                  NP(IEL,2)=NPN(K1+1);
                  NP(IEL,3)=NPN(K1+2);
                  NP(IEL,4)=NPN(K2+1);
                  NP(IEL,5)=NPN(K3+2);
                  NP(IEL,6)=NPN(K3+1);
                  NP(IEL,7)=NPN(K3);
                  NP(IEL,8)=NPN(K2);
                  K1=K1+2;
                  K2=K2+1;
                  K3=K3+2;
               end
            end

         elseif ILMNT == 4
            K1=0;
            K2=NP1;
            for J=1:ND2
               K1=K1+1; 
               K2=K2+1;
               K3=K2+NP1; 
               for K=1:ND1
                  IEL=IEL+1;
                  NP(IEL,1)=NPN(K1);
                  NP(IEL,2)=NPN(K1+1);
                  NP(IEL,3)=NPN(K2+1);
                  NP(IEL,4)=NPN(K2);
                  K1=K1+1 ;
                  K2=K2+1 ;
               end
            end
	   
         elseif ILMNT == 3
            K1=0;
            K2=NP1;
            for J=1:ND2
               K1=K1+1; 
               K2=K2+1;
               for K=1:ND1
                  IEL=IEL+2; 
                  N1=IEL-1;
                  N2=IEL;
                  NTR=NPN(K2+1);
                  NTL=NPN(K2);
                  NBL=NPN(K1);
                  NBR=NPN(K1+1);
                  D1=(XORD(NTR)-XORD(NBL))^2 ...
                    +(YORD(NTR)-YORD(NBL))^2;
                  D2=(XORD(NTL)-XORD(NBR))^2 ...
                    +(YORD(NTL)-YORD(NBR))^2;
                  D1=D1+DFACT*D1;  
                  DFACT=-DFACT;
                  if D2 >= D1
                     NP(N1,1)=NPN(K1);
                     NP(N1,2)=NPN(K2+1);
                     NP(N1,3)=NPN(K2);
                     NP(N2,1)=NPN(K1);
                     NP(N2,2)=NPN(K1+1);
                     NP(N2,3)=NPN(K2+1);
                  else
                     NP(N1,1)=NPN(K1);
                     NP(N1,2)=NPN(K1+1);
                     NP(N1,3)=NPN(K2);
                     NP(N2,1)=NPN(K1+1);
                     NP(N2,2)=NPN(K2+1);
                     NP(N2,3)=NPN(K2);
                  end
                  K1=K1+1; 
                  K2=K2+1; 
               end
            end
         end
      end

%    --------------------------------------
%    User INCLUDE code to set NPcode values
%    --------------------------------------
      for I=1:NUMEL
        NPcode(I)=0;
      end
      NPCODE

%     --------------
%     Save Data
%     --------------
      for i=1:NUMNP
          nodes(i,1) = XORD(i);
          nodes(i,2) = YORD(i);
          nodes(i,3) = NPcode(i);
      end

      save MESHo.txt NUMNP NUMEL NNPE -ascii
      save NODES.txt nodes -ascii
      save NP.txt NP -ascii




%     --------------
%     Plot Mesh
%     --------------
      hold on
      axis equal
      xmax=XORD(1);
      xmin=xmax;
      ymax=YORD(1);
      ymin=ymax;
      for I=2:NUMNP
         if XORD(I) > xmax
	    xmax = XORD(I);
         end
         if XORD(I) < xmin
	    xmin = XORD(I);
         end
         if YORD(I) > ymax
	    ymax = YORD(I);
         end
         if YORD(I) < ymin
	    ymin = YORD(I);
         end
      end
      
      for I=1:NUMEL
         x1=XORD(NP(I,NNPE));
         y1=YORD(NP(I,NNPE));
	 for J=1:NNPE
	     x2=XORD(NP(I,J));
	     y2=YORD(NP(I,J));
	     line([x1 x2],[y1 y2])
	     x1=x2;
	     y1=y2;
	 end
      end 
	       
      Xmin = xmin - 0.03*(xmax-xmin);
      Xmax = xmax + 0.03*(xmax-xmin);
      Ymin = ymin - 0.03*(ymax-ymin);
      Ymax = ymax + 0.03*(ymax-ymin);
      line([Xmin Xmax Xmax Xmin],[Ymin Ymin Ymax Ymax], ...
         'Color','w');
      hold off
	       
