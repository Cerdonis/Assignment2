function[img] = POINT_SUPP(img, x, y, filt)

[im_r, im_c]=size(img);
[filt_r, filt_c]=size(filt);

r_strt = x-floor(filt_r/2);
c_strt = y-floor(filt_c/2);



for i = 1:filt_r
    
    for j = 1:filt_c
         if (i + r_strt - 1 < 1) || (i + r_strt - 1  > im_r) || (j + c_strt - 1  < 1) || (j + c_strt - 1  > im_c)
            continue;
        end
        img(i + r_strt - 1 , j + c_strt - 1) = img(i + r_strt - 1 , j + c_strt - 1 ) * filt(i, j);
    end
end




