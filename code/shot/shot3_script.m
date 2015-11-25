load ../../shots_data/measures/Li3
load ../../shots_data/measures/Lsig3
load ../../shots_data/measures/Lmiu3
t = 20;
ind = 16;
shot = [];
% since there are so many noise at the beginning, I divide the video into
% two parts from a impossible shot changing pt (e.g. 0150.jpg)
for i=1:150-16
    if abs(Lmiu3(i)*Lsig3(i))> 800
        shot = [shot i+ind];
    end
end
shot = [shot(1) shot(size(shot,2))];
for i=151-16:size(Li3,2)-1
    if abs(Lmiu3(i)*Lsig3(i))> 800 && ((abs(Lmiu3(i)-Lmiu3(i+1))>t ...
            && abs(Lmiu3(i-1)-Lmiu3(i))>t) || ...
            (Lsig3(i)>2*t && Lsig3(i)-Lsig3(i+2)>t && Lsig3(i+2)<100))
        shot = [shot i+ind];
    end
end
% figure;
% plot(Li3, Lsig3);
% figure;
% plot(Li3, Lmiu3);
% figure;
% plot(Li3, Lmiu3.*Lsig3);
result = [];
for i=1:size(shot,2)-1
    if shot(i) ~= shot(i+1)-1
        result = [result shot(i)];
    end
    if i==size(shot,2)-1
        result = [result shot(i+1)];
    end
end
shot3 = result;

save('../../shots_data/result/shot3.mat', 'shot3', '-mat');