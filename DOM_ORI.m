function[dom_ori, ratio] = DOM_ORI(mat)
    dom_ori = [0 ; 0];
    [v, d] = eigs(mat);
    if d(1,1) > d(2,2)
        dom_ori = v(:,1);
        ratio = sqrt(d(1,1) / d(2,2));        
    else
        dom_ori = v(:,2);
        ratio = sqrt(d(2,2) / d(1,1));  
    end

end