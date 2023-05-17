%   Impervious boundaries both upstream and downstream
%      for I=1:NUMNP
%         if NPcode(I) == 31
% 	       NPBC(I) = 1;
% 	       PHI(I)  = IN_PHI;
% 	    elseif NPcode(I) == 32
% 	       NPBC(I) = 1;
% 	       PHI(I)  = 0;
%         elseif NPcode(I) == 1 || NPcode(I) == 2 || NPcode(I) == 4 || NPcode(I) == 5 || NPcode(I) == 11 || NPcode(I) == 21 || NPcode(I) == 12 || NPcode(I) == 22
% 	       NPBC(I) = 0;
% 	       Q(I)    = 0;
%         end
%      end

%   Constant heads in both upstream and downstream
     for I=1:NUMNP
        if NPcode(I) == 31 || NPcode(I) == 2 || NPcode(I) == 11
	       NPBC(I) = 1;
	       PHI(I)  = IN_PHI;
	    elseif NPcode(I) == 32 || NPcode(I) == 4 || NPcode(I) == 21
	       NPBC(I) = 1;
	       PHI(I)  = 0;
        elseif NPcode(I) == 1 || NPcode(I) == 5 || NPcode(I) == 12 || NPcode(I) == 22
	       NPBC(I) = 0;
	       Q(I)    = 0;
        end
     end
OUT_NPBC=NPBC;
OUT_PHI=PHI;