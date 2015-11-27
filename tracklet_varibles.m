% clip_1 tracklets
t1 = face_track(frame_dir, 'code/dpm/clip1_det', 22, 200);
tracklets1 = convertToKITTI(t, 22, 200);
save('');
% clip_2 tracklets
t2 = face_track(frame_dir, 'code/dpm/clip2_det', 65, 199);
tracklets2 = convertToKITTI(t, 22, 200);

% clip_3 tracklets
t3 = face_track(frame_dir, 'code/dpm/clip3_det', 16, 290);
tracklets3 = convertToKITTI(t, 22, 200);