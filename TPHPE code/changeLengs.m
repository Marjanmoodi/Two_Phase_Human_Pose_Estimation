function boxes = changeLengs(boxes)
p_no = 26;
scores = boxes(1,end-1:end);
box = boxes(1,1:4*p_no);
xy = reshape(box,size(box,1),4,p_no);
% xy = permute(xy,[1 3 2]);
% x1 = xy(1,:,1); y1 = xy(1,:,2); x2 = xy(1,:,3); y2 = xy(1,:,4);
% x = (x1+x2)/2; y = (y1+y2)/2;
xx = [11 12 13 14];
for p=xx
   temp = xy(1,:,p);
   xy(1,:,p) = xy(1,:,p+12);
   xy(1,:,p+12) = temp;
end
box = reshape(xy,size(box,1),4*p_no);
boxes = [box,scores];
end