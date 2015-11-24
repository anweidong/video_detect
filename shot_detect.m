function shot_detect( start_ind, end_ind, img_path, output_path)
% start_ind and end_ind are the starting and ending image, so we can trace
% all of the images in a path
% img_path is a path containing all the images
% output_path is the path to store all the output images

for i=1:end_ind-start_ind+1 
    file_name=dir(img_path); % the path tht u hv imges
    im=imread(strcat(img_path, '/', file_name(i+3).name)); 
    % i+3 is used for ignoring the first three system names . .. .DS_Store
    figure;
    axis image;
    axis off;
    image(im);
end

end

