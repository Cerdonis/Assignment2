function[angle] = ROT_ANG(vec)
x1 = vec(1,1);
y1 = vec(2,1);
x2 = 0;
y2 = 1;

angle = atan2d(x1*y2-y1*x2,x1*x2+y1*y2);
end