load ../shots_data/measures/Li1
load ../shots_data/measures/Lsig1
load ../shots_data/measures/Lmiu1
t = 40;
ind = 22;
shot = [];
for i=2:size(Li1,2)-1
    if Lsig1(i)>t
        shot = [shot i+ind];
    end
end
% figure;
% plot(Li1, Lsig1);
% figure;
% plot(Li1, Lmiu1);
% result = [];
for i=1:size(shot,2)
    if i<size(shot,2)
        if shot(i) ~= shot(i+1)-1
            result = [result shot(i)];
        end
        if i==size(shot,2)-1
            result = [result shot(i+1)];
            break
        end
    else
        result = [result shot(i)];
    end
end
shot1 = result;
            
save('../shots_data/result/shot1.mat', 'shot1', '-mat');