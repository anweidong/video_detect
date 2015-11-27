% clip_1 tracklets
load ../../code_data/shots_data/result/shot1.mat
% brk = [22 shot1 200];
% m = Inf;
% for i=2:length(brk)
%     m = min(m, brk(i)-brk(i-1));
% end
frame_dir = '../../clip_1';
t1 = face_track(frame_dir, '../../code/dpm/clip1_det', 22, 200);
tracklets1 = convertToKITTI(t1, 22, 200);
save('../../code_data/track_data/tracklets1.mat', 'tracklets1', '-mat');

% clip_2 tracklets
load ../../code_data/shots_data/result/shot2.mat
% brk = [65 shot2 199];
% m = Inf;
% for i=2:length(brk)
%     m = min(m, brk(i)-brk(i-1));
% end
frame_dir = '../../clip_2';
t2 = face_track(frame_dir, '../../code/dpm/clip2_det', 65, 199);
tracklets2 = convertToKITTI(t2, 65, 199);
save('../../code_data/track_data/tracklets2.mat', 'tracklets2', '-mat');

% clip_3 tracklets
load ../../code_data/shots_data/result/shot3.mat
% brk = [16 shot3 290];
% m = Inf;
% for i=2:length(brk)
%     m = min(m, brk(i)-brk(i-1));
% end
frame_dir = '../../clip_3';
t3 = face_track(frame_dir, '../../code/dpm/clip3_det', 16, 290);
tracklets3 = convertToKITTI(t3, 16, 290);
save('../../code_data/track_data/tracklets3.mat', 'tracklets3', '-mat');