clear all; close all; dbstop error;

% settings
base_dir = '/home/geiger/5_Data/kitti/2012_raw_data_extract';
seq_dir = [base_dir '/2011_09_26/2011_09_26_drive_0056'];
%seq_dir = [base_dir '/2011_09_26/2011_09_26_drive_0059'];
%seq_dir = [base_dir '/2011_09_29/2011_09_29_drive_0026'];

% save visualization to file
save_to_file = 1;

% image directory
img_dir = [seq_dir '/image_02/data'];
if save_to_file
  addpath('export_fig');
  out_dir = [seq_dir '/track_02'];
  mkdir(out_dir);
end

% load tracklets
tracklets = labels_read([seq_dir '/tracking_results.txt']);

% for all frames do
h = figure('Position',[10 100 1200 360]); axes('Position',[0 0 1 1]);
for i=1:length(tracklets)
  bbox = [];
  if ~isempty(tracklets{i})
    bbox(:,1) = [tracklets{i}.x1]';
    bbox(:,2) = [tracklets{i}.y1]';
    bbox(:,3) = [tracklets{i}.x2]';
    bbox(:,4) = [tracklets{i}.y2]';
    bbox(:,5) = [tracklets{i}.alpha]';
    bbox(:,6) = [tracklets{i}.score]';
    bbox(:,7) = [tracklets{i}.id]';
  end
  im = imread(sprintf('%s/%010d.png',img_dir,i-1));
  cla; plot_bbox(im,bbox);
  refresh; pause(0.05);
  if save_to_file
    export_fig(h,sprintf('%s/%010d.png',out_dir,i-1));
  end
end

% done
fprintf('done!\n');
