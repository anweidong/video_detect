track_number = 1;
load(sprintf('../../code_data/track_data/tracklets%', track_number));
track = tracklets1;
start_frame = 22;
load('classifier')
addpath(sprintf('../../clip_%d',track_number))
m = containers.Map;
for i=1:length(track)-1
    im = rgb2gray(imread(sprintf('../../clip_%d/%03d.jpg', ...
        track_number,i + start_frame)));
    for j = 1:size(track{1,i},2)
        x1 = track{1,i}(j).x1;
        y1 = track{1,i}(j).y1;
        x2 = track{1,i}(j).x2;
        y2 = track{1,i}(j).y2;
        face = im(y1:y2, x1:min(x2, size(im,2)));
        face = imresize(face,[32,32]);
        features = extractHOGFeatures(face,'CellSize',[2 2]);
        predictedLabel = predict(classifier, features);
        if m.Count >=  track{1,i}(j).id
            m(sprintf('%d', track{1,i}(j).id)) = [m(sprintf('%d', track{1,i}(j).id)) predictedLabel];
        else
            m(sprintf('%d', track{1,i}(j).id)) = predictedLabel;
        end
    end
end
predictions = zeros(m.Count, 1);
for i=1:m.Count
   predictions(i) = round(mean(m(sprintf('%d',i))));
end
mkdir ../../code_data/gender_predictions
save(sprintf('../../code_data/gender_predictions/predictions%d.mat', track_number), 'predictions');