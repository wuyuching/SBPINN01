%=====================================
%      PROGRAM squash.m
%
%      Plots deformed mesh
%      or displacement vectors
%=====================================

      clear
%     ---------------------------
%     Mesh, NewNum and PHI DATA
%     ---------------------------
      load MESHo.txt    -ASCII
      load NODES.txt    -ASCII
      load NP.txt       -ASCII
      load SOLUTION -ASCII
 
%     -------------------------------
%     Transfer data to variable names
%     -------------------------------
      NUMNP = MESHo(1);
      NUMEL = MESHo(2);
      NNPE  = MESHo(3); 
      XMAX  = NODES(1,1);
      XMIN  = XMAX 
      YMAX  = NODES(1,2);
      YMIN  = YMAX;
      Dmax  = 0;
      for I=1:NUMNP
          XORD(I)=NODES(I,1);
          YORD(I)=NODES(I,2);
          NPBC(I)=NODES(I,3);
          dsp   =abs(SOLUTION(I,1))...
                +abs(SOLUTION(I,2));
          if dsp >= Dmax
             Dmax = dsp;
          end
          if XORD(I) > XMAX
             XMAX = XORD(I);
          elseif XORD(I) < XMIN
             XMIN = XORD(I) 
          end
          if YORD(I) > YMAX
             YMAX = YORD(I);
          elseif YORD(I) < YMIN
             YMIN = YORD(I);
          end
      end

      disp(' ')
      disp(' ENTER:')
      disp(' ---------------------') 
      disp(' displacement scale   ')
      disp(' ---------------------')
      scale = input(' < ');
      scale = scale*(0.1)*(XMAX-XMIN+YMAX-YMIN)/Dmax;

      disp(' ')
      disp(' ENTER:')
      disp(' ----------------------------') 
      disp('    1 for diplaced mesh      ')
      disp('    2 for diplacement vectors')
      disp(' ----------------------------')
      choice = input(' < ');

      disp(' ')
      disp(' ENTER:')
      disp(' -------------------------------') 
      disp('    1 to plot original mesh     ')
      disp('    2 to plot original boundary ')
      disp('    any other number for neither')
      disp(' -------------------------------')
      bndry = input(' < ');

      disp(' ')
      disp(' ENTER:')
      disp(' --------------------------------------')
      disp('    0  for no SYMMETRY')
      disp('    1  for SYMMETRY about X axis ')
      disp('    2  for SYMMETRY about Y axis ')
      disp('    3  for SYMMETRY about both axes')
      disp(' --------------------------------------')
      isym = input(' < ');
      if isym < 0
         isym == 0;
      elseif isym > 3
         isym == 0;
      end

%     ---------------------------------------
%     PREPARE ARRAYS TO MATCH TYPE OF ELEMENT
%     ---------------------------------------
      if NNPE == 3;
         nS=3;  % number of sides
         pS=2;  % points per side
         rot=[1 2 3 1 2];
      end
      if NNPE == 4
         nS=4;
         pS=2;
         rot=[1 2 3 4 1 2];
      end
      if NNPE == 6
         nS=3;
         pS=3;
         rot=[1 2 3 4 5 6 1 2]; 
      end
      if NNPE == 8
         nS=4;
         pS=3;
         rot=[1 2 3 4 5 6 7 8 1 2];
      end


%     ------------------------
%     Put hold on all graphics
%     ------------------------
      hold on
      axis equal

%     ------------------------
%     Add space for boarder
%     ------------------------
      if isym == 1 | isym == 3
         YMIN = -YMAX;
      end
      if isym == 2 | isym == 3
         XMIN = -XMAX;
      end
      del  = scale*Dmax;
      xmin = XMIN - del;
      xmax = XMAX + del;
      ymin = YMIN - del;
      ymax = YMAX + del;
      PropertyName={'Color'};
      PropertyValue={'w'};
      H = line([xmin xmax xmax xmin],[ymin ymin ymax ymax]);
      set(H,PropertyName,PropertyValue)

      if bndry == 1
%       ------------------
%       Plot original mesh 
%       ------------------
        clear H
        nL=0;
        for I=1:NUMEL
           for J=1:NNPE
              r1=rot(J);
              r2=rot(J+1);
              JP1=NP(I,r1);
              JP2=NP(I,r2);
            
              x1=XORD(JP1);
              y1=YORD(JP1);
              x2=XORD(JP2);
              y2=YORD(JP2);
              nL=nL+1;
              H(nL)=line([x1,x2],[y1,y2]);
              if isym == 1 | isym == 3
                 nL=nL+1;
                 H(nL)=line([x1,x2],[-y1,-y2]);
              end
              if isym == 2 | isym == 3
                 nL=nL+1;
                 H(nL)=line([-x1,-x2],[y1,y2]);
              end
              if  isym == 3
                 nL=nL+1;
                 H(nL)=line([-x1,-x2],[-y1,-y2]);
              end
           end
        end 
        set(H,'Color','g','LineWidth',1)

      elseif bndry == 2
%       ------------------
%       Plot mesh boundary
%       ------------------
        clear H
        nL=0;

        for I=1:NUMNP
          sA(I)=0.0;
          LpN(I)=0;
        end

        for I=1:NUMEL
           for J=2:NNPE+1
               no =NP(I,rot(J  ));
               na =NP(I,rot(J-1));
               nb =NP(I,rot(J+1));

               LpN(no)=LpN(no)+1;
               a(1)=XORD(na)-XORD(no);
               a(2)=YORD(na)-YORD(no);
               b(1)=XORD(nb)-XORD(no);
               b(2)=YORD(nb)-YORD(no);

               aa=a(1)*a(1)+a(2)*a(2);
               bb=b(1)*b(1)+b(2)*b(2);
               ab=a(1)*b(1)+a(2)*b(2);
  
               ang=acos(ab/sqrt(aa*bb));
               sA(no)=sA(no)+ang;
           end
        end

        Atest=2*pi-1.0e-06;
        clear H
        nL=0;
        for I=1:NUMEL
           for J=1:NNPE
              r1=rot(J);
              r2=rot(J+1);
              JP1=NP(I,r1);
              JP2=NP(I,r2);
              if sA(JP1) < Atest 
                 if sA(JP2) < Atest
                    nL=nL+1;
                    Hx(nL,1) = XORD(JP1); 
                    Hx(nL,2) = XORD(JP2); 
                    Hy(nL,1) = YORD(JP1); 
                    Hy(nL,2) = YORD(JP2); 
                 end
              end
           end 
        end

        for I=1:nL-1
            x11=Hx(I,1); 
            x12=Hx(I,2); 
            y11=Hy(I,1); 
            y12=Hy(I,2); 
            for J=I+1:nL
               x21=Hx(J,1); 
               x22=Hx(J,2); 
               y21=Hy(J,1); 
               y22=Hy(J,2); 
 
               if x11 == x22 & x12 == x21 ...
                & y11 == y22 & y12 == y21
                  Hx(I,1) = XMIN; 
                  Hx(I,2) = XMIN; 
                  Hy(I,1) = YMIN;
                  Hy(I,2) = YMIN;
                  Hx(J,1) = XMIN;
                  Hx(J,2) = XMIN;
                  Hy(J,1) = YMIN;
                  Hy(J,2) = YMIN;
               end
            end
        end

        for I=1:nL
            x1=Hx(I,1); 
            x2=Hx(I,2); 
            y1=Hy(I,1); 
            y2=Hy(I,2); 
            if isym == 1 | isym == 3
               if y1 == 0 & y2 == 0
                  Hx(I,1) = XMIN; 
                  Hx(I,2) = XMIN; 
                  Hy(I,1) = 0;
                  Hy(I,2) = 0;
               end
            end
            if isym == 2 | isym == 3
               if x1 == 0 & x2 == 0
                  Hx(I,1) = 0; 
                  Hx(I,2) = 0; 
                  Hy(I,1) = YMIN;
                  Hy(I,2) = YMIN;
               end
            end
        end

        for I=1:nL
          line(Hx(I,:),Hy(I,:),'Color','b','LineWidth',2)
        end

        if isym == 1 | isym == 3
           for I=1:nL
             line(Hx(I,:),-Hy(I,:),'Color','b','LineWidth',2)
           end
        end
        if isym == 2 | isym == 3
           for I=1:nL
             line(-Hx(I,:),Hy(I,:),'Color','b','LineWidth',2)
           end
        end
       if  isym == 3
          for I=1:nL
            line(-Hx(I,:),-Hy(I,:),'Color','b','LineWidth',2)
          end
        end
      end   % end of original mesh plotting questions

      if choice == 1
%       ------------------
%       Plot deformed mesh 
%       ------------------
        clear H
        nL=0;
        for I=1:NUMEL
           for J=1:NNPE
              r1=rot(J);
              r2=rot(J+1);
              JP1=NP(I,r1);
              JP2=NP(I,r2);
  
              ux1 = SOLUTION(JP1,1);
              uy1 = SOLUTION(JP1,2);
              ux2 = SOLUTION(JP2,1);
              uy2 = SOLUTION(JP2,2);
            
              x1=XORD(JP1)+scale*ux1;
              y1=YORD(JP1)+scale*uy1;
              x2=XORD(JP2)+scale*ux2;
              y2=YORD(JP2)+scale*uy2;
              nL=nL+1;
              H(nL)=line([x1,x2],[y1,y2]);
              if isym == 1 | isym == 3
                 nL=nL+1;
                 H(nL)=line([x1,x2],[-y1,-y2]);
              end
              if isym == 2 | isym == 3
                 nL=nL+1;
                 H(nL)=line([-x1,-x2],[y1,y2]);
              end
              if  isym == 3
                 nL=nL+1;
                 H(nL)=line([-x1,-x2],[-y1,-y2]);
              end
           end
        end 
        set(H,'Color','r','LineWidth',1)



      elseif choice == 2
%       ------------------------
%       Plot deformation vectors
%       ------------------------
        clear H
        nL=0;
        for I=1:NUMNP
          ux = SOLUTION(I,1);
          uy = SOLUTION(I,2);
            
          x1=XORD(I);
          y1=YORD(I);
          x2=XORD(I)+scale*ux;
          y2=YORD(I)+scale*uy;

          nL=nL+1;
          H(nL)=line([x1,x2],[y1,y2]);
          if isym == 1 | isym == 3
             nL=nL+1;
             H(nL)=line([x1,x2],[-y1,-y2]);
          end
          if isym == 2 | isym == 3
             nL=nL+1;
             H(nL)=line([-x1,-x2],[y1,y2]);
          end
          if  isym == 3
             nL=nL+1;
             H(nL)=line([-x1,-x2],[-y1,-y2]);
          end
        end 
        set(H,'Color','r','LineWidth',1)
      end 

%     ------------------------
%     Remove hold on graphics
%     ------------------------
      hold off

