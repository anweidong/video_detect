function tracklets_kitti = convertToKITTI(tracklets, start_f, end_f)

for i=1:end_f-start_f+1
  k=1;
  for j=1:length(tracklets)
    idx = find(tracklets{j}(:,1)==i);
    if ~isempty(idx)
      bbox = posScaleToBbox(tracklets{j}(idx,2:5));
      tracklets_kitti{i}(k).frame = i+start_f-1;
      tracklets_kitti{i}(k).x1 = bbox(1);
      tracklets_kitti{i}(k).y1 = bbox(2);
      tracklets_kitti{i}(k).x2 = bbox(3);
      tracklets_kitti{i}(k).y2 = bbox(4);
      tracklets_kitti{i}(k).id = j;
      k=k+1;      
    end
  end
end
