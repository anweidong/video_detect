% An, Weidong
% Nov, 30, 2015

% This function is modified from the "Digit Classification Using HOG
% Features" in Matlab R2015B Vision Toolbox.
% The Statistics and Machine Learning Toolbox(TM) and the Computer Vision
% System Toolbox(TM) are required.
% Please see the url for more details
% http://www.mathworks.com/help/vision/examples/digit-classification-using-hog-features.html
% The function using the |extractHOGfeatures| function (introduced in
% R2013B) from the Computer Vision System Toolbox and the |fitcecoc|
% function (introduced in R2014B) from the Statistics and Machine Learning
% Toolbox(TM).

function predictedLabels = HogSVM(cellSize, tr_images, tr_labels,test_images)
% Input: tr_images is a three-dimensional matrix and each of 
%        tr_images(:,:,i) is a gray scale image for totally n images.
%        tr_labels n by 1 matrix
% Output: A prediction on test_images
% -------------------------------------------------------------------------
% Using HOG Features
% -------------------------------------------------------------------------
% The data used to train the SVM classifier are HOG feature vectors
% extracted from the training images.
img = tr_images(:,:,1);
% Extract HOG features and HOG visualization
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',cellSize);
% cellSize = [2 2];
hogFeatureSize = length(hog_2x2);

% -------------------------------------------------------------------------
% Train the Classifier
% -------------------------------------------------------------------------
% Pre-allocate features array
numTrainingImages = size(tr_images, 3);
features  = zeros(numTrainingImages,hogFeatureSize,'single');

% Extract HOG features from each training image. 
for i = 1:numTrainingImages
    img = tr_images(:,:,i);
    features(i,:) = extractHOGFeatures(img,'CellSize',cellSize);
end

% Train a multiclass classifier extracted features and training labels
classifier = fitcecoc(features, tr_labels);

% -------------------------------------------------------------------------
% Predict the test images using the trained classifier
% -------------------------------------------------------------------------
numImages    = size(test_images,3);
features = zeros(numImages, hogFeatureSize, 'single');
for i = 1:numImages
    img = test_images(:,:,i);
    % Extract HOG features from img
    features(i,:) = extractHOGFeatures(img,'CellSize',cellSize);
end
% Predict using the trained classifier
predictedLabels = predict(classifier, features);
end
