function [Zp,Y1p,Y2p,Y3p,Xp,LC1,LC2 ,data] =GAM( M,num_gen,T,P,plotif,outi,outj)
% 本函数使用GA方法解决JOBshop问题，
% 输入变量：
% M: 迭代次数
% num_gen: 基因种群数的因子，真正的基因的种群数是2*num_gen+1
% T 时间矩阵，记录消耗的时间
% plotif: 绘图标志位，如果为1则再运算完成后进行绘图

% 计算基因种群数
N = 2*num_gen+1;

%% 遗传算法初始化
[m,n]=size(T);                                  % 计算T的行数和列数，也是工件数和机器数
Xp={};                                          % 最优染色体中的基因
CHA=zeros(1,m*n);                               % A子代染色体
CHB=zeros(1,m*n);                               % B子代染色体
LC1=zeros(1,M);
LC2=zeros(1,M);
farm=cell(N,1);                                 % 粒子群所有的粒子的集合
Parent={};                                      % 存放父代
BestValue=10000;                                % 存放最优值,初始化非常大的数
BestMakespan=0;
TotalFitness=0;                                 % 存放总适应值
Toltal=0;                                       % 存放累加适应值
FIT1=zeros(N,1);                                % 每个个体的适应度
FIT2=zeros(N,1);                                % 每个个体的选择概率
FitValue=zeros(N,1);                            % 每个个体的选择概率
SelectedGenome=cell(1,1);
BestGenome=cell(1,1);
mparent={};
Chp=zeros(1,1);
m1=cell(N,1);

%% 制造源调度方案
sour = {};
count = 1;
for i = 1 : m
    for j = 1:n
        sour{count} = [i,j];
        count= count + 1;
    end
end

%% 将原调度方案打乱形成随机调度方案
for k=1:N %初始化粒子的初始位置
    randlist = randperm(length(sour));
    for j  = 1:m*n
        farm{k,j}=sour{ randlist( j ) };
    end
end

%% 粒子群迭代
for counter=1:M % 迭代M次
    
    

    
    for d=1:N                                   % 计算每个个体的适应值
        for farmi = 1:n*m
            Xstr{farmi}=farm{d,farmi};          % 从所有的粒子的集合中选择一个
        end
        [Fit, Y1p, Y2p, Y3p]=Fitness(T,Xstr);   % Makspan计算其makspan
        FitValue(d)=1/Fit;                      % 按照适应度计算个体的选择的概率
        FIT1(d)=Fit;
    end
    
    BestMakespan=min(FIT1);                     % 从中选出最好的粒子的位置
    pos1=find(FIT1==BestMakespan);              % 找到最优位置的粒子的序号
    
    for farmi = 1:n*m
        Xp{farmi}=farm{pos1(1),farmi};          % 从所有的粒子的集合中选择一个
    end
    
    % 查找最优染色体
    TotalFitness=sum(FitValue);                 % 计算总适应值-用于轮盘赌的分母
    
    for i=1:N                                   % 计算每个个体选择概率，用于轮盘赌的分子
        FIT2(i)=FitValue(i)/TotalFitness;
    end
    BestValue=min(FIT2);                        % 存放最优值适应值
    
    % 轮盘赌选择，选出N个染色体
    for s=1:num_gen
        WheelSelectionNumber=rand(1);           % 随机产生一个数，作为轮盘赌的指针
        WheelSelectionNumber=WheelSelectionNumber*TotalFitness;
        
        for i=1:N
            Toltal=Toltal+FitValue(i);
            if Toltal>WheelSelectionNumber
                for farmi = 1:n*m
                    SelectedGenome{farmi}=farm{i,farmi}; % 从所有的粒子的集合中选择一个
                end
                break
            end
        end
        
        for farmi = 1:n*m
            Parent{s,farmi}=SelectedGenome{farmi};
        end
        %轮盘赌选择完毕
    end
    
    %% 链内交换操作
    m1={};
    for i=1:num_gen
        for farmi = 1:n*m
            mparent{farmi}=Parent{i,farmi};
        end
        mp11=randi([1,m*n]); % 选择一个要变异的基因的序号
        mp12=randi([1,m*n]); % 再选择一个要变异的基因的序号
        a = min( mp11 ,mp12);
        b = max( mp11 ,mp12);
        if a == b
            if a ~= n*m
                b = a+1;
            else
                a = b-1;
            end
        end
        c=randi([1,m*n]); % 选择一个要变异的基因的序号
        for jiaohuani = a : b
            mid{jiaohuani-a+1} = mparent{ jiaohuani };
        end
        for jiaohuani = a : b
            fromi = jiaohuani +c ;
            if fromi > n*m
                fromi = fromi - n*m;
            end
            [fromi-a+1];
            mparent{jiaohuani} = mid{ jiaohuani -a +1 };
        end
        for jiaohuani = a : b
            fromi = jiaohuani +c ;
            if fromi > n*m
                fromi = fromi - n*m;
            end
            mparent{jiaohuani} = mid{ jiaohuani-a+1 };
        end
        for farmi = 1:n*m
            m1{i, farmi}=mparent{farmi};
        end
    end
    %% 单点变异操作
    m2={};
    for i=1:num_gen
        for farmi = 1:n*m
            mparent{farmi}=Parent{i,farmi};
        end
        bianyicishu = randi([1,floor(m*n)]);
        for bianyii = 1:bianyicishu
            mp1=randi([1,m*n]); % 选择一个要变异的基因的序号
            mp2=randi([1,m*n]); % 再选择一个要变异的基因的序号
            
            Chp=mparent{mp1}; % 进行变异
            mparent{mp1}=mparent{mp2};
            mparent{mp2}=Chp;
        end
        for farmi = 1:n*m
            m2{i, farmi}=mparent{farmi};
        end
        
    end
    for loop = 1:num_gen
        for farmi = 1:n*m
            farm{loop,farmi}=m1{ loop,farmi };               % 从所有的粒子的集合中选择一个
        end
    end
    for loop = 1:num_gen
        for farmi = 1:n*m
            farm{loop+num_gen,farmi}=m2{ loop,farmi };               % 从所有的粒子的集合中选择一个
        end
    end
    farm=[ m1;m2;Xp ];
    %变异完毕
    
    % 整理基因，按照P矩阵。
    for i = 1:N
        farm( i , : ) = zhengli( farm( i , : ) , P )';
    end
    
    LC1(counter)=BestValue;
    LC2(counter)=BestMakespan;
end
disp('BestMakespan=');
disp(BestMakespan);

if plotif == 1
    figure(1);
    plot(LC1);
    figure(2);
    plot(LC2);

    Xstr=Xp;
%     plotif=1;
    
end
[Zp,Y1p,Y2p,Y3p]=makespan(T,Xstr,plotif,outi,outj);


ptime_of_mashine = sum(T,2);
ptime_of_job = sum(T,1);
avetime_mashine = ( sum(T(:)) ) / m;
avetime_job = ( sum(T(:)) ) / n;

patternId = 1;



for i  = 1:m
    for j = 1 : n
        data(patternId,1) = patternId; % 数据编号
        data(patternId,2) = j/n; % 工件号
        data(patternId,3) = ptime_of_mashine(i)/avetime_mashine; % 工件负载
        data(patternId,4) = ptime_of_job(j)/avetime_job; % 机器负载
        data(patternId,5) = T(i,j)/ptime_of_mashine(i) * m; % 相对机器的时间消耗
        data(patternId,6) = T(i,j)/ptime_of_job(i) * n; % 相对工件的时间消耗 
        data(patternId,7) = find( P( j , : ) == i ) / m;  % 工件的工序
%         data(patternId,8) = T(i,j)/ptime_of_job(i) * n; % 相对工件的时间消耗 
        data(patternId,8) = myfind( Xstr,i,j,n,m ) / m/n; % 相对工件的时间消耗 
        patternId = patternId+1;      
    end
end


end

function youxianji = myfind( Xstr , i , j ,n,m)
    for ii = 1:m*n
        if Xstr{ii} == [ i ,j]
            youxianji = ii;
        end
    end
end

