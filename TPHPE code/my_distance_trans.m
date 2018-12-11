function [M, Ix,Iy] = my_distance_trans(child_score,child_gauw, parent_gauw,mean_c,var_c,mean_p,var_p,lenx, leny)
vals = child_score;
sizx = size(vals,2);
sizy = size(vals,1);
ax_c = -1*child_gauw(1);
bx_c = -1*child_gauw(2);
ay_c = -1*child_gauw(3);
by_c = -1*child_gauw(4);

ax_p = -1*parent_gauw(1);
bx_p = -1*parent_gauw(2);
ay_p = -1*parent_gauw(3);
by_p = -1*parent_gauw(4);

[M,Ix,Iy] = deal(zeros(leny,lenx));
tmpM = zeros(leny,sizx);
tmpIy = zeros(leny,sizx);

for x=1:sizx
    [MM,IIy] = DT(vals(:,x),1,sizy,ay_c/(var_c(2)^2),by_c/(var_c(2)^2),ay_p/(var_p(2)^2)...
        ,by_p/(var_p(2)^2),mean_c(2),mean_p(2),leny);
    [tmpM(:,x),tmpIy(:,x)]=DT(vals(:,x),1,sizy,ay_c/(var_c(2)^2),by_c/(var_c(2)^2),ay_p/(var_p(2)^2)...
        ,by_p/(var_p(2)^2),mean_c(2),mean_p(2),leny);
end

for y=1:leny
    [M(y,:),Ix(y,:)]=DT(tmpM(y,:),1,sizx,ax_c/(var_c(1)^2),bx_c/(var_c(1)^2),ax_p/(var_p(1)^2)...
        ,bx_p/(var_p(1)^2),mean_c(1),mean_p(1),lenx);
end
Iy = tmpIy;
% for x=1:lenx
%     for y=1:leny
%         p = (x-1)*leny + (y-1) + 1;
%         Iy(p) = tmpIy(y,Ix(p));
%     end
% end