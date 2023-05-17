function Y = wire(MSHDAT_1, NODES_1)
  TENS  = MSHDAT_1(1);
  NUMEL = MSHDAT_1(2);
  NUMNP=NUMEL+1;
  XORD_1=zeros(1,NUMNP);
  NPBC=zeros(1,NUMNP);
  U=zeros(1,NUMNP);
  F=zeros(1,NUMNP);
  
  for  I=1:NUMNP
     XORD_1(I)=NODES_1(I,1);
     NPBC(I)=NODES_1(I,2);
     U(I)   =NODES_1(I,3);
     F(I)   =NODES_1(I,4);
  end

% --------------
% INITIALIZATION
% --------------
  IB=2;
  SK=zeros(NUMNP,IB);

% ----------------------------- 
% FORMATION OF STIFFNESS MATRIX
% ----------------------------- 
  for I=1:NUMEL
     RL=XORD_1(I+1)-XORD_1(I);
     RK=TENS/RL;
     SK(I,1)=SK(I,1)+RK;
     SK(I,2)=SK(I,2)-RK;
     IP1=I+1; 
     SK(IP1,1)=SK(IP1,1)+RK;
  end

% -------------------- 
% BOUNDARY CONDITIONS
% -------------------- 
  for I=1:NUMNP
     if NPBC(I) == 1
        SK(I,1)=SK(I,1)*1.0E+06; 
        F(I)=U(I)*SK(I,1); 
     end
  end

% ------------------------------ 
% CALL EQUATION SOLVER
% ------------------------------ 
  U_1 =  sGAUSS(SK,F,NUMNP,IB);

% -----------
% OUTPUT DATA
% -----------
  Y=U_1;
%   save XORD_1.txt XORD_1 -ASCII
%   save U_1.txt U_1 -ASCII
%   
%   plot(XORD_1,U_1)
%   grid
%   xlabel('Distance along wire')
%   ylabel('Deflection of wire')
%   title(['Deflection of a tightly'...
%          ' stretched wire'])
end