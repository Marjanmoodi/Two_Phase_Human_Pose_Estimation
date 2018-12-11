function [score,leng_score,dc_score,joint_score,dcCount] = calc_score(boxes,model,angl_bin,pair_bin,leng_bin)
[components,~] = modelcomponents(model);
global TestConfig;
p_no = 26;
% K = TestConfig.K ;
w1 = TestConfig.degreePenalty;
w2 = TestConfig.lengthPenalty;
w3 = TestConfig.pairPenalty;
deg_config = TestConfig.deg_config;
leng_config = TestConfig.leng_config;
pair_config = TestConfig.pair_config;
parts = components{1};
joint_score = 0;
cca = 0;
ccp = 0;
ccl = 0;
box = boxes(:,1:4*p_no);
xy = reshape(box,size(box,1),4,p_no);
xy = permute(xy,[1 3 2]);
x1 = xy(1,:,1); y1 = xy(1,:,2); x2 = xy(1,:,3); y2 = xy(1,:,4);
x = (x1+x2)/2; y = (y1+y2)/2;
% fixed_joint = [4,6,8,9,11,13,16,18,20,21,23,25];
Y = 0;
angleMatrix = zeros(8,1);
pairMatrix = zeros(8,1);
lengMatrix = zeros(8,1);
degreeMatrix = zeros(8,1);

for p=2:25
    curr = parts(p).pid;
    pa = parts(p).parent;
    for nb = 2:length(parts(p).nbh_IDs)
        if deg_config(nb-1,p) == 1
            cca = cca + 1;
            ch = parts(p).nbh_IDs(nb);
            cur =[x(curr),y(curr)];
            par = [x(pa),y(pa)];
            child = [x(ch),y(ch)];
            d = uint8(find_degree(par,cur,child));
            degreeMatrix(cca) = d;
            if isnan(d)
                disp(strcat('degree is not valid in part ',num2str(p),'and child',num2str(nb-1)));
                Y = -1;
            else
                Y = binPenalty(d,angl_bin(p,nb-1));
%                 Y = deg(p,nb-1,d+1);
            end
            
            joint_score = joint_score + Y;
            angleMatrix(cca) = Y;
        end
        
    end
end
% disp('next*****************************************************');
dc_score = 0;
Y = 0;
dcCount = 0;
for s = 1:26
    if (pair_config(s) == 1)
        ccp = ccp + 1;
        Ix = x(s);
        Iy = y(s);
        if s <15
            Ix_pair = x(s+12);
            Iy_pair = y(s+12);
        else
            Ix_pair = x(s-12);
            Iy_pair = y(s-12);
        end
        disx = (Ix -Ix_pair);
        disy = (Iy - Iy_pair);
        [Y,c] = bin2Penalty(disx,disy,pair_bin(s),1);
        dcCount = dcCount + c;
        dc_score = dc_score + Y;
        pairMatrix(ccp) = Y;
    end
    
end
leng_score = 0;
Y = 0;
for k = 2:26
    if leng_config(1,k) == 1
        ccl = ccl + 1;
        curr = parts(k).pid;
        pa = parts(k).parent;
      
        disx = x(curr) - x(pa);
        disy = y(curr) - y(pa);
        Y = bin2Penalty(disx,disy,leng_bin(k),0);
        leng_score = leng_score + Y;
        lengMatrix(ccl) = Y;
    end
    
end
% disp('next****************************');
% angleMatrix = reshape(angleMatrix,[4 2]);
% lengMatrix = reshape(lengMatrix,[4 2]);
% pairMatrix = reshape(pairMatrix,[4 2]);
% degreeMatrix = reshape(degreeMatrix,[4 2]);
% disp('angle**************');
% angleMatrix
% disp('degree*************');
% degreeMatrix
% disp('pair**************');
% pairMatrix
% disp('leng**************');
% lengMatrix
% cca = 1;
% ccl = 1;
% ccp = 1;
joint_score = w1*(joint_score/cca);
leng_score = w2*(leng_score/ccl);
dc_score = w3*(dc_score/ccp);
score = leng_score + dc_score + joint_score ;
end
