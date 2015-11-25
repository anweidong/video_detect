function demo()
startup;

start=22;
final=200;
fprintf('compiling the code...');
% compile;
fprintf('done.\n\n');
mkdir clip3_det
mkdir clip3_det_frame
load('../face_final');
model.vis = @() visualizemodel(model, ...
                  1:2:length(model.rules{model.start}));
for f=start:final
test(sprintf('../../clip_1/%03d.jpg', f), model, -.3, sprintf('%03d', f));
end

function test(imname, model, thresh, outname)
cls = model.class;
fprintf('///// Running demo for %s /////\n\n', cls);

% load and display image
h = figure;
im = imread(imname);
clf;
image(im);
axis equal; 
axis off;
% detect objects
[ds, bs] = imgdetect(im, model, thresh);
top = nms(ds, .35);
disp('detections');

det = reduceboxes(model, bs(top,:));
det = det(:,1:4);
showboxesMy(det(:,1:4), 'r');
save(sprintf('clip1_det/%s.mat', outname), 'det');
saveas(h,sprintf('clip1_det_frame/%s_det.jpg', outname))
close(h);

fprintf('\n');
