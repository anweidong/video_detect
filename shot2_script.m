load Li2
load Lsig2
load Lmiu2
t = 15;
ind = 65;
shot = [];
for i=2:size(Li2,2)-1
    if (abs(Lmiu2(i)-Lmiu2(i+1))>t && abs(Lmiu2(i-1)-Lmiu2(i))>t) || ...
            (Lsig2(i)>2*t && Lsig2(i)-Lsig2(i+2)>t) && ...
            (Lsig2(i+2)<10)
        shot = [shot i+ind];
    end
end
% figure;
% plot(Li2, Lsig2);
% figure;
% plot(Li2, Lmiu2);
result = [];
for i=1:size(shot,2)-1
    if shot(i) ~= shot(i+1)-1
        result = [result shot(i)];
    end
    if i==size(shot,2)-1
        result = [result shot(i+1)];
    end
end
shot2 = result;
            
save('shot2.mat', 'shot2', '-mat');