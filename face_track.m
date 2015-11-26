function face_track(frame_dir, det_dir, start_frame, end_frame)
% frame_dir is a path to the images
% det_dir is a path to the image detections
% start_ and end_frame are the index of start and end images
% Modified code which is credit from http://www.cvlibs.net/software/trackbydet/

tracklets  = [];
kfstate    = [];
active     = [];
for i = start_frame:end_frame
    if isempty(strfind(frame_dir,'clip_3'))==0
        name = sprintf('%04d.jpg', i);
        det_name = sprintf('%04d.mat', i);
    else
        name = sprintf('%03d.jpg', i);
        det_name = sprintf('%03d.mat', i);
    end
    im = imread(fullfile(frame_dir, name));
    data = load(fullfile(det_dir, det_name));
    bbox = data.det;
    if length(size(im))==3
        im = rgb2gray(im);
    end
    I{i-first_frame+1} = im;
    detection{i-first_frame+1} = bbox;
end   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   STAGE 1                    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % convert to object detection representation
    object = bboxToPosScale(bbox);
    % active tracklets
    idx_active = find(active);
    % if active tracklets exist => try to associate
    if ~isempty(idx_active)
        
        % dist matrix
        dist = zeros(length(idx_active),size(object,1));
        
        % predict state and compute distance to detections
        for j=1:length(idx_active)
            
            % index of this tracklet
            track_idx = idx_active(j);
            
            % predict state
            kfstate{track_idx} = kfpredict(kfstate{track_idx});
            
            % set tracklet row of dist matrix
            if size(object,1)>0
                dist(j,:) = trackletLocation(object(:,1:4),tracklets{track_idx},I);
            end
        end
    end



end



function bbox = posScaleToBbox(object)
% inverse of bboxToPosScale.m

u1 = object(:,1)-object(:,3)/2;
v1 = object(:,2)-object(:,4)/2;
u2 = object(:,1)+object(:,3)/2;
v2 = object(:,2)+object(:,4)/2;

bbox = [u1 v1 u2 v2];

function s = kfpredict(s)

s.x = s.A*s.x;
s.P = s.A*s.P*s.A' + s.Q;

if s.x(3)<20
  s.x(3) = 20;
end

if s.x(4)<20
  s.x(4) = 20;
end

function dist = trackletLocation(object,tracklet,I)

% intersection over union
bbox1 = posScaleToBbox(object);
bbox2 = posScaleToBbox(tracklet(end,2:5));
dist_geo = 1.0-boxoverlap(bbox1,bbox2)';

for i=1:size(object,1)
  if dist_geo(i)<0.7
    [c,d] = correlate_full(tracklet(end,1:5),[tracklet(end,1)+1 object(i,:)],I);
    if d<0.2
      dist_corr(i) = 1.0-c;
    else
      dist_corr(i) = inf;
    end
  else
    dist_corr(i) = inf;
  end
end

dist = dist_geo.*dist_corr;
idx = dist_corr>0.4 | dist_geo>0.7;
dist(idx) = inf;
end

function bbox = posScaleToBbox(object)
% inverse of bboxToPosScale.m

u1 = object(:,1)-object(:,3)/2;
v1 = object(:,2)-object(:,4)/2;
u2 = object(:,1)+object(:,3)/2;
v2 = object(:,2)+object(:,4)/2;

bbox = [u1 v1 u2 v2];
end

function o = boxoverlap(a, b)

% Compute the symmetric intersection over union overlap between a set of
% bounding boxes in a and a single bounding box in b.
%
% a  a matrix where each row specifies a bounding box
% b  a single bounding box

x1 = max(a(:,1), b(1));
y1 = max(a(:,2), b(2));
x2 = min(a(:,3), b(3));
y2 = min(a(:,4), b(4));

w = x2-x1+1;
h = y2-y1+1;
inter = w.*h;
aarea = (a(:,3)-a(:,1)+1) .* (a(:,4)-a(:,2)+1);
barea = (b(3)-b(1)+1) * (b(4)-b(2)+1);

% intersection over union overlap
o = inter ./ (aarea+barea-inter);

% set invalid entries to 0 overlap
o(w <= 0) = 0;
o(h <= 0) = 0;
end

function [c,d] = correlate_full(t1,t2,I)

% compute bounding boxes
bbox_tmp = round(posScaleToBbox(t1(2:5)));
bbox_img = round(posScaleToBbox(t2(2:5)));

% enlarge search area by 25%
m = ceil(0.25*t2(4));
bbox_img(1) = max(bbox_img(1)-m,1);
bbox_img(2) = max(bbox_img(2)-m,1);
bbox_img(3) = min(bbox_img(3)+m,size(I{t2(1)},2));
bbox_img(4) = min(bbox_img(4)+m,size(I{t2(1)},1));

% clip template
bbox_tmp(1) = max(bbox_tmp(1),1);
bbox_tmp(2) = max(bbox_tmp(2),1);
bbox_tmp(3) = min(bbox_tmp(3),size(I{t1(1)},2));
bbox_tmp(4) = min(bbox_tmp(4),size(I{t1(1)},1));

% extract template and search area
T = I{t1(1)}(bbox_tmp(2):bbox_tmp(4),bbox_tmp(1):bbox_tmp(3));
S = I{t2(1)}(bbox_img(2):bbox_img(4),bbox_img(1):bbox_img(3));

% crop template upper and lower part by 15 %
m = round(0.15*size(T,1));
T = T(m+1:end-m,:);

% crop template left and right part by 15 %
m = round(0.15*size(T,2));
T = T(:,m+1:end-m);

% compute correlation score
[c,d] = xcorr(T,S);
end

function [c,d,u1,v1,C] = xcorr(T,S)
% u1,v1 = search area pixel where upper left template corner is anchored

if size(T,1)>size(S,1) || size(T,2)>size(S,2)
  c  = -1;
  d  = 1;
  u1 = 0;
  v1 = 0;
  return;
end

% correlate
C = normxcorr2(T,S);

% crop
m1 = floor((size(C,1)-(size(S,1)-size(T,1)))/2);
m2 = floor((size(C,2)-(size(S,2)-size(T,2)))/2);
c  = max(max(C(m1+1:end-m1,m2+1:end-m2)));

% find bbox
[i,j] = find(C==c,1,'first');
u1 = j-size(T,2)+1;
u2 = j;
v1 = i-size(T,1)+1;
v2 = i;

% compute SAD
if u1<1 || u2>size(S,2) || v1<1 || v2>size(S,1)
  d = 1;
else
  D = imabsdiff(T,S(v1:v2,u1:u2));
  d = double(mean(D(:)))/256.0;
end
end