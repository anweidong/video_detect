load Li1
load Lsig1
load Lmiu1
t = 10;
ind = 22;
shot = [];
for i=2:size(Li1,2)-1
    if (abs(Lmiu1(i)-Lmiu1(i+1))>t && abs(Lmiu1(i-1)-Lmiu1(i))>t) || ...
            (Lsig1(i)>2*t && Lsig1(i)-Lsig1(i+2)>t) && ...
            (Lsig1(i+2)<10)
        shot = [shot i+ind];
    end
end
% figure;
% plot(Li1, Lsig1);
% figure;
% plot(Li1, Lmiu1);
result = [];
for i=1:size(shot,2)-1
    if shot(i) ~= shot(i+1)-1
        result = [result shot(i)];
    end
    if i==size(shot,2)-1
        result = [result shot(i+1)];
    end
end
shot1 = result;
            
save('shot1.mat', 'shot1', '-mat');