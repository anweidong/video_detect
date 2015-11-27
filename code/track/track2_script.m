frame_dir = '../../clip_2';
start = 65;

% save visualization to file
addpath('export_fig');
out_dir = '../../code_data/track_data/clip2_tracks';
% load tracklets
load ../../code_data/track_data/tracklets2
tracklets = tracklets2;

% for all frames do
h = figure('Position',[10 100 840 480]); axes('Position',[0 0 1 1]);
for i=1:length(tracklets)
    bbox = [];
    if ~isempty(tracklets{i})
        bbox(:,1) = [tracklets{i}.x1]';
        bbox(:,2) = [tracklets{i}.y1]';
        bbox(:,3) = [tracklets{i}.x2]';
        bbox(:,4) = [tracklets{i}.y2]';
        %bbox = sortrows(bbox);
        bbox(:,5) = 1:size(bbox, 1);
    end

    name = sprintf('%03d.jpg', i+start-1);
    im = imread(fullfile(frame_dir, name));
    cla; plot_bbox(im,bbox);
    refresh; pause(0.05);
    export_fig(h,sprintf('%s/%03dtracks.jpg',out_dir,i+start-1));

end

% done
fprintf('done!\n');
