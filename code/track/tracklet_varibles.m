% clip_1 tracklets
load ../../code_data/shots_data/result/shot1.mat
frame_dir = '../../clip_1';
t1 = face_track(frame_dir, '../../code/dpm/clip1_det', 22, 200);
tracklets1 = convertToKITTI(t1, 22, 200);
save('../../code_data/track_data/tracklets1.mat', 'tracklets1', '-mat');

% clip_2 tracklets
load ../../code_data/shots_data/result/shot2.mat
frame_dir = '../../clip_2';
t2 = face_track(frame_dir, '../../code/dpm/clip2_det', 65, 151);
tracklets2 = convertToKITTI(t2, 152, 199);
save('../../code_data/track_data/tracklets2.mat', 'tracklets2', '-mat');
t2 = face_track(frame_dir, '../../code/dpm/clip2_det', 152, 199);
tracklets2_2 = convertToKITTI(t2, 152, 199);
save('../../code_data/track_data/tracklets2.mat', 'tracklets2_2', '-mat', '-append');

% clip_3 tracklets
load ../../code_data/shots_data/result/shot3.mat
frame_dir = '../../clip_3';
t3 = face_track(frame_dir, '../../code/dpm/clip3_det', 16, 290);
tracklets3 = convertToKITTI(t3, 16, 290);
save('../../code_data/track_data/tracklets3.mat', 'tracklets3', '-mat');