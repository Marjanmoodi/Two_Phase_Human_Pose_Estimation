function patch = extractPatch(img,joints,img_id)
xpad = 8;
ypad = 8;
% load('joints.mat');
    if nargin < 3
    imJoints = joints;
    else
    imJoints = joints(1:2,:,img_id);
    end
    xmin = min([imJoints(1,1),imJoints(1,3),imJoints(1,4),imJoints(1,6)]);
    xmin = xmin - xpad;
    xmax = max([imJoints(1,1),imJoints(1,3),imJoints(1,4),imJoints(1,6)]);
    xmax = xmax + xpad;
    ymin = min([imJoints(2,1),imJoints(2,3),imJoints(2,4),imJoints(2,6)]);
    ymin = ymin - ypad;
    ymax = max([imJoints(2,1),imJoints(2,3),imJoints(2,4),imJoints(2,6)]);
    ymax = ymax + ypad;
    w = xmax - xmin;
    h = ymax - ymin;
    %   imshow(img);
    %   pos = [xmin,ymin,w,h];
    [m,n,~] = size(img);
    patch = img(round(max(ymin,1)):round(min(ymax,m)),round(max(xmin,1)):round(min(xmax,n)),:);
    

% else
%     img = imread(name);
%     %   name = strrep(name,'im','');
%     %   name = str2double(strrep(name,'.jpg',''));
%     %   imJoints = joints(1:2,:,name);
%     %   img = imread(name);
%     %   name = strrep(name,'im','');
%     %   name = str2double(strrep(name,'.jpg',''));
%     %   imJoints = joints(1:2,:,name);
%     %     imJoints = imJoints';
%     xmin = min([imJoints(1,2),imJoints(1,3),imJoints(1,4),imJoints(1,5)]);
%     xmin = max(1,xmin - xpad);
%     xmax = max([imJoints(1,2),imJoints(1,3),imJoints(1,4),imJoints(1,5)]);
%     xmax = min(size(img,2),xmax + xpad);
%     ymin = min([imJoints(2,2),imJoints(2,3),imJoints(2,4),imJoints(2,5)]);
%     ymin = max(1,ymin - ypad);
%     ymax = max([imJoints(2,2),imJoints(2,3),imJoints(2,4),imJoints(2,5)]);
%     ymax = min(size(img,1),ymax + ypad);
%     w = xmax - xmin;
%     h = ymax - ymin;
%     %   imshow(img);
%     %   pos = [xmin,ymin,w,h];
%     imCrp = img(round(ymin):round(ymax),round(xmin):round(xmax),:);
%     %   imwrite(imCrp,strcat(folder,num2str(name),'.jpg'));
% end