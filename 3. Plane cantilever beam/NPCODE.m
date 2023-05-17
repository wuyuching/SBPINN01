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
%  Set NPcode = 1 at the support
%  ---------------------------------  
   IEND = n*NDIV(1,4)+1; 
   for I=1:IEND
      NI=LNP(1,4,I);  
      NPcode(NI)=1;
   end
%  ---------------------------------
%  Set NPcode = 9 at the  Force Side
%  ---------------------------------   
   IEND = n*NDIV(1,2)+1; 
   for I=1:IEND
      NI=LNP(1,2,I);  
      NPcode(NI)=9;
   end


   