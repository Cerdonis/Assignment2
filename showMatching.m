% Visualization of image matching
% Ilwoo Lyu
%
% I1=imread('im1'); % left image
% I2=imread('im2'); % right image
% X = [x, y] % feature locations (left)
% Y = [x, y] % feature locations (right)
% m = [f1, f2] % feature ID (left) and feature ID (right) - this should be
% constructed by some metrics (SSD, NCC, etc.)

function showMatching(I1,I2, X, Y, m)
    
    w1=length(I1);
%     Y(:, 1) = Y(:, 1) + w1*ones(size(Y(:, 1)));
    I=[I1, I2];
    imshow(I);
    hold on;
    for cnt=1:length(X)
        plot(X(cnt, 2), X(cnt, 1), 'rX'); 
    end
    for cnt=1:length(Y)
        plot(Y(cnt, 2)+w1, Y(cnt, 1), 'rX'); 
    end
    
    if nargin == 5
        c = jet(length(m));
        for i = 1: length(m)
            plot([X(m(i,1),2),Y(m(i,2),2)+w1], [X(m(i,1),1), Y(m(i,2), 1)],'color',c(i,:),'LineWidth',1);
            text(X(m(i,1), 2), X(m(i,1), 1), num2str(i),'color',c(i,:),'fontsize', 10);
            text(Y(m(i,2),2)+w1, Y(m(i,2), 1), num2str(i),'color',c(i,:),'fontsize', 10);
        end
    end
    hold off;
end

function showCorner(key_x, key_y)
    plot(key_x,key_y,'X','markersize',8,'color','red');
end