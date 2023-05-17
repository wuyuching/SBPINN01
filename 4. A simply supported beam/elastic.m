
%--------------------
%  elastic.m 
%--------------------
 load MESHo.txt   -ASCII
 load NODES.txt   -ASCII
 load NP.txt      -ASCII
 load NWLD.txt    -ASCII

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

%---------------------------------------
%  Ask User for type of analysis desired
%--------------------------------------
 disp(' ')
 disp(' ENTER:')
 disp(' ---------------------') 
 disp(' 1 for plane strain   ')
 disp(' 2 for plane stress   ')
 disp(' ---------------------')
 IPROG = input(' < '); 


 [SF,WT,NUMQPT,NPSIDE] = SFquad(NNPE);

%-----------------------------
% User written initialization
%-----------------------------
  INITIAL

%-------------------
% SOLVE PROBLEM
%-------------------
 strain
 stress

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
 save SOLUTION SOLUTION -ASCII

NOTE = [
'                                               ';
'                                               ';
'        ---------------------------------------';
'         All nodal point values are saved in   ';
'                    file SOLUTION              ';
'            located in your home directory.    ';
'        ---------------------------------------';
'                Contents of SOLUTION           ';
'                                               ';
'            UX UY SIGXX SIGXY SIGYY SGEFF      '; 
'                                               ';
'        where:                                 ';
'          UX, UY       = x and y displacements ';
'          SIGXX, etc.  = Stress components     ';
'          SGEFF        = Effective stress      ';
'        ---------------------------------------';
'        to retrieve, for example, SIGXX values,';
'                                               ';
'             load SOLUTION                     ';
'             SIGXX = SOLUTION(1:NUMNP,3)       ';
'             save SIGXX SIGXX -ASCII           ';
'        ---------------------------------------';
];
disp(NOTE)
 
