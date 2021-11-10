function[max_ind]=MAX_IND2(quant, grad)

    dx = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
    dy = dx.';
    Ix = imfilter(grad, dx, 'replicate');
    Ixpow = Ix.*Ix;
    Iy = imfilter(grad, dy, 'replicate');
    Iypow = Iy.*Iy;
    IxIy = Ix.*Iy;

    [row, col]=size(grad);
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


    % Applying threshold
%     for i=1:row 
%         for j=1:col
%             if (R(i, j) < 0)             
%                 R(i, j) = 0; 
%             end
%         end
%     end
    
%     figure; imshow(R);
    
    % Non-maxima suppression with image dilation
%     local_max = R > imdilate(R, [1 1 1; 1 0 1; 1 1 1]);
%     R = R.*local_max;
    
%     figure; imshow(R);

    % Making disk kernel for Non-maxima suppression
    supp = fspecial('disk', 4);
    for i=1:size(supp,1)
        for j=1:size(supp,2)
            if supp(i,j)==0
                supp(i,j)=1;
            else
                supp(i,j)=0;
            end
        end
    end
    
%     figure; imshow(R);

    % Array for storing indices of strongest points
    max_ind = zeros(2, quant);

    % Apply disk-shaped suppression around strongest points, while storing them
    for cnt=1:quant
        [i, j] = find(R==max(max(R)));
        i = i(1,1);  j = j(1,1);
        max_ind(1, cnt) = i;
        max_ind(2, cnt) = j;
        R(i, j) = 0;
        R = POINT_SUPP(R, i, j, supp); % apply filter to a single point.
    end
end