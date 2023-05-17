%14*8个单元，15*9=135个节点
%改动LOOPS.txt, Nmesh.m
tic
NNQ=1000;
nump=135;
XX=zeros(NNQ,nump*8);
YY=zeros(NNQ,nump*7);
unuse=0;
for i=1:NNQ
    Nmesh();
    [OUTPUT_Nodes, OUTPUT_F, OUTPUT_E, OUTPUT_v, SOLUTION]=Delastic(2);
    XXloadx= OUTPUT_F(1:2:end); 
    XXloady= OUTPUT_F(2:2:end); 
    XXnodex=OUTPUT_Nodes(:,1)';
    XXnodey=OUTPUT_Nodes(:,2)';
    XXbounx=zeros(1, nump);
    XXbouny=zeros(1, nump);
%     if max(SOLUTION(:,1))>1e-5
    for j=1:nump
        if OUTPUT_Nodes(j,3)==1
            XXbounx(j)=1;
            XXbouny(j)=1;
        end
    end
    XXcoefE=ones(1,nump)*OUTPUT_E;
    XXcoefv=ones(1,nump)*OUTPUT_v;
    XX(i-unuse,:)=[XXnodex, XXnodey, XXbounx, XXbouny, XXloadx, XXloady, XXcoefE, XXcoefv];
    YY(i-unuse,:)=SOLUTION(:)';
%     else
%         unuse=unuse+1;
% %         disp(i)
%     end
    if mod(i, 100)==0
        disp(i)
    end
end
toc
% save New_NN45_LWm_Ev_Frand_XX.txt XX -ASCII
% save New_NN45_LWm_Ev_Frand_YY.txt YY -ASCII