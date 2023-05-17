load SOLUTION -ASCII
load MESHo.txt    -ASCII

NUMNP = MESHo(1);

% -----------------------
  disp(' ')
  disp(' ENTER:')
  disp(' ------------------') 
  disp(' 1 for UX ')
  disp(' 2 for UY ')
  disp(' 3 for SIGXX ')
  disp(' 4 for SIGXY ')
  disp(' 5 for SIGYY ')
  disp(' 6 for SGEFF ')
  disp(' ------------------') 
  col = input(' < ');
      
PHI = SOLUTION(1:NUMNP,col);
save PHI PHI -ASCII;
topo

