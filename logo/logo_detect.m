function [x2, y2] = logo_detect(im_original, im_test, resiz)

addpath('sift');

if nargin>2
    im_original =imresize(im_original, resiz);
end

% figure;
% imagesc(im_original);
[f1, d1, ~, ~] = sift(im_original);
% figure;
% imagesc(im_test);
[f2, d2, ~, ~] = sift(im_test);

% set ratio threshold of distances (closest/next closest)
threshold = 0.8;

% arguments for dist2 function
x = d1';
c = d2';
% compare each distance, dist(i,j) is the i-th des in i1 and j-th des in i2
% dist = dist2(d1t, d2t)
[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
    error('Data dimension does not match dimension of centres')
end
n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
    ones(ndata, 1) * sum((c.^2)',1) - ...
    2.*(double(x)*double(c'));
dist = n2.^0.5;
% put index of every interest point in f1 into matchtable
% if different points match to the same point in test image,
% always matching the smallest ratio
ind_l = ones(2, size(f2, 2));
for i = 1:size(dist, 1)
    [d, ind] = sort(dist(i,:));
    ratio_ind = ind_l(:, ind(1));
    ratio = ratio_ind(1);
    index = ratio_ind(2);
    % get closet d1 and second closet d2
    if (d(1)/d(2) < threshold) && (ratio==1)
        matchTable(i) = ind(1);
        ind_l(:,ind(1)) = [d(1)/d(2) i]';
    elseif (d(1)/d(2) < threshold) && (d(1)/d(2) < ratio)
        matchTable(i) = ind(1);
        matchTable(index) = 0;
        ind_l(:,ind(1)) = [d(1)/d(2) i]';
    else
        matchTable(i) = 0;
    end
end
% get a set of interest points nf1 and nf2
[match, j] = sort(matchTable, 'descend');
match = match(match~=0);
nf1 = zeros(2,size(match,2));
nf2 = zeros(2,size(match,2));
for ix=1:size(match,2)
    nf1(:,ix) = f1(1:2,j(ix));
    nf2(:,ix) = f2(1:2,matchTable(j(ix)));
end
x2 = [];
y2 = [];
if ~isempty(match)
    % iterate 7000 times for RANSAC
    % set max
    ma = 0;
    Am = zeros(2,3);
    for p = 1: 7000
        % random 3 correspondences
        r = randi(size(match,2), 1, 3);
        new_f1 = [nf1(:,r(1)) nf1(:,r(2)) nf1(:,r(3))];
        new_f2 = [nf2(:,r(1)) nf2(:,r(2)) nf2(:,r(3))];
        
        % get xi, yi
        f1vec = new_f1(:);
        x1 = f1vec(1);
        y1 = f1vec(2);
        x2 = f1vec(3);
        y2 = f1vec(4);
        x3 = f1vec(5);
        y3 = f1vec(6);
        
        % get xi', yi' and P'
        Ptest = new_f2(:);
        
        % get P
        P = [x1 y1 0 0 1 0; ...
            0 0 x1 y1 0 1; ...
            x2 y2 0 0 1 0; ...
            0 0 x2 y2 0 1; ...
            x3 y3 0 0 1 0; ...
            0 0 x3 y3 0 1];
        % get A
        if rank(P) == min(size(P))
            A = P \ Ptest;
            A = [A(1) A(2) A(5);A(3) A(4) A(6)];
            %get inlier
            p2 = A * [nf1(1,:)' nf1(2,:)' ones(1,size(nf1,2))']';
            
            dis = abs(p2 - nf2);
            dis = sqrt(dis(1,:).^2+dis(2,:).^2);
            if ma < size(dis(dis<1),2)
                ma = size(dis(dis<1),2);
                Am = A;
            end
        end
    end
    
    
    x_img = [1 1 size(im_original,2) size(im_original,2) 1]';
    y_img = [1 size(im_original,1) size(im_original,1) 1 1]';
    
    for j = 1:size(x_img)
        xy = (Am * [x_img(j) y_img(j) 1]')';
        x2(j) = xy(1);
        y2(j) = xy(2);
    end
end
x2 = x2';
y2 = y2';
end

