addpath('sift');
start_f = 103;
end_f = 103;

i11 = imread('../../code_data/logo/c2.jpg');
i11 = imresize(i11, [30,120]);
i12 = imread('../../code_data/logo/c22.jpg');
i12 = imresize(i12, [30,100]);
i1 = cat(2,i11,i12);
im_original = double(rgb2gray(i1));

for i=start_f:end_f
    fprintf(sprintf('Working on: %d/%d\n', i, end_f));
    i2 = imread(sprintf('../../clip_2/%03d.jpg', i));
    im_test = double(rgb2gray(i2));
    [x2, y2] = logo_detect(im_original, im_test, [30, 220]);
    
    f = figure('visible','off');
    image(i2);
    hold on;
    if ~isempty(x2) && ~isempty(y2) && max(x2) < size(im_test, 2) && ...
            max(y2) < size(im_test, 1) && min(x2) > 0 && min(y2) > 0 ...
            && abs(x2(1)-x2(2))<50 && abs(y2(3)-y2(2))<50
        coord = [x2(:) y2(:)];
        plot(x2', y2', 'r', 'linewidth', 3);
    else
        coord = [];
    end
    save(sprintf('../../code_data/logo/logo2_data/coord%03d.mat', i), 'coord', '-mat');
    print(f, sprintf('../../code_data/logo/logo2_data/%03d.jpg', i), '-djpeg');
    
end