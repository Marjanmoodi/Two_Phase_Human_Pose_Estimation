function [label, probability] = HogScore(boxes,img,HOGModels)

show = 0;
% close ll;
p_no = 26;
box = boxes(1,1:4*p_no);
xy = reshape(box,size(box,1),4,p_no);
xy = permute(xy,[1 3 2]);
x1 = xy(1,:,1); y1 = xy(1,:,2); x2 = xy(1,:,3); y2 = xy(1,:,4);
x = (x1+x2)/2; y = (y1+y2)/2;
impParts = zeros(26,1);
impParts(24) = 26;
impParts(22) = 24;
impParts(12) = 14;
impParts(10) = 12;

c = 0;
for p = 1:26
    
    if impParts(p) ~=0
        part = p;
        switch part
            case 10
                cur = 12;
                par = 10;
                h = 28.53;
                w = 10.79;
                hog = 2;
            case 12
                cur = 14;
                par = 12;
                h = 30.42;
                w = 11.91;
                hog = 1;
            case 22
                cur = 24;
                par = 22;
                h = 28.79;
                w = 11.22;
                hog = 3;
            case 24
                cur = 26;
                par = 24;
                h = 29.38;
                w = 11.15;
                hog = 4;
        end
        
        c = c + 1;
        parent =[x(par),y(par)];
        current =[x(cur),y(cur)];
        image = imread(img.im);
        if norm(current-parent) < 5
            probability(c) = 0;
        else
            r =  prePare( image,current,parent,show);
            %
            
            r = imresize(r,[2*h 2*w]);
            if show ==1
                figure;
                imshow(r);
            end
            testFeatures = extractHOGFeatures(r, 'CellSize', [8 8]);
            [label, prob] = predict(HOGModels{hog},testFeatures);
            probability(c) = prob(2);
        end
    end
end