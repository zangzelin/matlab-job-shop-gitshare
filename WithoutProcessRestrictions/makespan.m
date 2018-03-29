function [Fit,Y1p,Y2p,Y3p]=makespan(T,Xstr,plotif)
% X 工序矩阵
% T 时间矩阵
% Xstr 工件的优先级
% clear Xstr

[ number_of_mashine , number_of_job] = size(T);




N = length(Xstr);
mashine_busy = zeros(1,number_of_mashine);
job_busy = zeros(1,number_of_job);

Time_start = zeros(number_of_mashine,number_of_job);
Time_end = zeros(number_of_mashine,number_of_job);

mashine_next_end_time = zeros(1,number_of_mashine);
job_next_end_time = zeros(1,number_of_job);

job_count_in_mashine =zeros(1,number_of_mashine)+1; 
% job_count_in_mashine =zeros(1,4); 

for i = 1:N
    % current_job = Xstr(i); % 提取当前的处理的工作指向
        
        current_job = Xstr{i}(1); % 当前的工件
        current_mashine = Xstr{i}(2); % 当前的机器
        
        current_job_count_in_mashine = job_count_in_mashine( current_mashine ) ; % 提取当前的机器的工作的次数。

        Time_start( current_mashine,current_job_count_in_mashine ) = max(mashine_next_end_time( current_mashine ), job_next_end_time( current_job )); % 提取开始时间
        Time_end( current_mashine,current_job_count_in_mashine ) = Time_start( current_mashine,current_job_count_in_mashine )+ T( current_job,current_mashine ); % 计算结束时间
        
        mashine_next_end_time( current_mashine ) = Time_end( current_mashine,current_job_count_in_mashine ); % 赋值新的结束时间
        job_next_end_time( current_job ) = Time_end( current_mashine,current_job_count_in_mashine );
        job_count_in_mashine( current_mashine ) = job_count_in_mashine( current_mashine )+ 1;
        % Time_start( current_mashine , current_job_count_in_mashine ) = 
        bianhao( current_mashine,  current_job_count_in_mashine) = current_job;
%         Time_start( Xstr() )

end






% %% 初始化
% [m,n]=size(X);
% Y1p=zeros(m,n);
% Y2p=zeros(m,n);
% Y3p=zeros(m,n);
% Q1=zeros(m,n);
% Q2=zeros(m,n);
% Kt=zeros(m,n);
% J=zeros(1,m*n);
% K=zeros(1,n);

% %% 测试用，遗传算法注释掉以下

% %for k=1:N %初始化
% %a=repmat(1:m,1,n)
% %pos=a(randperm(length(a)))        %记录行（job）
% %farm{k}=pos;
% %Xstr=farm{k};
% %end
% %遗传算法注释掉以上

% Nu=zeros(1,m);
% Q1(Xstr(1),1)=0;  % 开始点从0开始
% Q2(Xstr(1),1)=T( Xstr(1),1);  % 第一个工序，描述工件在机器Xstr(1)上的加工开始和结束时间
% Nu(Xstr(1))=1;

% for i=2:m*n                       % 记录基因查找顺序数
%     Nu(   Xstr(i)) = Nu(Xstr(i))+1;      % 记录列（工序）
%     if Nu( Xstr(i) )==1
%         Kt=Nu;
%         j=i-1;                         %记录上一个序号
%         while j ~= 0  &&  X(  Xstr( j )  ,   Kt(   Xstr( j )  )  ) ~= X(  Xstr(i) ,  1 )
%             Kt(Xstr(j))=Kt(Xstr(j))-1;
%             j=j-1;
%         end
        
%         % 如果是开头的一列，直接开始时间设为0，如果不是，开始时间设为改行的上一个的结尾
%         if j~=0  % j 为工序的当前的列数
%             Q1( Xstr(i), 1 ) = Q2(  Xstr(j),  Kt(Xstr(j))  ); % 
%             Q2( Xstr(i), 1 ) = Q1(  Xstr(i), 1)  +  T( Xstr(i) , 1 ); % 
%         else  %为第一列工序
%             Q1(Xstr(i),1)=0;
%             Q2(Xstr(i),1)=Q1(Xstr(i),1)+T(Xstr(i),1); 
%         end
        
%     else
%         if Nu(Xstr(i))>=2
            
%             T1=Q2(Xstr(i),Nu(Xstr(i))-1);%此工件的前一工序的时间
            
%             Kt=Nu;
%             Kt(Xstr(i))=Kt(Xstr(i))-1;
%             j=i-1;
%             while j~=0 &&   X(   Xstr(j) , Kt(Xstr(j)))  ~=  X(Xstr(i),  Nu(Xstr(i))  )
%                 Kt(Xstr(j))=Kt(Xstr(j))-1;
%                 j=j-1;
%             end
%             if j~=0
%                 T2=Q2(Xstr(j),Kt(Xstr(j)));
%                 Tmax=[T1,T2];
%                 Q1(Xstr(i),Nu(Xstr(i)))=max(Tmax);
%                 Q2(Xstr(i),Nu(Xstr(i)))=Q1(Xstr(i),Nu(Xstr(i)))+T(Xstr(i),Nu(Xstr(i)));
%             else
%                 Q1(Xstr(i),Nu(Xstr(i)))=0;
%                 Q2(Xstr(i),Nu(Xstr(i)))=Q1(Xstr(i),Nu(Xstr(i)))+T(Xstr(i),1);
%             end
%         end
%     end
    
    Y1p=Time_start; % 开始点的集合
    Y2p=Time_end; % 结束点的集合
    Y3p=bianhao; % 工件编号的集合
% end


Fit=max(Y2p(:,number_of_job));
zzl = figure(100)
for i=1:number_of_mashine
    for j=1:number_of_job
        
        % 数据读写
        mPoint1=Y1p(i,j);  % 读取开始的点
        mPoint2=Y2p(i,j);  % 读取结束的点
        mText=number_of_mashine+1-i;  % 读取机器编号
        PlotRec(mPoint1,mPoint2,mText); % 画图函数，（开始点，结束点，高度）
        Word=num2str(Y3p(i,j)); % 读取工件编号
        hold on

        % 填充
        x1=mPoint1;
        y1=mText-1;
        x2=mPoint2;
        y2=mText-1;
        x3=mPoint2;
        y3=mText;
        x4=mPoint1;
        y4=mText;
        fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,0.5,1]);
        
        % 书写文字
        text(0.5*mPoint1+0.5*mPoint2,mText-0.5,Word);
    end
end

hold off
% close(zzl)
end
function PlotRec(mPoint1,mPoint2,mText)

vPoint=zeros(4,2);
vPoint(1,:)=[mPoint1,mText-1];
vPoint(2,:)=[mPoint2,mText-1];
vPoint(3,:)=[mPoint1,mText];
vPoint(4,:)=[mPoint2,mText];
plot([vPoint(1,1),vPoint(2,1)],[vPoint(1,2),vPoint(2,2)]);
hold on
plot([vPoint(1,1),vPoint(3,1)],[vPoint(1,2),vPoint(3,2)]);
plot([vPoint(2,1),vPoint(4,1)],[vPoint(2,2),vPoint(4,2)]);
plot([vPoint(3,1),vPoint(4,1)],[vPoint(3,2),vPoint(4,2)]);

end

