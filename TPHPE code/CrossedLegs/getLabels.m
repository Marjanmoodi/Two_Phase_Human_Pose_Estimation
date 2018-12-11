function [posInd,negInd,labels] = getLabels(joints)
jointCount = length(joints);
labels = zeros(jointCount,1);
margin = 5;
for imgInd = 1 : jointCount
    
    if (norm(joints(1,1,imgInd)-joints(1,3,imgInd)) > norm(joints(1,1,imgInd)-joints(1,4,imgInd)) + margin ...
            || norm(joints(1,6,imgInd)-joints(1,4,imgInd)) > norm(joints(1,6,imgInd)-joints(1,3,imgInd)) + margin)
        labels(imgInd) = 1;
    end
end

posInd = find(labels == 1);
negInd = find(labels == 0);

% addpath('./pos');
% addpath('./neg');
% neg = dir('neg/*.jpg');
% pos = dir('pos/*.jpg');
% for k = 1:length(pos)
%     name = pos(k).name;
%     name = strrep(name,'im','');
%     posInd(k) = str2double(strrep(name,'.jpg',''));
% end
% for k = 1:length(neg)
%     name = neg(k).name;
%     name = strrep(name,'im','');
%     negInd(k) = str2double(strrep(name,'.jpg',''));
% end
end