% 长度随机+荷载随机+Tension随机
load MSHDAT.txt -ASCII
load NODES.txt  -ASCII

NUMEL = MSHDAT(2);
NUMNP = NUMEL+1;
MHDAT=MSHDAT;

NNQ=10000;
XX=zeros(NNQ,NUMNP*4);
YY=zeros(NNQ,NUMNP);
for i=1:NNQ
    T=rand(1,1)*4000+6000;
    MHDAT(1)=T;
    
    L=rand(1,1)*90+10;
    NODES(:,1)=linspace(0, L, 101);
    
    Fn=randi(NUMNP+1);
    FF=zeros(NUMNP,1);
    FF(1:Fn)=rand(1,Fn)*45+5;
    F=FF(randperm(NUMNP));
    NODES(:,4)=F;
    
    XXnodex=NODES(:,1)';
    XXbounx=NODES(:,2)';
    XXtensio=ones(1,NUMNP)*T;
    XX(i,:)=[XXnodex, XXbounx, F',  XXtensio];
    
    YY(i,:)=wire(MHDAT, NODES);
    if mod(i,100)==0
        disp(i)
    end
    
end
save 1Wire_XX.txt XX -ASCII
save 1Wire_YY.txt YY -ASCII
