function [ feature ] = extract_feature( integral_img ,pair_num,filt_size,pair_1,pair_2)
    %¼ÆËãfeature
    feature=zeros(pair_num,1);
    for j=1:pair_num
        U1=integral_img(pair_1(j,1),pair_1(j,2));
        D1=integral_img(pair_1(j,1)+filt_size,pair_1(j,2)+filt_size);
        L1=integral_img(pair_1(j,1),pair_1(j,2)+filt_size);
        R1=integral_img(pair_1(j,1)+filt_size,pair_1(j,2));
        sum1=U1+D1-L1-R1;
        U2=integral_img(pair_2(j,1),pair_2(j,2));
        D2=integral_img(pair_2(j,1)+filt_size,pair_2(j,2)+filt_size);
        L2=integral_img(pair_2(j,1),pair_2(j,2)+filt_size);
        R2=integral_img(pair_2(j,1)+filt_size,pair_2(j,2));
        sum2=U2+D2-L2-R2;
        feature(j)=sum1-sum2;
    end
end

