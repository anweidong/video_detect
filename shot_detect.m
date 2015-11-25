function [Li, Lsig, Lmiu] = shot_detect(start_ind, end_ind, img_format, img_path, n)
% start_ind and end_ind are the starting and ending image, so we can trace
% all of the images in a path
% img_path is a path containing all the images
% output_path is the path to store all the output images
Li = zeros(1, end_ind-start_ind);
Lsig = zeros(1, end_ind-start_ind);
Lmiu = zeros(1, end_ind-start_ind);
for i = start_ind+1 : end_ind % compare the one with its previous
    if strcmp(img_path,'clip_3')==1 || strcmp(img_path,'clip_3/')==1
        im_cur = imread(sprintf('%s/%04d.%s', img_path, i, img_format));
        im_pre = imread(sprintf('%s/%04d.%s', img_path, i-1, img_format));
    else
        im_cur = imread(sprintf('%s/%03d.%s', img_path, i, img_format));
        im_pre = imread(sprintf('%s/%03d.%s', img_path, i-1, img_format));
    end
    im2 = double(rgb2gray(im_cur)); % convert each frame to gray scale
    im1 = double(rgb2gray(im_pre));
    [h, l] = size(im2);
    % padding
    pad2 = zeros(h+2*n, l+2*n, 'like', im2);
    pad2(n+(1:h),n+(1:l)) = im2;
    im2 = pad2;
    pad1 = zeros(h+2*n, l+2*n, 'like', im1);
    pad1(n+(1:h),n+(1:l)) = im1;
    im1 = pad1;
    % all blocks
    blocks = 0;
    miu = 0;
    sig1 = 0;
    sig2 = 0;
    for p = n+17:n:h
        for q = n+17:n:l
            blocks = blocks+1;
            u = 0;
            v = 0;
            % in one block
%            i
            x = q;
            y = p;
            for k=1:10
%                 x = x+u
%                 y = y+v
%                 round(y:y+n-1)
%                 round(x:x+n-1)
%                 size(im2)
                I1 = im2(round(y:y+n-1),round(x:x+n-1));
                I0 = im1(round(y:y+n-1),round(x:x+n-1));
                [Ix, Iy] = imgradientxy(I0);
                Ix2 = sum(sum(Ix .* Ix));
                IxIy = sum(sum(Ix .* Iy));
                Iy2 = sum(sum(Iy .* Iy));
                IxI0 = sum(sum(Ix .* I0));
                IyI0 = sum(sum(Iy .* I0));
                I02 = sum(sum(I0 .* I0));
                IxI1_0 = sum(sum(Ix .* (I1 - I0)));
                IyI1_0 = sum(sum(Iy .* (I1 - I0)));
                I0I1_0 = sum(sum(I0 .* (I1 - I0)));
                M = [Ix2 IxIy IxI0; IxIy Iy2 IyI0; IxI0 IyI0 I02];
                N = [IxI1_0; IyI1_0; I0I1_0];
                if rank(M) == min(size(M))
                    U = M \ N;
                    du = U(1);
                    dv = U(2);
                    w = U(3);
                    u = u+du;
                    v = v+dv;
                else
                    break
                end
            end
            I = mean(mean(im1(p:p+15,q:q+15)));
            miu = miu + I*w;
            sig2 = sig2 + (I*w)^2;
            sig1 = sig1 + (I*w);
        end
    end
    miu = miu / blocks;
    sig = sig2 - 2*miu*sig1 + blocks*miu^2;
    sig = sqrt(sig/blocks);
    Lsig(i-start_ind) = sig;
    Lmiu(i-start_ind) = miu;
    Li(i-start_ind) = i;
end
end

