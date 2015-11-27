frame_dir = 'clip_1';
ind = 64;
% frame_dir2 = 'clip_2';
% frame_dir3 = 'clip_3';

% load tracklets
t = face_track(frame_dir, 'code/dpm/clip1_det', 22, 200);
tracklets = convertToKITTI(t, 22, 200);
% labels_write(t,'c1.txt');
% tracklets = labels_read('c1.txt')

% for all frames do
h = figure('Position',[10 100 1200 360]); axes('Position',[0 0 1 1]);
length(tracklets)
for i=1:length(tracklets)
  bbox = [];
  if ~isempty(tracklets{i})
    bbox(:,1) = [tracklets{i}.x1]';
    bbox(:,2) = [tracklets{i}.y1]';
    bbox(:,3) = [tracklets{i}.x2]';
    bbox(:,4) = [tracklets{i}.y2]';
    %bbox(:,5) = 1;
  end
  if isempty(strfind(frame_dir,'clip_3'))==0
      name = sprintf('%04d.jpg', i+ind-1);
  else
      name = sprintf('%03d.jpg', i+ind-1);
  end
  im = imread(fullfile(frame_dir, name));
  cla; plot_bbox(im,bbox);
  refresh; pause(0.05);
end

% done
fprintf('done!\n');
