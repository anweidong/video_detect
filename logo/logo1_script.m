addpath('sift');

start_f = 150;
end_f = 200;

i1 = imread('../../code_data/logo/c1.jpg');
im_original = double(rgb2gray(i1));
im_original = imresize(im_original, floor(size(im_original)/6));

i = 22;

fprintf(sprintf('Working on: %d/%d\n', i, end_f));
i2 = imread(sprintf('../../clip_1/%03d.jpg', i));
im_test = double(rgb2gray(i2));
[x2, y2] = logo_detect(im_original, im_test, size(im_original));

f = figure('visible','off');
image(i2);
hold on
if ~isempty(x2) && ~isempty(y2) && max(x2) < size(im_test, 2) && ...
        max(y2) < size(im_test, 1)  ...
        && abs(x2(1)-x2(2))<50 && abs(y2(3)-y2(2))<50
    plot(x2', y2', 'r', 'linewidth', 3);
    coord = [x2(:) y2(:)];
    save(sprintf('../../code_data/logo/logo1_data/coord%03d.mat', i), 'coord', '-mat');
end
im_original = i2(floor(min(y2):max(y2)), floor(min(x2):max(x2)));
print(f, sprintf('../../code_data/logo/logo1_data/%03d.jpg', i), '-djpeg');
for i=start_f+1:end_f
    fprintf(sprintf('Working on: %d/%d\n', i, end_f));
    i2 = imread(sprintf('../../clip_1/%03d.jpg', i));
    im_test = double(rgb2gray(i2));
    [x2, y2] = logo_detect(im_original, im_test, size(im_original));
    
    f = figure('visible','off');
    image(i2);
    hold on
    if ~isempty(x2) && ~isempty(y2) && max(x2) < size(im_test, 2) && ...
            max(y2) < size(im_test, 1)  ...
            && abs(x2(1)-x2(2))<100 && abs(y2(3)-y2(2))<100
        coord = [x2(:) y2(:)];
    else
        % some logos in some images are too clear to be detected, but
        % we know that this video cut from news, so logo's position is 
        % never change, then we can easily copy coord from the last frame.
        % and also change im_original to this 'new logo' for detection
        % because the old one may not be good enough for the later frames.
        coord = load(sprintf('../../code_data/logo/logo1_data/coord%03d.mat', i-1));
        coord = coord.coord;
        x2 = coord(:,1);
        y2 = coord(:,2);
        im_original = i2(floor(min(y2):max(y2)), floor(min(x2):max(x2)));
    end
    
    save(sprintf('../../code_data/logo/logo1_data/coord%03d.mat',i), 'coord', '-mat');
    plot(x2', y2', 'r', 'linewidth', 3);
    print(f, sprintf('../../code_data/logo/logo1_data/%03d.jpg', i), '-djpeg');
end