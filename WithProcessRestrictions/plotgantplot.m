function [] = plotgantplot(T,Y1p,Y2p,Y3p,outi,outj,Fit)
    [ number_of_mashine , number_of_job] = size(T);
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
    title(num2str( Fit ));
    str = [ 'pic\i_',num2str(outi),'j_',num2str(outj),'.png' ]
    saveas( zzl ,str )
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