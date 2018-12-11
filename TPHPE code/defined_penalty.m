function [penal,leng_penal,dc_penal,joint_penal] = defined_penalty(boxes,model,angl,pair,leng)
[components,~] = modelcomponents(model);
global TestConfig;
K = TestConfig.K ;
w1 = TestConfig.degreePenalty;
w2 = TestConfig.lengthPenalty;
w3 = TestConfig.pairPenalty;
p_no = 26;
deg_config = TestConfig.deg_config;
leng_config = TestConfig.leng_config;
pair_config = TestConfig.pair_config;
parts = components{1};
joint_penal = 0;
box = boxes(:,1:4*p_no);
xy = reshape(box,size(box,1),4,p_no);
xy = permute(xy,[1 3 2]);
x1 = xy(1,:,1); y1 = xy(1,:,2); x2 = xy(1,:,3); y2 = xy(1,:,4);
x = (x1+x2)/2; y = (y1+y2)/2;

Y = 0;
cca = 0;
ccp = 0;
ccl = 0;
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
            d = round(find_degree(par,cur,child));
            if isnan(d)
                disp(strcat('degree is not valid in part ',num2str(p),'and child',num2str(nb-1)));
                Y = -1;
            else
                %                 Y = binPenalty(d,deg(p,nb-1));
                Y = angl(p,nb-1,min(360,d+1));
            end
            
            joint_penal = joint_penal + Y;
        end
    end
    
end
dc_penal = 0;
Y = 0;
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
        p1 = [Ix,Iy];
        p2 = [Ix_pair,Iy_pair];
        dis = norm(p2-p1);
        a = pair(s).a;
        b = pair(s).b;
        %         aa = 10;
        if dis<=a
            Y = (K.^(dis-a)-1)/(K^-a-1);
        elseif dis>=b
            Y = (K.^(b-dis)-1)/(K^-b-1);
            %         elseif dis<=aa
            %             Y = (K.^(dis-aa)-1)/(K^-aa-1);
        end
    end
    dc_penal = dc_penal + Y;
end
leng_penal = 0;
for k = 2:26
    if leng_config(1,k) == 1
        ccl = ccl + 1;
        curr = parts(k).pid;
        pa = parts(k).parent;
        cur =[x(curr),y(curr)];
        par = [x(pa),y(pa)];
        dist = norm(par-cur);
        a = leng(k).a;
        b = leng(k).b;
        if dist<=a
            Y = (K.^(dist-a)-1)/(K^-a-1);
        elseif dist>=b
            Y = (K.^(b-dist)-1)/(K^-b-1);
        else
            Y = 0;
        end
        leng_penal = leng_penal + Y;
    end
end
joint_penal = (w1*joint_penal)/cca;
leng_penal = (w2*leng_penal)/ccl;
dc_penal = (w3*dc_penal)/ccp;
penal = leng_penal + dc_penal + joint_penal ;
end
