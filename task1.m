clc 
clear
close all

i1 = imread('im1.pgm');
i2 = imread('im2.pgm');
i1 = im2double(i1);
i2 = im2double(i2);

% Smoothing image with Gaussian of radius 5
H = fspecial('gaussian', 11, 0.5); 
Gauss1 = filter2(H, i1);

% Acquiring image gradient
[FX,FY] = gradient(Gauss1);
img = FX+FY;

dx = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
dy = dx.';
Ix = imfilter(img, dx, 'replicate');
Ixpow = Ix.*Ix;
Iy = imfilter(img, dy, 'replicate');
Iypow = Iy.*Iy;
IxIy = Ix.*Iy;

[row, col]=size(img);
R = zeros(row, col);
k = 0.04;

% Build Harris operator with 11*11 patch
for i=6:row-5 
    for j=6:col-5
         sum_Ix2 = sum(sum(Ixpow(i-5:i+5,j-5:j+5)));
         sum_Iy2 = sum(sum(Iypow(i-5:i+5,j-5:j+5)));
         sum_IxIy = sum(sum(IxIy(i-5:i+5,j-5:j+5)));
         H=[sum_Ix2 sum_IxIy;sum_IxIy sum_Iy2];
         R(i,j)=det(H)-k*trace(H).*trace(H);   
    end
end

figure;imshow(R);

% Applying threshold (threshold is not essential in this assignment)
% for i=1:row 
%     for j=1:col
%         if (R(i, j) < 0.01)             
%             R(i, j) = 0; 
%         end
%     end
% end

% Array for storing indices of strongest points
max_ind = zeros(2, 1000);

% Storing strongest points
for cnt=1:1000
    [i, j] = find(R==max(max(R)));
    max_ind(1, cnt) = i;
    max_ind(2, cnt) = j;
    R(i,j) = 0;
end

figure; imshow(i1, []); hold on;    
for cnt=1:1000
	plot(max_ind(2, cnt), max_ind(1, cnt), 'rX'); 
end