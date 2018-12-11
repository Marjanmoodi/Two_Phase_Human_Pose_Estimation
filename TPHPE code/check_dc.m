function [ratio,label,detected_parts] = check_dc(boxes,pa,thresh)
p_no = 26;
detected_parts(1).pair = 0;
detected_parts(2).pair = 0;
for r = 3:14
detected_parts(r).pair = r + 12;
end
if ~isempty(boxes)
  box = boxes(:,1:4*p_no);
  xy = reshape(box,size(box,1),4,p_no);
  xy = permute(xy,[1 3 2]);
  for n = 1:size(xy,1)
    x1 = xy(n,:,1); y1 = xy(n,:,2); x2 = xy(n,:,3); y2 = xy(n,:,4);
    x = (x1+x2)/2; y = (y1+y2)/2;
    for child = 2:p_no
      x1 = x(pa(child));
      y1 = y(pa(child));
      x2 = x(child);
      y2 = y(child);
      detected_parts(child).X = x1;
      detected_parts(child).Y = y1;
      detected_parts(child).par_X = x2;
      detected_parts(child).par_Y = y2;
    end
    
  end
  sumh = 0;
  for h = 4:7
      lh = [detected_parts(h).X, detected_parts(h).Y];
      pair = [detected_parts(detected_parts(h).pair).X,detected_parts(detected_parts(h).pair).Y];
      sumh = sumh + pdist2(lh,pair);
  end
    ell = [detected_parts(3).X, detected_parts(3).Y];
    elr = [detected_parts(detected_parts(3).pair).X,detected_parts(detected_parts(3).pair).Y];
    sumb = pdist2(ell,elr);
  for h = 8:9
      lb = [detected_parts(h).X, detected_parts(h).Y];
      pair = [detected_parts(detected_parts(h).pair).X,detected_parts(detected_parts(h).pair).Y];
      sumb = sumb + pdist2(lb,pair);
  end
  suml = 0;
  for h = 10:14
      ll = [detected_parts(h).X, detected_parts(h).Y];
      pair = [detected_parts(detected_parts(h).pair).X,detected_parts(detected_parts(h).pair).Y];
      suml = suml + pdist2(ll,pair);
  end
  ratio =double(mean(sumb) / mean(suml));
end
if ratio > thresh
    label = 1;
else
    label = 0;
end
end