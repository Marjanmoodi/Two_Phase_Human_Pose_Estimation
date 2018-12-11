function final = prePare( img,ll,ul,show)
mask = zeros(size(img,1),size(img,2),3);
disx = abs(ll(1) - ul(1));
disy = abs(ll(2) - ul(2));
c1 = max(10,round(disx/4));
c2 = max(5,round(disy/5));
m = (ul(2) - ll(2))/(ul(1) - ll(1));

if(isinf(m))
    ul2(1) = ul(1);
    ul2(2) = ul(2) - c2;
    ll2(1) = ll(1);
    ll2(2) = ll(2) + c2;
    ul3(1) = ul(1);
    ul3(2) = ul(2) + c2;
    ll3(1) = ll(1);
    ll3(2) = ll(2) - c2;
    dis2 = norm(ul2-ll2);
    dis3 = norm(ul3-ll3);
    if dis2>=dis3
        ul = ul2;
        ll = ll2;
    else
        ul = ul3;
        ll = ll3;
    end
    lu(1) = ul(1) - c1;
    lu(2) = ul(2);
    ru(1) = ul(1) + c1;
    ru(2) = ul(2);
    ld(1) = ll(1) - c1;
    ld(2) = ll(2);
    rd(1) = ll(1) + c1;
    rd(2) = ll(2);
elseif m==0
    ul2(1) = ul(1) - c2;
    ul2(2) = ul(2);
    ll2(1) = ll(1) + c2;
    ll2(2) = ll(2);
    ul3(1) = ul(1) + c2;
    ul3(2) = ul(2);
    ll3(1) = ll(1) - c2;
    ll3(2) = ll(2);
    dis2 = norm(ul2-ll2);
    dis3 = norm(ul3-ll3);
    if dis2>=dis3
        ul = ul2;
        ll = ll2;
    else
        ul = ul3;
        ll = ll3;
    end
    lu(2) = ul(2) - c1;
    lu(1) = ul(1);
    ru(2) = ul(2) + c1;
    ru(1) = ul(1);
    ld(2) = ll(2) - c1;
    ld(1) = ll(1);
    rd(2) = ll(2) + c1;
    rd(1) = ll(1);
else
    mm = [1 m];
    norm_mm = mm./norm(mm);
    ul2 = ul - norm_mm*c2;
    ll2 = ll + norm_mm*c2;
    ul3 = ul + norm_mm*c2;
    ll3 = ll - norm_mm*c2;
    dis2 = norm(ul2-ll2);
    dis3 = norm(ul3-ll3);
    if dis2>=dis3
        ul = ul2;
        ll = ll2;
    else
        ul = ul3;
        ll = ll3;
    end
    m_prime = [1,(-1/m)];
    norm_m = m_prime./norm(m_prime);
    % norm_m = abs(norm_m);
    lu = ul - norm_m*c1;
    ru = ul + norm_m*c1;
    ld = ll - norm_m*c1;
    rd = ll + norm_m*c1;
    
end
if show==1
    imshow(img);
    imellipse(gca,[ld(1) ld(2) 3 3]);
    imellipse(gca,[lu(1) lu(2) 3 3]);
    imellipse(gca,[rd(1) rd(2) 3 3]);
    imellipse(gca,[ru(1) ru(2) 3 3]);
end
x = double([lu(1) ld(1)  rd(1) ru(1) lu(1)]);
y = double([lu(2) ld(2) rd(2) ru(2) lu(2)]);
mm = poly2mask(x,y,size(img,1),size(img,2));
mask(:,:,1) = mm;
mask(:,:,2) = mm;
mask(:,:,3) = mm;
mask = uint8(mask);
teta = rad2deg(atan(m));
if m>0
    img = imrotate(img,teta-90);
    mask = imrotate(mask,teta-90);
elseif isinf(m)
    
elseif m==0
    img = imrotate(img,-90);
    mask = imrotate(mask,-90);
else
    img = imrotate(img,teta+90);
    mask = imrotate(mask,teta+90);
end
leftLeg = mask.*img;
measurements = regionprops(mask(:,:,1), 'BoundingBox');
croppedImage = imcrop(leftLeg, measurements.BoundingBox);
final = imcrop(croppedImage,[3 3 size(croppedImage,2)-5 size(croppedImage,1)-5]);
% final = imresize(final,[2*h,2*w]);
if show==1
    imshow(final);
end
end
    
