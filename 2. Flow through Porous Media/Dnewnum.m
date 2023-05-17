%------------------------------------------------------------------- 
%
%                              newnum.m
%
%     A program for renumbering the nodes of a finite element
%     mesh.  Input from program mesh.m is necessary.
% 
%     The program is interactive; the user will be asked the
%     following questons:
%
%     1.  ENTER NUBER OF NODES IN FIRST WAVE
%
%     2.  ENTER NODE NUMBERS IN FIRST WAVE 
%
%     Try several starting nodes to determine which one
%     gives the best resutls.
%------------------------------------------------------------------- 

      clear
%     --------------------- 
%     Read data from mesh.m
%     --------------------- 
      load MESHo.txt   -ASCII
      load NODES.txt   -ASCII
      load NP.txt      -ASCII

      NUMNP = MESHo(1);
      NUMEL = MESHo(2);
      NNPE  = MESHo(3);

      for i=1:NUMNP;
          XORD(i)=NODES(i,1);
          YORD(i)=NODES(i,2);
          NPBC(i)=NODES(i,3);
      end
      clear NODES
      clear MESHo

      LSTX = 0; 
      nVECT=0;
      for I=1:NUMNP;
         NPTEST(I)=0;
         NWLD(I)=-1000;
         LDNW(I)=0; 
	 Nplt(I)=0;
      end

%     ---------------------------------------
%     Get INPUT data and first wave of nodes
%     ---------------------------------------
      NWVX  =1;

      if NWVX == 0
         for I=1:NUMNP;
            LDNW(I)=I; 
	        NWLD(I)=I;
         end
         LSTX=NUMNP;
	     PLT=-1;
      else
         PLT=+1;
         for I=1:NWVX;
	        NPWAVE(I) =1;
            LDNW(I)=NPWAVE(I);
	        NWLD(NPWAVE(I))=I;
	 end
         LSTX=NWVX;
      end

%     -----------------
%     Plot Initial Wave
%     -----------------
      if LSTX ~= NUMNP
         for I=1:LSTX
            xp(I)=XORD(NPWAVE(I));
            yp(I)=YORD(NPWAVE(I));
	        Nplt(NPWAVE(I))=1;
         end 
      end
	       
%     ----------------------------
%     Determine next wave of nodes
%     ----------------------------
      while LSTX <  NUMNP
         clear NPWVo
         for I=1:NWVX
             NPWVo(I)=NPWAVE(I);
	         Nplt(NPWAVE(I)) = 1;
         end
         WVXo=NWVX;
         clear NPWAVE
          
         NWVX=0;
         for I=1:WVXo;
	    NPW = NPWVo(I);
	    for J=1:NUMEL
	       kchk=0;
	       for K=1:NNPE
	           if NP(J,K) == NPW
		      kchk = 1;
	           end
	       end
	       if kchk == 1
%                 --------------------------------
%                 Element is connected
%                 Place new points in NPWAVE
%                 
%                 Save element sides for plotting
%                 --------------------------------
	          for K=1:NNPE
		      if NWLD(NP(J,K)) < 0
			 NWVX = NWVX + 1;
		         NPWAVE(NWVX)=NP(J,K);
			 LSTX = LSTX + 1;
		         NWLD(NP(J,K)) = LSTX;
		      end
	          end 

%                 --------------------------------
%                 Save element sides for plotting
%                 --------------------------------
	          for K=1:NNPE
		     npK = NP(J,K);
		     if Nplt(npK) == 0
		       if K == NNPE
		          Kp=1;
		       else
		          Kp=K+1;
		       end
		       npKp=NP(J,Kp);
		       if Nplt(npKp) == 0
		          nVECT = nVECT + 1;
			  ex(1,nVECT) = XORD(npK);
			  ex(2,nVECT) = XORD(npKp);
			  ey(1,nVECT) = YORD(npK);
			  ey(2,nVECT) = YORD(npKp);
		       end
		     end
		  end

	       end 
	    end
         end


      end
%     -------->> new numbering has now been established
%                --------------------------------------

%     ------------------------------------------------------
%     Calculate NWLD array, i.e. NWLD(old node) = new node 
%     ------------------------------------------------------
      for I=1:NUMNP;
	 NW=NWLD(I);
         LDNW(NW)=I;
      end

%     ---------------------
%     Calculate band width 
%     ---------------------
      IB=0;
      for I=1:NUMEL;
         for J=1:NNPE; 
            NPJ=NP(I,J); 
            NRJ=NWLD(NPJ); 
            for K=1:NNPE; 
               NPK=NP(I,K); 
               NRK=NWLD(NPK); 
               if abs(NRK - NRJ) > IB
	          IB = abs(NRK-NRJ);
               end
            end
         end
      end
      IB=IB+1;


      NWLD(NUMNP+1) = IB;
      NWLD = NWLD';
      save  NWLD.txt  NWLD  -ascii
