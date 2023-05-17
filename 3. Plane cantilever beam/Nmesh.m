function Nmesh()
        lengthy=rand(1,1)*40+10;
        lengthx=(rand(1,1)+2)*lengthy;
        nx=24;
        ny=12;
        air=0;
        dx=lengthx/nx;          % the length of side of elements in x-axis
        dy=lengthy/ny;          % the length of side of elements in y-axis
        gcoord=[];
        for i=1:nx+1
            for j=ny/2:-1:1
                gcoord=[gcoord; (i-1)*dx -j*dy;]; 
            end
            for j=1:ny/2+1
                gcoord=[gcoord; (i-1)*dx (j-1)*dy;]; 
            end
        end
        nn=0;
        for ip=1:nx+1                % sampling node coordiantes for discretisation
            for iq=1:ny+1 
                nn=nn+1;   
                r=random('beta',1,1);        % r=[0 1];
                r=air*(2*r-1);               % project r=[-air air];
                if ip==1 | ip==nx+1 | iq==1 | iq==ny+1 %| (iq-1)*bb==5 %|(ip-1)*aa==L/2
                    r=0;
                end
                gcoord(nn,1)=gcoord(nn,1)+dx*r;
                gcoord(nn,2)=gcoord(nn,2)+dy*r;  
            end
        end
        %---------------------------------------------------------
        %input data for nodal connectivity for each element
        %ele_nods(i,j) where i->element no. and j->connected nodes
        %---------------------------------------------------------
        ele_nods=[];
        for i=1:nx
             for j=1:ny
                  ele_nods=[ele_nods; (ny+1)*(i-1)+j (ny+1)*i+j (ny+1)*i+j+1;(ny+1)*(i-1)+j (ny+1)*i+j+1 (ny+1)*(i-1)+j+1;];
              end
         end
        %----------------------------------
        %input data for boundary conditions
        %----------------------------------
        bc=zeros((nx+1)*(ny+1),1);
        bc(1: ny+1)=1;
        bc(end-ny:end)=9;
        gnodes=[gcoord,bc];
        
        save NODES.txt gnodes -ASCII
        save NP.txt ele_nods -ASCII
end