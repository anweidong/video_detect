clear all; close all; dbstop error;
warning off MATLAB:MKDIR:DirectoryExists;

% settings
base_dir = '/home/geiger/5_Data/kitti/2012_raw_data_extract';
seq_dir = [base_dir '/2011_09_26/2011_09_26_drive_0056'];
%seq_dir = [base_dir '/2011_09_26/2011_09_26_drive_0059'];
%seq_dir = [base_dir '/2011_09_29/2011_09_29_drive_0026'];

% load model
model_file = 'models/car_2_2012_10_04-20_13_57_model.mat';
model_type = 'Car';
model_bins = 16;
intervals = 3; % faster, less accurate (default: 10)
addpath('lsvm4');

% image and object directories
img_dir = [seq_dir '/image_02/data'];
obj_dir = [seq_dir '/object_02'];
mkdir(obj_dir);

% load object detector model, binning refers to the orientations
load(model_file);
binning = linspace(-pi+pi/(model_bins/2),pi,model_bins);

% process all images
figure;
files = dir([img_dir '/*.png']);
for i=1:length(files)
  
  % status
  fprintf('Processing: %s (%d/%d)\n',files(i).name,i,length(files));
  
  % file names
  img_file = [img_dir '/' files(i).name];
  obj_file = [obj_dir '/' files(i).name(1:end-4) '.txt'];
  
  % load image and detect objects
  im = imread(img_file);
  bbox = detect(im,model,intervals);
  
  % write in single file (tracking format)
  tracklets = [];
  for j=1:size(bbox,1)
    tracklets{1}(j).frame = str2num(files(i).name(1:end-4));
    tracklets{1}(j).id    = -1;
    tracklets{1}(j).type  = model_type;
    tracklets{1}(j).x1    = bbox(j,1);
    tracklets{1}(j).y1    = bbox(j,2);
    tracklets{1}(j).x2    = bbox(j,3);
    tracklets{1}(j).y2    = bbox(j,4);
    tracklets{1}(j).alpha = binning(bbox(j,5));
    tracklets{1}(j).score = bbox(j,6);
  end
  
  % save to file and display
  labels_write(tracklets,obj_file);
  clf; plot_bbox(im,bbox);
  refresh; pause(0.1);
end

% done
fprintf('done!\n');
