function [ output_image ] = gaussian_filter( input_image )
sigma = 6;
window=double(uint8(3*sigma)*2+1);
gausFilter = fspecial('gaussian',window,sigma);
output_image=imfilter(input_image,gausFilter,'replicate');
end

