%--------------------------------- 
% NPCODE.m 
%  
% A user INCLUDE code
%
% LNP(I,J,K) = node K, on side J
% of element I.
%-------------------------------------

% --------------------------------
% Set n-factor for number of nodes 
% on a side
% --------------------------------
   if NNPE == 6 | NNPE == 8
      n=2;
   else
      n=1;
   end  



% ------------------------
% Initialize NPcode array
% ------------------------
   for i=1:NUMNP
      NPcode(i)=0;
   end


%  ---------------------------------
%  Set NPcode = 1 on  lower boundary
%  ---------------------------------
   IEND = n*NDIV(2,2)+1; 
   for I=1:IEND
      NI=LNP(2,2,I);  
      NPcode(NI)=1;
   end

   IEND = n*NDIV(3,2)+1; 
   for I=1:IEND
      NI=LNP(3,2,I);  
      NPcode(NI)=1;
   end

   IEND = n*NDIV(5,2)+1; 
   for I=1:IEND
      NI=LNP(5,2,I);  
      NPcode(NI)=1;
   end

   IEND = n*NDIV(8,2)+1; 
   for I=1:IEND
      NI=LNP(8,2,I);  
      NPcode(NI)=1;
   end

%  -----------------------------------
%  Set NPcode = 2 on left side of mesh
%  -----------------------------------
   IEND = n*NDIV(1,1)+1; 
   for I=1:IEND
      NI=LNP(1,1,I);  
      NPcode(NI)=2;
   end

   IEND = n*NDIV(2,1)+1; 
   for I=1:IEND
      NI=LNP(2,1,I);  
      NPcode(NI)=2;
   end

%  ---------------------------------
%  Set NPcode = 31 on left top boundary
%  ---------------------------------
   IEND = n*NDIV(1,4)+1; 
   for I=1:IEND
      NI=LNP(1,4,I);  
      NPcode(NI)=31;
   end

%  ---------------------------------
%  Set NPcode = 32 on right top boundary
%  ---------------------------------
   IEND = n*NDIV(6,4)+1; 
   for I=1:IEND
      NI=LNP(6,4,I);  
      NPcode(NI)=32;
   end

%  ------------------------------------
%  Set NPcode = 4 on right side of mesh
%  ------------------------------------
   IEND = n*NDIV(6,3)+1; 
   for I=1:IEND
      NI=LNP(6,3,I);  
      NPcode(NI)=4;
   end

   IEND = n*NDIV(7,3)+1; 
   for I=1:IEND
      NI=LNP(7,3,I);  
      NPcode(NI)=4;
   end

   IEND = n*NDIV(8,3)+1; 
   for I=1:IEND
      NI=LNP(8,3,I);  
      NPcode(NI)=4;
   end

%  ------------------------------------
%  Set NPcode = 5 in dam
%  ------------------------------------
   IEND = n*NDIV(1,3)+1; 
   for I=1:IEND
      NI=LNP(1,3,I);  
      NPcode(NI)=5;
   end

   IEND = n*NDIV(3,4)+1; 
   for I=1:IEND
      NI=LNP(3,4,I);  
      NPcode(NI)=5;
   end

   IEND = n*NDIV(4,1)+1; 
   for I=1:IEND
      NI=LNP(4,1,I);  
      NPcode(NI)=5;
   end

   IEND = n*NDIV(4,4)+1; 
   for I=1:IEND
      NI=LNP(4,4,I);  
      NPcode(NI)=5;
   end

   IEND = n*NDIV(6,1)+1; 
   for I=1:IEND
      NI=LNP(6,1,I);  
      NPcode(NI)=5;
   end
% ----------------------------------
% Set NPcode for corner points
% ----------------------------------
  NI=LNP(1,1,1);
  NPcode(NI) = 11;

  NI=LNP(2,2,1);
  NPcode(NI) = 12;

  NI=LNP(8,3,1);
  NPcode(NI) = 22;

  NI=LNP(6,4,1);
  NPcode(NI) = 21;


