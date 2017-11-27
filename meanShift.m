function [X] = meanShift(img_old,img_new, p1, r, h, bins)
%Function calculates the new position X using the Mean Shift algorithm
%   img_old: is the previous (t-1) image
%   img_new: is the current (t) image
%   p1: is the position X in img_old
%   r: is the search radius
%   h: is the Epanechnikov profile parameter
%   bins: is the number of bins utlized in the color histogram

for i = 1:8 %<- Adjust for acc (7 is min X1 1 run build)
    % construct candidate
    X1 = circularNeighbors(img_old, p1(1), p1(2), r); 
    qModel = colorHistogram(X1, bins, p1(1), p1(2), h);
    X2 = circularNeighbors(img_new, p1(1), p1(2), r);
    pTest = colorHistogram(X2, bins, p1(1), p1(2), h);
    % weights
    w = meanshiftWeights(X2, qModel, pTest, bins);
    % compute new value
    newX = sum([X2(:,1) X2(:,2)] .* [w w]) / sum(w);
    p1 = newX;
end
X = p1;
end

