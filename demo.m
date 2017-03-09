tic;
clear;
clc;

pair_num=1000;     %������ȡ����
filt_size=5;      %������ȡ��Ĵ�С
f_row=56;         %ȡ����Ŀ�
f_col=46;         %ȡ����ĸ�
low_threshold=0;     %��λ��ֵ
high_threshold=16000;   %��λ��ֵ

%���ȷ��ȡ����λ��
                                     %������Ҫ�޸�ȡ����ʽ��������
pair_1=[randi(f_row-filt_size,pair_num,1) randi(f_col-filt_size,pair_num,1)];
pair_2=[randi(f_row-filt_size,pair_num,1) randi(f_col-filt_size,pair_num,1)];
 %save filter pair_1 pair_2
 %load('filter.mat');

num_img = 1;           %�ӵ�������Ƭ����ȡ������ 
num_fdr = 40;          %��ȡ����

%��ȡѵ��������
features=zeros(pair_num,num_img*num_fdr);
filepathsrc = 'att_faces/s';
for i=1:num_fdr
    folderpathsrc = sprintf('%s%d',filepathsrc,i);
    for j=1:num_img
        filename=sprintf('%s%s%d%s',folderpathsrc,'/',j,'.pgm');
        image = imread(filename);  %��ȡͼƬ
        image=gaussian_filter(image);%��˹ģ��
        current_img=imresize(image,[f_row f_col], 'bilinear');
        integral_img=integralImage(current_img);%�������ͼ
        integral_img(:,1)= [];
        integral_img(1,:)= [];
        features(:,(i-1)*num_img+j)=extract_feature(integral_img,pair_num,filt_size,pair_1,pair_2);  %��ȡѵ��������
    end
end

%ѡȡ���Լ�ͼƬ
test_img=imread('test55.jpg');
draw_img1=test_img;
draw_img2=test_img;
figure(1);
imshow(draw_img1);
hold on;
mysize=size(test_img);
if numel(mysize)>2
  test_img=rgb2gray(test_img); %����ɫͼ��ת��Ϊ�Ҷ�ͼ��
end

img_x=size(test_img,2);
img_y=size(test_img,1);        %����ͼƬ�ߴ�

%ɨ�迪ʼ
step_length=4;               %ɨ�貽��
boxes=zeros(10000,6);        %�������б���⵽�������ͷ���(Similarity)
ss=[];                       %��������ͼ���index
box_index=1;
global_min=1000000000;       

%����ѭ��
for s=1:6
    s_scale=1.2^(s-1);               %���ű���
    curr_row=ceil(img_y/s_scale);
    curr_col=ceil(img_x/s_scale);
    
    curr_img=imresize(test_img,[curr_row curr_col], 'bilinear');
    curr_img=gaussian_filter(curr_img);%��˹ģ��
    curr_img=integralImage(curr_img); %�������ͼ          
    curr_img(:,1)= [];
    curr_img(1,:)= [];
    
    step_x=1:step_length:(size(curr_img,2)-f_col);
    step_y=1:step_length:(size(curr_img,1)-f_row);
    %ɨ��ѭ��
    for  m=1:size(step_x,2)
        for n=1:size(step_y,2)
            pick_img=curr_img(step_y(n):step_y(n)+f_row,step_x(m):step_x(m)+f_col);
            curr_feat=extract_feature(pick_img,pair_num,filt_size,pair_1,pair_2);
            feature_map=repmat(curr_feat,1,num_img*num_fdr);               %��������
            %����ŷʽ����
            Features2=(feature_map-features).^2;
            norm_dis=zeros(num_img*num_fdr,1);
            for f = 1:num_img*num_fdr %�����ŷʽ���� ������ֵ�Ƚ�
                norm_dis(f)=floor((sum(Features2(:,f))).^0.5)+1;
            end
            %min_dis=mean(norm_dis);
            min_dis=min(norm_dis);
            %������ֵ����ʱ��¼�µ������
            if  min_dis<high_threshold  && min_dis>low_threshold    
                if min_dis<global_min
                    global_min=min_dis;
                end
                %boxes��ÿ��Ԫ�طֱ���x1,y1,x2,y2,score,1
                boxes(box_index,:)=s_scale*[(m-1)*step_length,(n-1)*step_length,(m-1)*step_length+f_col,(n-1)*step_length+f_row,8000/min_dis,1];
                box_index=box_index+1;
                draw_img1=rectangle('Position',[(m-1)*step_length*s_scale,(n-1)*step_length*s_scale,f_col*s_scale,f_row*s_scale],'EdgeColor','r');
            end
        end
    end
end
fram_1 = getframe(gca);
draw_img1 = frame2im(fram_1);
imwrite(draw_img1,'result_1.jpg');

boxes=boxes(1:box_index,:);
pick_points=[];
pick_points=[pick_points;nms(boxes(:,1:5),0.15)];        %�Ǽ���ֵ����
    
%����
figure(2);
imshow(draw_img2);
hold on;
 for index=1:size(pick_points,1);
        coor_x=boxes(pick_points(index),1);
        coor_y=boxes(pick_points(index),2);
        score=boxes(pick_points(index),5);  
        win_length=boxes(pick_points(index),6); 
        draw_img2=rectangle('Position',[coor_x,coor_y,f_col*win_length,f_row*win_length],'EdgeColor','r'); 
 end
fram_2 = getframe(gca);
draw_img2 = frame2im(fram_2);
imwrite(draw_img2,'result_2.jpg');
toc;




















