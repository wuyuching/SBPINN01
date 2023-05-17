function [ OUTPUT_Nodes, OUTPUT_F, INPUT_E, INPUT_v, SOLUTION]=Delastic(IPROG)
%--------------------
%  elastic.m 
%--------------------
 INPUT_F=rand(1,1)*100;
 INPUT_E=(rand(1,1)*9+1)*1e6;
 INPUT_v=rand(1,1)*0.5;
 
 
 load MESHo.txt   -ASCII
 load NODES.txt   -ASCII
 load NP.txt      -ASCII
 load NWLD.txt    -ASCII

 OUTPUT_Nodes=NODES;
 NUMNP = MESHo(1);
 NUMEL = MESHo(2);
 NNPE  = MESHo(3);
     
 for I=1:NUMNP;
   XORD(I)  =NODES(I,1);
   YORD(I)  =NODES(I,2);
   NPcode(I)=NODES(I,3); 
 end

% ----------------------------------------
% Set NSPE, Number of sides per element
% Set NNPS, Number of nodal point per side
% ----------------------------------------
 if NNPE     == 3
    NSPE=3;    NNPS=2;
 elseif NNPE == 6
    NSPE=3;    NNPS=3;
 elseif NNPE == 4
    NSPE=4;    NNPS=2;
 elseif NNPE == 8
    NSPE=4;    NNPS=3;
 end

% ----------------------------------------
% Set IB, band width for symmetric matrix
% Set NUMEQ, Number of equations
% ----------------------------------------
 IB   = 2*NWLD(NUMNP+1);
 NUMEQ = 2*NUMNP;

% ----------------------------------------
% Initialize all parameters and
% stiffness matrix
% ----------------------------------------
 for I = 1:NUMEQ
    NPBC(I)  = 0;
    XBC(I)   = 0.0;
    YBC(I)   = 0.0;
    TX(I)    = 0.0;
    TY(I)    = 0.0;
    THETA(I) = 0.0;
    for J = 1:IB
       SK(I,J)=0;
    end
 end

 [SF,WT,NUMQPT,NPSIDE] = SFquad(NNPE);

%-----------------------------
% User written initialization
%-----------------------------
%  INPUT_F=2000;
 DINITIAL
%-------------------
% SOLVE PROBLEM
%-------------------
 Dstrain
 Dstress

%-----------------------
% SAVE SOLUTION
%-----------------------
 for I=1:NUMNP
   Ix = 2*I-1;
   Iy = 2*I;
   SOLUTION(I,1) = U(Ix);
   SOLUTION(I,2) = U(Iy);
   SOLUTION(I,3) = SIGXX(I); 
   SOLUTION(I,4) = SIGXY(I); 
   SOLUTION(I,5) = SIGYY(I); 
   SOLUTION(I,6) = SGEFF(I);
   SOLUTION(I,7) = SMAX(I);
 end
end
 
