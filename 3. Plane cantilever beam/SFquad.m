
 function [SF,WT,NUMQPT,NPSIDE] = SFquad(NNPE)
%--------------------------------------------------------------------
%                                                                    
%                            function  SFquad.M
%                                                                   
%                            LIST OF ARGUEMENTS                    
%                            ------------------                   
%                                                                
%            SF(I,J,K)                                          
%               I = 1  AREA SHAPE FUNCTION,     N              
%                   2  DERIVATIVE               dN/du         
%                   3  DERIVATIVE               dN/dv        
%                   4  LINE SHAPE FUNCTION      N           
%                   5  DERIVATIVE               dN/dS      
%               J = Nodal Point Number                    
%               K = Quadrature Point Number              
%            WT(I,J)                                            
%               I = 1   WEIGHTS FOR AREA QUADRATURE            
%                   2   WEIGHTS FOR LINE QUADRATURE           
%               J = QUADRATURE POINT                         
%            NNPE = Number of Nodal Points Per Element      
%            NNPS = Number of Nodal Points Per Side        
%            NSPE = Number of Sides Per Element           
%            NPSIDE(I,J)                                 
%               I = Element side                        
%               J = Element node number on side I      
%            NUMQPT(I)                                
%               I = 1  Number of Quadrature Points for Area    
%                      Integration                            
%                   2  Number of Quadrature Points for Surface   
%                      Integration                              
%                                                              
%--------------------------------------------------------------------


%   -------------------------------------------------------------
    if NNPE == 3
%   -------------------------------------------------------------
        NNPS=2;
        NSPE=3;

%       ----------------------
%       SF FOR AREA QUADRATURE
%       ----------------------
        NUMQPT(1)=1;
        QPT(1,1)=1.0/3.0;
        QPT(1,2)=1.0/3.0;
        WT(1,1) =0.5;
        for I=1:NNPE
           JEND=NUMQPT(1);
           for J=1:JEND
              SF(1,I,J)=SFN   (QPT(J,1),QPT(J,2),I,NNPE);
              SF(2,I,J)=SFNu (QPT(J,1),QPT(J,2),I,NNPE);
              SF(3,I,J)=SFNv(QPT(J,1),QPT(J,2),I,NNPE);
           end  
        end  
    

%       ----------------------
%       SF for line quadrature
%       ----------------------
        NUMQPT(2)=1;
        QPT(1,1)= 0;
        WT(2,1) = 2;
        JEND=NUMQPT(2);
        for J=1:JEND
           for I=1:NNPS
              I1=I;
              SF(4,I,J)=SFL (QPT(1,J),I1,NNPS);
              SF(5,I,J)=SFLS(QPT(1,J),I1,NNPS);
           end   
        end   

%       -------------------
%       Define NPSIDE array
%       -------------------
        NPSIDE(1,1)=1;
        NPSIDE(1,2)=2;
        NPSIDE(2,1)=2;
        NPSIDE(2,2)=3;
        NPSIDE(3,1)=3;
        NPSIDE(3,2)=1;


%   -------------------------------------------------------------
    elseif NNPE == 4
%   -------------------------------------------------------------
        NNPS=2;
        NSPE=4;

%       -------------------------
%       SF for volume quadrature
%       -------------------------
        NUMQPT(1)=4;
        A1=0.5773502692;
        QPT(1,1)=-A1;
        QPT(1,2)=-A1;
        QPT(2,1)=+A1;
        QPT(2,2)=-A1;
        QPT(3,1)=+A1;
        QPT(3,2)=+A1;
        QPT(4,1)=-A1;
        QPT(4,2)=+A1;

        WT(1,1)=1.00;
        WT(1,2)=1.00;
        WT(1,3)=1.00;
        WT(1,4)=1.00;

        JEND=NUMQPT(1);
        for J=1:JEND
           for I=1:4
              SF(1,I,J)=SFN   (QPT(J,1),QPT(J,2),I,NNPE);
              SF(2,I,J)=SFNu (QPT(J,1),QPT(J,2),I,NNPE);
              SF(3,I,J)=SFNv(QPT(J,1),QPT(J,2),I,NNPE);
           end  
        end  
    

%       --------------------------
%       SF for line quadrature
%       --------------------------
        NUMQPT(2)=1;
        WT(2,1)=2.0;
        SF(4,1,1)= 0.5;
        SF(4,2,1)= 0.5;
        SF(5,1,1)=-0.5;
        SF(5,2,1)= 0.5;

%       -------------------
%       Define NPSIDE array
%       -------------------
        NPSIDE(1,1)=1;
        NPSIDE(1,2)=2;
        NPSIDE(2,1)=2;
        NPSIDE(2,2)=3;
        NPSIDE(3,1)=3;
        NPSIDE(3,2)=4;
        NPSIDE(4,1)=4;
        NPSIDE(4,2)=1;


%   -------------------------------------------------------------
    elseif NNPE == 6
%   -------------------------------------------------------------
        NNPS=3;
        NSPE=3;

%       -------------------------
%       OF SF FOR AREA QUADRATURE 
%       -------------------------
        NUMQPT(1)=7;
        A1=0.059715871789770;
        B1=0.470142064105115;
        A2=0.797426985353087;
        B2=0.101286507323456;

        QPT(1,1)=1.0/3.0;
        QPT(1,2)=1.0/3.0;
        QPT(2,1)=A1;
        QPT(2,2)=B1;
        QPT(3,1)=B1;
        QPT(3,2)=A1;
        QPT(4,1)=B1;
        QPT(4,2)=B1;
        QPT(5,1)=B2;
        QPT(5,2)=A2;
        QPT(6,1)=B2;
        QPT(6,2)=B2;
        QPT(7,1)=A2;
        QPT(7,2)=B2;

        WT(1,1)=0.1125;
        WT(1,2)=0.066197076394253;
        WT(1,3)=WT(1,2);
        WT(1,4)=WT(1,2);
        WT(1,5)=0.062969590272413;
        WT(1,6)=WT(1,5);
        WT(1,7)=WT(1,5);

        JEND=NUMQPT(1);
        for J=1:JEND
           for I=1:NNPE
              SF(1,I,J)=SFN   (QPT(J,1),QPT(J,2),I,NNPE);
              SF(2,I,J)=SFNu (QPT(J,1),QPT(J,2),I,NNPE);
              SF(3,I,J)=SFNv(QPT(J,1),QPT(J,2),I,NNPE);
           end  
        end  
    

%       ----------------------
%       SF for line quadrature
%       ----------------------
        NUMQPT(2)=3;
        QPT(1,1)= sqrt(0.6);
        QPT(1,2)=0.0;
        QPT(1,3)=-QPT(1,1);

        WT(2,1)=5.0/9.0;
        WT(2,2)=8.0/9.0;
        WT(2,3)=5.0/9.0;

        JEND=NUMQPT(2);
        for J=1:JEND
           for I=1:NNPS
              I1=I;
              SF(4,I,J)=SFL (QPT(1,J),I1,NNPS);
              SF(5,I,J)=SFLS(QPT(1,J),I1,NNPS);
           end  
        end  

%       -------------------
%       Define NPSIDE array
%       -------------------
        NPSIDE(1,1)=1;
        NPSIDE(1,2)=2;
        NPSIDE(1,3)=3;
        NPSIDE(2,1)=3;
        NPSIDE(2,2)=4;
        NPSIDE(2,3)=5;
        NPSIDE(3,1)=5;
        NPSIDE(3,2)=6;
        NPSIDE(3,3)=1;

    else

        fprintf(1,'\n--------------------------')
        fprintf(1,'\n Error in shafac.m        ') 
        fprintf(1,'\n NNPE =%2i',NNPE   )
        fprintf(1,' is invalid'     )
        fprintf(1,'\n--------------------------\n')
        error

    end 

%--------------------------------------------------------------
%--------------------- end of function shafac -----------------
%--------------------------------------------------------------




function  f = SFN(u,v,n,NNPE)
%-------------------------------
     if NNPE == 3
         w = 1.0-u-v;
         if n == 1;
            f = u;
         elseif n == 2
            f = v;
         elseif n == 3
            f = w;
         end
     elseif NNPE == 4
         if n == 1
           f=0.25*(1.0-u)*(1.0-v);
         elseif n == 2
           f=0.25*(1.0+u)*(1.0-v);
         elseif n == 3
           f=0.25*(1.0+u)*(1.0+v);
         elseif n == 4
           f=0.25*(1.0-u)*(1.0+v);
         end
     elseif NNPE == 6
         w=1.0-u-v;
         if n == 1
           f=(2.0*u-1.0)*u;
         elseif n == 2
           f=4.0*v*u;
         elseif n == 3
           f=(2.0*v-1.0)*v;
         elseif n == 4
           f=4.0*v*w;
         elseif n == 5
           f=(2.0*w-1.0)*w;
         elseif n == 6
           f=4.0*u*w;
         end
      end
%--------------------- end of function SFN --------------------




function f = SFNu(u,v,n,NNPE)
%----------------------------------------------------------------
% Derviative of shape function with respect to the xi coordinate
%----------------------------------------------------------------
     if NNPE == 3
         w=1.0-u-v;
         if n     == 1
            f=1.0;
         elseif n == 2
            f=0.0;
         elseif n == 3
            f=-1.0;
         end 
     elseif NNPE == 4
         if n     == 1
             f=0.25*(   -1.)*(1.0-v);
         elseif n == 2
             f=0.25*(   +1.)*(1.0-v);
         elseif n == 3
             f=0.25*(   +1.)*(1.0+v);
         elseif n == 4
             f=0.25*(   -1.)*(1.0+v);
         end 
     elseif NNPE == 6
         w = 1.0-u-v;
         if n     == 1
             f=4.0*u-1.0;
         elseif n == 2
             f=4.0*v;
         elseif n == 3
             f=0.0;
         elseif n == 4
             f=-4.0*v;
         elseif n == 5
             f=-4.0*w+1.0;
         elseif n == 6
             f=4.0*w-4.0*u;
         end 
      end
%--------------------- end of function SFNu ------------------



function f = SFNv(u,v,n,NNPE)
%----------------------------------------------------------------
% Derviative of shape function with respect to the eta coordinate
%----------------------------------------------------------------
     if NNPE == 3
         if n     == 1
            f=0.0;
         elseif n == 2
            f=1.0;
         elseif n == 3
            f=-1.0;
         end 
     elseif NNPE == 4
         if n     == 1
            f=0.25*(1.0-u)*(   -1.0);
         elseif n == 2
            f=0.25*(1.0+u)*(   -1.0);
         elseif n == 3
            f=0.25*(1.0+u)*(   +1.0);
         elseif n == 4
            f=0.25*(1.0-u)*(   +1.0);
         end 
     elseif NNPE == 6
         w=1.0-u-v;
         if n     == 1
            f=0.0;
         elseif n == 2
            f=4.0*u;
         elseif n == 3
            f=4.0*v-1.0;
         elseif n == 4
            f=4.0*w-4.0*v;    
         elseif n == 5
            f=-4.0*w+1.0;
         elseif n == 6
            f=-4.0*u;
         end 
     end  


function f =  SFL(S,n,NNPS)
%------------------------------------
% Shape function values for lines
%------------------------------------
     if NNPS == 2
         if n     == 1
            f=-0.5*(S-1.0);
         elseif n == 2
            f= 0.5*(S+1.0);
         end 
     elseif NNPS == 3
         if n     == 1
            f= -0.5*(S)*(1.-S);
         elseif n == 2
            f= (1.+S)*(1.-S);
         elseif n == 3
            f= 0.5*(1.+S)*(S);
         end 
     end  
%--------------------- end of function SFL --------------------




function f =  SFLS(S,n,NNPS)
%------------------------------------
% Derivative of shape function wrt S
%------------------------------------
     if NNPS == 2
       if n     == 1
          f=-0.5;
       elseif n == 2
          f= 0.5;
       end  
     elseif NNPS == 3
       if n     == 1;
          f = -0.5*(1.-2.*S);
       elseif n == 2
          f = -2.*S;
       elseif n == 3
          f = 0.5*(1.+2.*S);
       end  
     end  
%--------------------- end of function SFLS --------------------
