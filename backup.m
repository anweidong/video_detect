function face_track(frame_dir, det_dir, start_frame, end_frame)
% frame_dir is a path to the images
% det_dir is a path to the image detections
% start_ and end_frame are the index of start and end images
path=[];
FRAME_DIR = frame_dir;
DET_DIR = det_dir;
for i = start_frame:end_frame
    if isempty(strfind(frame_dir,'clip_3'))==0
        name = sprintf('%04d.jpg', i);
        name_next = sprintf('%04d.jpg', i+1);
        det_name = sprintf('%04d.mat', i);
        det_name_next = sprintf('%04d.mat', i+1);
    else
        name = sprintf('%03d.jpg', i);
        name_next = sprintf('%03d.jpg', i+1);
        det_name = sprintf('%03d.mat', i);
        det_name_next = sprintf('%03d.mat', i+1);
    end
    im_cur = imread(fullfile(FRAME_DIR, name));
    data = load(fullfile(DET_DIR, det_name));
    dets_cur = data.det;   
    im_next = imread(fullfile(FRAME_DIR, name_next));
    data = load(fullfile(DET_DIR, det_name_next));
    dets_next = data.det;
    sim = compute_similarity(dets_cur, dets_next, im_cur, im_next);
    [d1,d2] = find(sim~=0);
    if i == start_frame
        for di=1:size(d1,1)
            path = [path;sim(d1(di),d2(di)),d1(di),d2(di)];
        end
    else
        new_path = [];
        for di=1:size(d1,1)
            for dj=1:size(path,1)
                if d1(di)==path(dj,size(path,2))
                    new_path = [new_path;path(dj,1)+sim(d1(di),d2(di)),...
                        path(dj,2:size(path,2)),d2(di)];
                end
            end
        end
        path = new_path;
    end
end
[~, order] = sort(path(:,1));
path = path(order,:);
path(:,2:size(path,2));
result = [];
while isempty(path)~=1
    result = [result;path(1,2:size(path,2))];
    for i=1:size(path,1)
        current_path = result(size(result,1),:);
        % delete the duplicate
        for j=1:size(current_path,2)
            if path(i,j+1)==current_path(1,j)
                path(i,:) = zeros(1,size(path,2));
            end
        end
    end
    path(~any(path,2),:) = [];
end
c = ['r' 'b' 'g' 'c' 'y' 'm']';
for i = start_frame:end_frame
    if isempty(strfind(frame_dir,'clip_3'))==0
        name = sprintf('%04d.jpg', i);
        det_name = sprintf('%04d.mat', i);
    else
        name = sprintf('%03d.jpg', i);
        det_name = sprintf('%03d.mat', i);
    end
    im = imread(fullfile(FRAME_DIR, name));
    data = load(fullfile(DET_DIR, det_name));
    dets = data.det;
    boxes = dets(result(:,i-start_frame+1),1:4);
    figure;
    image(im);
    axis image;
    axis off;
    hold on;
    for j=1:size(boxes,1)
        showboxesMy(boxes(j,:),c(j));
    end
end
end

% helper functions from csc420 Assignment5 starter code
function sim = compute_similarity(dets_cur, dets_next, im_cur, im_next)

n = size(dets_cur, 1);
m = size(dets_next, 1);
sim = zeros(n, m);


area_cur = compute_area(dets_cur);
area_next = compute_area(dets_next);
c_cur = compute_center(dets_cur);
c_next = compute_center(dets_next);
im_cur = double(im_cur);
im_next = double(im_next);
weights = [1,1,2];

for i = 1: n
    % compare sizes of boxes
    a = area_cur(i) * ones(m, 1);
    sim(i, :) = sim(i, :) + weights(1) * (min(area_next, a) ./ max(area_next, a))';
    
    % penalize distance (would be good to look-up flow, but it's slow to
    % compute for images of this size)
    sim(i, :) = sim(i, :) + weights(2) * exp((-0.5*sum((repmat(c_cur(i, :), [size(c_next, 1), 1]) - c_next).^2, 2)) / 5^2)';
    
    % compute similarity of patches
    box = round(dets_cur(i, 1:4));
    box(1:2) = max([1,1],box(1:2));
    box(3:4) = [min(box(3),size(im_cur, 2)), min(box(4),size(im_cur, 1))];
    im_i = im_cur(box(2):box(4),box(1):box(3), :);
    im_i = im_i / norm(im_i(:));
    for j = 1 : m
       d = norm(c_cur(i, :) - c_next(j, :));
       if d>60  % distance between boxes too big
           sim(i,j) = 0;
           continue;
       end;
       box = round(dets_next(j, 1:4));
       box(1:2) = max([1,1],box(1:2));
       box(3:4) = [min(box(3),size(im_cur, 2)), min(box(4),size(im_cur, 1))]; 
       im_j = im_next(box(2):box(4),box(1):box(3), :);
       im_j = double(imresize(uint8(im_j), [size(im_i, 1), size(im_i, 2)]));
       im_j = im_j / norm(im_j(:));
       c = sum(im_i(:) .* im_j(:));
       sim(i,j) = sim(i,j) + weights(3) * c;
    end;
end;
end

function area = compute_area(dets)
   area = (dets(:, 3) - dets(:, 1) + 1).* (dets(:, 4) - dets(:, 2) + 1);
end

function c = compute_center(dets)

c = 0.5 * (dets(:, [1:2]) + dets(:, [3:4]));
end
