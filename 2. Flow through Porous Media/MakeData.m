% pile�ĳߴ����+�߽�PHI���+������͸ϵ�����
% ��Ҫ����DINITIAL������Ĭ��ΪConstant heads in both upstream and downstream
NNQ=10;
nump=154;
XX=zeros(NNQ,nump*5);
YY=zeros(NNQ,nump);
for i=1:NNQ
    Nmesh();
    [OUT_Nodes,OUT_NPBC,OUT_PHI,IN_RI,PHI] = Dpoisson();

    XXnodex=OUT_Nodes(:,1)';
    XXnodey=OUT_Nodes(:,2)';
    XXNPBC=OUT_NPBC;
    XXPHI=OUT_PHI;
    XXRI=ones(1,nump)*IN_RI;

    XX(i,:)=[XXnodex, XXnodey, XXNPBC, XXPHI, XXRI];
    YY(i,:)=PHI;
    if mod(i, 100)==0
        disp(i)
    end
end
% save 2Dam_Imp_XX.txt XX -ASCII
% save 2Dam_Imp_YY.txt YY -ASCII
save 2Dam_Con_XX.txt XX -ASCII
save 2Dam_Con_YY.txt YY -ASCII
% ������Ҫ����������������ݽ��кϲ������