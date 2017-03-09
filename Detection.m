function [ draw_img2 ] = Detection( input_image )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
pair_num=1000;     %特征提取对数
filt_size=5;      %特征提取框的大小
f_row=56;         %取样框的宽
f_col=46;         %取样框的高
low_threshold=0;     %低位阈值
high_threshold=16000;   %高位阈值

%随机确定取特征位置
                                     %这里需要修改取样方式避免框到左边
pair_1=[randi(f_row-filt_size,pair_num,1) randi(f_col-filt_size,pair_num,1)];
pair_2=[randi(f_row-filt_size,pair_num,1) randi(f_col-filt_size,pair_num,1)];
 %save filter pair_1 pair_2
 %load('filter.mat');

num_img = 1;           %从单个人照片中提取样本数 
num_fdr = 40;          %提取人数

%提取训练集特征
features=zeros(pair_num,num_img*num_fdr);
filepathsrc = 'att_faces/s';
for i=1:num_fdr
    folderpathsrc = sprintf('%s%d',filepathsrc,i);
    for j=1:num_img
        filename=sprintf('%s%s%d%s',folderpathsrc,'/',j,'.pgm');
        image = imread(filename);  %读取图片
        image=gaussian_filter(image);%高斯模糊
        current_img=imresize(image,[f_row f_col], 'bilinear');
        integral_img=integralImage(current_img);%计算积分图
        integral_img(:,1)= [];
        integral_img(1,:)= [];
        features(:,(i-1)*num_img+j)=extract_feature(integral_img,pair_num,filt_size,pair_1,pair_2);  %提取训练集特征
    end
end

%选取测试集图片
test_img=input_image;
mysize=size(test_img);
if numel(mysize)>2
  test_img=rgb2gray(test_img); %将彩色图像转换为灰度图像
end

img_x=size(test_img,2);
img_y=size(test_img,1);        %保存图片尺寸

%扫描开始
step_length=4;               %扫描步长
boxes=zeros(10000,6);        %保存所有被检测到框的坐标和分数(Similarity)
box_index=1;
global_min=1000000000;       

%缩放循环
for s=1:6
    s_scale=1.2^(s-1);               %缩放倍数
    curr_row=ceil(img_y/s_scale);
    curr_col=ceil(img_x/s_scale);
    
    curr_img=imresize(test_img,[curr_row curr_col], 'bilinear');
    curr_img=gaussian_filter(curr_img);%高斯模糊
    curr_img=integralImage(curr_img); %计算积分图          
    curr_img(:,1)= [];
    curr_img(1,:)= [];
    
    step_x=1:step_length:(size(curr_img,2)-f_col);
    step_y=1:step_length:(size(curr_img,1)-f_row);
    %扫描循环
    for  m=1:size(step_x,2)
        for n=1:size(step_y,2)
            pick_img=curr_img(step_y(n):step_y(n)+f_row,step_x(m):step_x(m)+f_col);
            curr_feat=extract_feature(pick_img,pair_num,filt_size,pair_1,pair_2);
            feature_map=repmat(curr_feat,1,num_img*num_fdr);               %保存特征
            %计算欧式距离
            Features2=(feature_map-features).^2;
            norm_dis=zeros(num_img*num_fdr,1);
            for f = 1:num_img*num_fdr %计算出欧式距离 并与阈值比较
                norm_dis(f)=floor((sum(Features2(:,f))).^0.5)+1;
            end
            %min_dis=mean(norm_dis);
            min_dis=min(norm_dis);
            %满足阈值条件时记录下点的坐标
            if  min_dis<high_threshold  && min_dis>low_threshold    
                if min_dis<global_min
                    global_min=min_dis;
                end
                %boxes中每列元素分别是x1,y1,x2,y2,score,1
                boxes(box_index,:)=s_scale*[(m-1)*step_length,(n-1)*step_length,(m-1)*step_length+f_col,(n-1)*step_length+f_row,8000/min_dis,1];
                box_index=box_index+1;
            end
        end
    end
end


boxes=boxes(1:box_index,:);
pick_points=[];
pick_points=[pick_points;nms(boxes(:,1:5),0.15)];        %非极大值抑制
    
%画框
 for index=1:size(pick_points,1);
        coor_x=boxes(pick_points(index),1);
        coor_y=boxes(pick_points(index),2); 
        win_length=boxes(pick_points(index),6); 
        rectangle('Position',[coor_x,coor_y,f_col*win_length,f_row*win_length],'EdgeColor','r'); 
 end
fram_2 = getframe(gca);
draw_img2 = frame2im(fram_2);
end

