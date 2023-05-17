%------------------------------------ 
%  COEF.m   
%
%  X,Y = quadrature point coordinates
%  LMNT = element number
%
%  User must define:
%  GAMX, GAMY, G, LAMBDA
%
%------------------------------------ 

      GAMX=0.0;
      GAMY=0.0;
      
      v=0.0638;
      E=7.356383308166818e+03;
      G=E/2/(1+v);
      LAMBDA = v*E/(1+v)/(1-2*v);
      