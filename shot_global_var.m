[Li1, Lsig1, Lmiu1] = shot_detect(22, 200, 'jpg', 'clip_1', 16);
save('Li1.mat', 'Li1', '-mat');
save('Lsig1.mat', 'Lsig1', '-mat');
save('Lmiu1.mat', 'Lmiu1', '-mat');
[Li2, Lsig2, Lmiu2] = shot_detect(65, 199, 'jpg', 'clip_2', 16);
save('Li2.mat', 'Li2', '-mat');
save('Lsig2.mat', 'Lsig2', '-mat');
save('Lmiu2.mat', 'Lmiu2', '-mat');
[Li3, Lsig3, Lmiu3] = shot_detect(16, 290, 'jpg', 'clip_3', 16);
save('Li3.mat', 'Li3', '-mat');
save('Lsig3.mat', 'Lsig3', '-mat');
save('Lmiu3.mat', 'Lmiu3', '-mat');