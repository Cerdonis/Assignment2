clc 
clear
close all


i1 = imread('sr1.tif');
i2 = imread('sr2.tif');
i1 = im2double(i1(:,:,1));
i2 = im2double(i2(:,:,1));
orig1 = i1;
orig2 = i2;


% Smoothing image with Gaussian of radius 5
H = fspecial('gaussian', 11, 0.5); 
i1 = filter2(H, i1);
i2 = filter2(H, i2);


% Acquiring image gradient
[FX,FY] = gradient(i1);
i1 = FX+FY;
[FX,FY] = gradient(i2);
i2 = FX+FY;


max_ind=MAX_IND(50, i1);
max_ind2=MAX_IND(50, i2);


patch_quant_1 = 50;
patch_quant_2 = 50;

% 3D storage of 21*21 patches
patch_storage_1 = zeros(21);
for cnt = 1: patch_quant_1 - 1
    patch_storage_1 = cat( 3 , patch_storage_1 , zeros(21) );    
end

patch_storage_2 = zeros(21);
for cnt = 1: patch_quant_2 - 1
    patch_storage_2 = cat( 3 , patch_storage_2 , zeros(21) );    
end

dx = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
dy = dx.';
Ix = imfilter(i1, dx, 'replicate');
Ixpow = Ix.*Ix;
Iy = imfilter(i1, dy, 'replicate');
Iypow = Iy.*Iy;
IxIy = Ix.*Iy;

% Feature detector for im1
for cnt=1:patch_quant_1
    i = max_ind(1,cnt);
    j = max_ind(2,cnt);

    sum_Ix2 = sum(sum(Ixpow(i-5:i+5,j-5:j+5)));
    sum_Iy2 = sum(sum(Iypow(i-5:i+5,j-5:j+5)));
    sum_IxIy = sum(sum(IxIy(i-5:i+5,j-5:j+5)));
    H=[sum_Ix2 sum_IxIy;sum_IxIy sum_Iy2];
    % Calculate dominant orientation & eigenvector ratio
    [dom_ori, ratio]=DOM_ORI(H);
    % Rotate a temporary bigger patch of 33*33.
    temp = imrotate(PATCH(33, i, j, orig1), -ROT_ANG(dom_ori),'bilinear','crop');
%     figure;imshow(temp);
    % Store the central 21*21 patch
    patch_storage_1(:, :, cnt) = PATCH(21, 16, 16, temp);
    % Multiply eigenvector ratio
    patch_storage_1(:, :, cnt) =  ratio*patch_storage_1(:, :, cnt);
%     figure;imshow(patch_storage_1(:, :, cnt));
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ix = imfilter(i2, dx, 'replicate');
Ixpow = Ix.*Ix;
Iy = imfilter(i2, dy, 'replicate');
Iypow = Iy.*Iy;
IxIy = Ix.*Iy;



% Feature detector for im2
for cnt=1:patch_quant_2
    i = max_ind2(1,cnt);
    j = max_ind2(2,cnt);

    sum_Ix2 = sum(sum(Ixpow(i-5:i+5,j-5:j+5)));
    sum_Iy2 = sum(sum(Iypow(i-5:i+5,j-5:j+5)));
    sum_IxIy = sum(sum(IxIy(i-5:i+5,j-5:j+5)));
    H=[sum_Ix2 sum_IxIy;sum_IxIy sum_Iy2];
    [dom_ori, ratio]=DOM_ORI(H);
    temp = imrotate(PATCH(33, i, j, orig2), -ROT_ANG(dom_ori),'bilinear','crop');
%     figure;imshow(temp);
    patch_storage_2(:, :, cnt) = PATCH(21, 16, 16, temp);
    patch_storage_2(:, :, cnt) =  ratio*patch_storage_2(:, :, cnt);
%     figure;imshow(patch_storage_1(:, :, cnt));
end 

% Distance matrix for pairs of patches (SSD, NCC)
ssd_table = zeros(patch_quant_1, patch_quant_2);
ncc_table = ssd_table;

% Filling the distance matrix
for i=1:patch_quant_1
    for j=1:patch_quant_2
        sd = patch_storage_1(:,:,i) - patch_storage_2(:,:,j);
        ssd_table(i, j) = sum(sd(:).^2);
        ncc = normxcorr2(patch_storage_2(:,:,j), patch_storage_1(:,:,i));
        ncc_table(i, j) = max(max(ncc));
    end
end

figure(1); imshow(ncc_table);
figure(2); imshow(ssd_table/mean(mean(ssd_table)));
    
% Designated number of top match
ssd_match = zeros(10, 2);
ncc_match = ssd_match;
for i=1:10
   
    [f1, f2] = find(ssd_table==min(min(ssd_table)));
    f1 = f1(1,1);  f2 = f2(1,1);
    ssd_match(i, 1) = f1;
    ssd_match(i, 2) = f2;
    ssd_table(:,f2) = 200*ones(size(ssd_table(:,f2)));
    ssd_table(f1,:) = 200*ones(size(ssd_table(f1,:)));

    [f1, f2] = find(ncc_table==max(max(ncc_table)));
    f1 = f1(1,1);  f2 = f2(1,1);
    ncc_match(i, 1) = f1;
    ncc_match(i, 2) = f2;
    ncc_table(:,f2) = zeros(size(ncc_table(:,f2)));
    ncc_table(f1,:) = zeros(size(ncc_table(f1,:)));
    
end

max_ind=max_ind.';
max_ind2=max_ind2.';
% showMatching(orig1, orig2, max_ind, max_ind2, ncc_match);
showMatching(orig1, orig2, max_ind, max_ind2, ssd_match);




