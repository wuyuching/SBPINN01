function [OUT_Nodes,OUT_NPBC,OUT_PHI,IN_RI,PHI] = Dpoisson()
load MESHo.txt   -ASCII
load NODES.txt   -ASCII
load NP.txt      -ASCII
load NWLD.txt    -ASCII

OUT_Nodes=NODES;
IN_PHI=rand(1,1)*25+5;
IN_RI=rand(1,1)*0.5;

NUMNP = MESHo(1);
NUMEL = MESHo(2);
NNPE  = MESHo(3);
if NNPE ~= 3
   error('NNPE in MESHo  must equal 3')
end
     
for I=1:NUMNP
   XORD(I)  =NODES(I,1);
   YORD(I)  =NODES(I,2);
   NPcode(I)=NODES(I,3);
end
IB = NWLD(NUMNP+1);

%-----------------------
% General Initialization
%-----------------------
for I=1:NUMNP
   Q(I)=0;
   PHI(I)=0;
   NPBC(I)=0;
   for J=1:IB;
      SK(I,J)=0.0; 
   end
end

%-----------------------
% User's Initialization
%-----------------------
DINITIAL

%-------------------------------
% Place Q in RHS, compact storage
%-------------------------------
for I=1:NUMNP
   RHS(NWLD(I))=Q(I);
end

%------------------------------------
% Formation of Finite Element Matrices
% Element by Element
%------------------------------------
for I=1:NUMEL
   LMNT=I;
   XJ=XORD(NP(I,2))-XORD(NP(I,1));
   YJ=YORD(NP(I,2))-YORD(NP(I,1));
   XK=XORD(NP(I,3))-XORD(NP(I,1));
   YK=YORD(NP(I,3))-YORD(NP(I,1));

   XC=XORD(NP(I,1))+(XJ+XK)/3.0;
   YC=YORD(NP(I,1))+(YJ+YK)/3.0;

   VOL=(XJ*YK-XK*YJ)/2.0 ;
   if VOL < 0.0
	  error(' Element VOL is less than zero ')
   end

%  --------------------------
%   INCLUDE user's COEF.m code
%  --------------------------
   DCOEF

   COMM=1.0/(2.0*VOL);

   DNDX(1)=-(YK-YJ)*COMM; 
   DNDX(2)=+(YK   )*COMM;
   DNDX(3)=-(YJ   )*COMM;
   DNDY(1)=+(XK-XJ)*COMM;
   DNDY(2)=-(XK   )*COMM;
   DNDY(3)=+(XJ   )*COMM;

   for J=1:3
	  Qe(J) = VOL*QVI/3.0;
      for K=1:3
         S(J,K)=(DNDX(J)*RXI*DNDX(K)+...
	             DNDY(J)*RYI*DNDY(K))*VOL;
      end
   end

%  ---------------------------------
%   Place in Global SK and Q matrices
%   Compact Storage
%  ---------------------------------
   for J=1:NNPE
      newJ=NWLD(NP(I,J)); 
      RHS(newJ)=RHS(newJ)+Qe(J);
      for K=1:NNPE
         newK=NWLD(NP(I,K)); 
         if newK >= newJ
            Kbnd=newK-newJ+1; 
            SK(newJ,Kbnd)=SK(newJ,Kbnd)+S(J,K);
         end
      end
   end
end

%---------------------------
% Specify boundary condtions
%---------------------------
for I=1:NUMNP
   if NPBC(I) == 1
  	  Inew=NWLD(I);
      SK(Inew,1)=SK(Inew,1)*1.0E+10;  
      RHS(Inew)=PHI(I)*SK(Inew,1);
   end
end

%------------------------------------
% Solution of Finite Element Equations
%------------------------------------
PHI = sGAUSS(SK,RHS,NUMNP,IB);

%------------------------------------
% Place output in original numbering
%------------------------------------
for I=1:NUMNP
   RHS(I) = PHI(NWLD(I));
end
      
for I=1:NUMNP
   PHI(I) = RHS(I);
end

%-------------------
% Save results
%-------------------
% save PHI.txt PHI -ASCII
end