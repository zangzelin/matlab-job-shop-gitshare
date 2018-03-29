% ----------------------------------------------------
% 本程序使用GA算法解决JOBSHOP问题，并画出相应的甘特图。
% JOBSHOP问题的描述见维基百科
% 作者：臧泽林
% 邮箱：zangzelin@gmail.com
% 编写日期：2018-3-20
% 编写地点：杭州
% ----------------------------------------------------

clc
clear

M=1000; % 设置迭代次数
N=20; % 设置基因种群数
plotif=0;% 画图标志位

data = [];
% Pm=0.08;
% Pc=0.9;
for i = 1:1
    
    %     T = randi(20,7,7)  ;
    T = [2	2	15	8	18	3	2;
        16	4	19	19	13	11	6;
        20	19	16	11	7	11	8;
        12	15	12	9	18	7	3;
        11	5	10	18	7	10	1;
        5	19	8	13	20	4	20;
        1	16	12	7	13	7	18;];
    
    [m,n] = size(T);

 
    P = []
    for ii = 1: n
        P = [P; randperm(m)];
    end
    
    best.Zp = 1000;
    
    for j = 1:200
        
        
        %
        %     P =[6,3,7,5,1,2,4;
        %         4,7,1,6,2,3,5;
        %         2,3,7,5,1,4,6;
        %         1,7,4,6,5,2,3;
        %         4,6,7,2,5,1,3;
        %         5,3,7,6,2,1,4;
        %         3,5,4,6,7,1,2];
        % 工件的时间矩阵，行数i，列数j，描述机器i，工序j的需求时间
        
        [Zp,Y1p,Y2p,Y3p,Xp,LC1,LC2,datacurrent] =GAM( M,N,T,P,plotif,i,-1); % 使用GA算法，解决GA问题
        
        if Zp<best.Zp
            best.Zp = Zp;
            best.Y1p = Y1p;
            best.Y2p = Y2p;
            best.Y3p = Y3p;
            best.LC1 = LC1;
            best.LC2 = LC2;
            best.datacurrent = datacurrent;
            
        end
        
        
        
    end
    data = [data;best.datacurrent];
    plotgantplot(T,best.Y1p,best.Y2p,best.Y3p,i,j,best.Zp);
%     disp('ok')
    disp([i,j])

end