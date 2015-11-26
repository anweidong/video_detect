clear all; close all; dbstop error;
warning off MATLAB:MKDIR:DirectoryExists;

base_dir = '/home/geiger/5_Data/kitti/2013_tracking';
img_dir = [base_dir '/dataset/testing/image_02'];
det_dir = [base_dir '/detections/testing/det_02'];
result_dir = [base_dir '/results/tbd'];

mkdir(result_dir);
addpath('tracking');
model_type = 'Car';

% process all test sequences
for seq=0:28

  % read detections in KITTI tracking format
  label_file = sprintf('%s/%04d.txt',det_dir,seq);
  fprintf('Loading: %s\n',label_file);
  detections_kitti = labels_read(label_file);

  % convert from KITTI format to tracking format
  detections = convertFromKITTI(detections_kitti,model_type);

  % compute tracklets
  tracklets = computeTracklets(detections,sprintf('%s/%04d',img_dir,seq),1);

  % convert from tracking format to KITTI tracking format
  tracklets_kitti = convertToKITTI(tracklets,length(detections_kitti),model_type);

  % save to file and display
  labels_write(tracklets_kitti,sprintf('%s/%04d.txt',result_dir,seq));
end

% done
fprintf('done!\n');
