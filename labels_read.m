function tracklets = labels_read (filename)

% read files in directory and concatenate tracklets
if isdir(filename)
  dirname = filename;
  files = dir([dirname '/*.txt']);
  tracklets = [];
  for i=1:length(files)
    tracklets_curr = read_file([dirname '/' files(i).name]);
    for j=1:length(tracklets_curr)
      if length(tracklets)<j
        tracklets{j} = tracklets_curr{j};
      else
        tracklets{j} = [tracklets{j} tracklets_curr{j}];
      end
    end
  end
  
% read a single file
else
  tracklets = read_file(filename);
end

function tracklets = read_file (filename)

% parse input file
fid = fopen(filename);
try
  C = textscan(fid, '%d %d %f %f %f %f');
catch
  keyboard;
  error('This file is not in KITTI tracking format or the file does not exist.');
end
fclose(fid);

% for all objects do
tracklets = {};
for f=min(C{1}):max(C{1})
  objects = [];
  idx = find(C{1}==f);  
  for i = 1:numel(idx)
    o=idx(i);

    % extract 
    objects(i).frame      = C{1}(o); % frame
    objects(i).id         = C{2}(o); % tracklet id

    % extract 2D bounding box in 0-based coordinates
    objects(i).x1 = C{3}(o); % left
    objects(i).y1 = C{4}(o); % top
    objects(i).x2 = C{5}(o); % right
    objects(i).y2 = C{6}(o); % bottom

  end
  tracklets{f+1} = objects;
end
