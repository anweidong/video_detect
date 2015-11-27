function plot_bbox(im,bbox)

imshow(im);
hold on;

for i=1:size(bbox,1)
  x = bbox(i,1);
  y = bbox(i,2);
  w = bbox(i,3)-bbox(i,1);
  h = bbox(i,4)-bbox(i,2);
  if size(bbox,2)>5
      col = colorFromIndex(bbox(i,6)+1);
  else
      col = 'r';
  end
  rectangle('Position',[x y w h],'EdgeColor',col,'LineWidth',4);
end
