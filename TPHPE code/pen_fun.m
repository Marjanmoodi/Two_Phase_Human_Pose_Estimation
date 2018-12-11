function p = pen_func(x,y,part,average)
% dis = norm([x,y]-part);
% sigma = average/3;
% p = normpdf(dis,0,sigma);
% mu(2) = part(1);
 mu = part(1:2);
sigma = 5*eye(2);
p = mvnpdf([x,y],mu,sigma);
end