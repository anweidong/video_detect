clear all; close all; dbstop error;
warning off MATLAB:MKDIR:DirectoryExists;

% settings
base_dir = '/home/geiger/5_Data/kitti/2012_raw_data_extract';
seq_dir = [base_dir '/2011_09_26/2011_09_26_drive_0056'];
%seq_dir = [base_dir '/2011_09_26/2011_09_26_drive_0059'];
%seq_dir = [base_dir '/2011_09_29/2011_09_29_drive_0026'];

% image directory and model type
img_dir = [seq_dir '/image_02/data'];
addpath('tracking');
model_type = 'Car';
  
% read detections in KITTI tracking format
detections_kitti = labels_read([seq_dir '/object_02']);

% convert from KITTI format to tracking format
detections = convertFromKITTI(detections_kitti,model_type);

% compute tracklets
tracklets = computeTracklets(detections,img_dir);

% convert from tracking format to KITTI tracking format
tracklets_kitti = convertToKITTI(tracklets,length(detections_kitti),model_type);

% save to file and display
labels_write(tracklets_kitti,[seq_dir '/tracking_results.txt']);

% done
fprintf('done!\n');
