function [c1,c2,c3,c4,c5] = splitFrame(img, y, x1, x2)
%Function splits the input image into 5 seperate images
%   img: the orginal single image with 5 camera views
%   y: y location to split on
%   x1: first x location to split on
%   x2: second x location to split on

c1 = img(1:y, 1:x1, :);
c2 = img((y + 1):end, 1:x1, :);
c3 = img(1:end, (x1 + 1):x2, :);
c4 = img(1:y, (x2 + 1):end, :);
c5 = img((y+1):end, (x2 + 1):end,:);
end

