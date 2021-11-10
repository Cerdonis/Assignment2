function[patch] = PATCH(len, r, c, img)

    [im_r, im_c]=size(img);
    patch = zeros(len);

    r_strt = r-floor(len/2);
    c_strt = c-floor(len/2);

    for i = 1:len
        for j = 1:len
            if (i + r_strt - 1 < 1) || (i + r_strt - 1  > im_r) || (j + c_strt - 1  < 1) || (j + c_strt - 1  > im_c)
                patch(i, j) = rand;
                continue;
            end            
            patch(i, j) = img(i + r_strt - 1 , j + c_strt - 1);
        end
    end

end