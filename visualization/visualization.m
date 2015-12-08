clip_number = 3;

load(sprintf('../../code_data/shots_data/result/shot%d.mat', clip_number))
if clip_number == 2
    load(sprintf('../../code_data/track_data/tracklets%d_xiugai.mat', clip_number))
else
    load(sprintf('../../code_data/track_data/tracklets%d.mat', clip_number))
end
load(sprintf('../../code_data/gender_predictions/predictions%d.mat', ...
    clip_number))
%shot = shot1;
%shot = shot2;
shot = shot3;
%tracklets = tracklets1;
%tracklets = tracklets;
tracklets = tracklets3;

gend = {'female', 'male'};
if clip_number == 3
    namestring = '%04dtracks.jpg';
else
    namestring = '%03dtracks.jpg';
end
shot_number = 1;
if clip_number == 1
    frame_range = 22:200;
elseif clip_number ==2
    frame_range = 65:199;
else frame_range = 16:290;
end

v = VideoWriter(sprintf('../../code_data/visualization/clip%d_final.mp4', clip_number), 'MPEG-4');
open(v)
for i=frame_range
    frame = imread(sprintf(['../../code_data/track_data/clip%d_tracks/', ...
        namestring], clip_number, i));
    if sum(i == shot)
        shot_number = shot_number + 1;
    end
    % insert frame #
    labeled = insertText(frame,[5 5],sprintf('Shot Number: %d', ...
        shot_number),'Font','LucidaBrightRegular','BoxColor','w', ...
        'FontSize', 21);
    %insert gender
    g=i-frame_range(1)+1;
    h = tracklets(g);
    for q=1:length(h{1,1})
        labeled = insertText(labeled,[h{1,1}(q).x1 h{1,1}(q).y1-20],sprintf('%s', ...
            char(gend(predictions(h{1,1}(q).id)+1))),'Font','Calibri Bold','BoxColor','y', ...
            'FontSize', 15);
    end
    
    if clip_number == 3
         coord = load(sprintf('../../code_data/logo/logo%d_data/coord%04d.mat',clip_number, i));
    else
         coord = load(sprintf('../../code_data/logo/logo%d_data/coord%03d.mat',clip_number, i));
    end
    coord = coord.coord;
    if ~isempty(coord)
        lines = zeros(4,4);
        for u=1:4
            lines(u,1:2) = coord(u, :);
            lines(u,3:4) = coord(u+1,:);
        end
        labeled = insertShape(labeled, 'Line', lines, 'LineWidth', 5);
        labeled = insertText(labeled,[coord(1,1) coord(1,2)-20],'LOGO','Font','Calibri Bold','BoxColor','r', ...
            'FontSize', 15,'TextColor', 'g');
    end
    writeVideo(v,labeled);
    imwrite(labeled, sprintf('../../code_data/visualization/clip%d/%04d.jpg', clip_number,i))
end
close(v)
