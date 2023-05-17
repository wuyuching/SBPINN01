%---------------------------------------------------
%                  INITIAL.m
%
%  The following arrays must be initialized by user
%  if they differ from default values (all zeros):
%
%      NPBC, XBC, YBC, TX, TY, THETA, MAT
%---------------------------------------------------
      for I=1:NUMNP
        if NPcode(I) == 1
           NPBC(I) = 3.0;
           XBC(I)  = 0.0;
           YBC(I)  = 0.0;
           TX(I)   = 0.0;
           TY(I)   = 0.0;
           THETA(I)= 0.0;
        elseif NPcode(I) == 9
           NPBC(I) = 0.0;
           XBC(I)  = 0.0;
           YBC(I)  = 0.0;
           TX(I)   = 0.0;
           TY(I)   = 1000;
           THETA(I)= 0.0;   
        end
      end

