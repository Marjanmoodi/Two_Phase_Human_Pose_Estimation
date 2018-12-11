function [myboxes,boxes] = test_model(note,model,test,handles,angl,pair,leng,angl_bin,pair_bin,leng_bin,feat)
% boxes = testmodel(name,model,test,suffix)
% Returns candidate bounding boxes after non-maximum suppression
% global imname;
global TestConfig;
hogWeight = TestConfig.hog;
%%%%%%% load cross classifie %%%%%%%
convertVector = [ 14 13 12 6 7 8 11 10 9 3 4 5 2 1];
% jj = load('joints.mat');
% folder = '/Users/marjan/Desktop/MS_Project/V1-10-11/CrossedLegs/src/trainImages/';
% testFolder = '/Users/marjan/Desktop/MS_Project/V1-10-11/CrossedLegs/src/testImages/';
% trainingFiles = dir([folder,'*.jpg']);
% [~,~,labels] = getLabels(jj.joints);
% trainIDs = [];
% for ii = 1 : length(trainingFiles)
%     name = trainingFiles(ii).name;
%     name = strrep(name,'im','');
%     imgId = str2double(strrep(name,'.jpg',''));
%     trainIDs = [trainIDs,  imgId];
% end
% 
% 
% labels = labels(trainIDs);
% [crossedClassifier,~] = learnClassifier(trainingFiles,labels);
load('crossedClassifier.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('HOGModel');
conf = global_conf();
cachedir = conf.cachedir;
par.impyra_fun = conf.impyra_fun;
par.useGpu = conf.useGpu;
par.device_id = conf.device_id;
par.at_least_one = conf.at_least_one;
par.test_with_detection = conf.test_with_detection;
if par.test_with_detection
    par.constrainted_pids = conf.constrainted_pids;
end

try
    boxes = parload([cachedir note '_raw_boxes'], 'boxes');
    if (size(boxes)~=0)
        disp('read from cache');
    end
catch
%     cachData = cell(length(TestConfig.testIndex),1);
    boxes = cell(1,length(TestConfig.testIndex));
    left_fixed_boxes = cell(1,length(TestConfig.testIndex));
    right_fixed_boxes = cell(1,length(TestConfig.testIndex));
    myboxes = cell(1,length(TestConfig.testIndex));
    orig_inv_boxes = cell(1,length(TestConfig.testIndex));
    left_inv_boxes = cell(1,length(TestConfig.testIndex));
    right_inv_boxes = cell(1,length(TestConfig.testIndex));
    
    
    candids = cell(1,length(TestConfig.testIndex));
    lcandids = cell(1,length(TestConfig.testIndex));
    rcandids = cell(1,length(TestConfig.testIndex));
    
    leng_score = zeros(1,length(TestConfig.testIndex));
    pair_score = zeros(1,length(TestConfig.testIndex));
    angle_score = zeros(1,length(TestConfig.testIndex));
    
    lleng_score = zeros(1,length(TestConfig.testIndex));
    lpair_score = zeros(1,length(TestConfig.testIndex));
    langle_score = zeros(1,length(TestConfig.testIndex));
    
    rleng_score = zeros(1,length(TestConfig.testIndex));
    rpair_score = zeros(1,length(TestConfig.testIndex));
    rangle_score = zeros(1,length(TestConfig.testIndex));
    
    leng_penal = zeros(1,length(TestConfig.testIndex));
    pair_penal = zeros(1,length(TestConfig.testIndex));
    angle_penal = zeros(1,length(TestConfig.testIndex));
    
    rleng_penal = zeros(1,length(TestConfig.testIndex));
    rpair_penal = zeros(1,length(TestConfig.testIndex));
    rangle_penal = zeros(1,length(TestConfig.testIndex));
    
    lleng_penal = zeros(1,length(TestConfig.testIndex));
    lpair_penal = zeros(1,length(TestConfig.testIndex));
    langle_penal = zeros(1,length(TestConfig.testIndex));
    mus = calc_mean_pair(feat);
    trues = 0;
    falses = 0;
    %     for i=1:length(test)
    c = 0;
    sumjoints = 0;
    for i= TestConfig.testIndex
        c = c + 1;
        fprintf([note ': testing: %d/%d\n'],i,length(test));
        
        %%% Original calculation
        [box,candid,pyra, unary_map, idpr_map] = detect_fast(test(i),model,model.thresh,par);
        [boxes{c},candids{c}] = nms_pose(candid,box,0.3);
        
        [bin_score,leng_score(c),pair_score(c),angle_score(c),Odc] = calc_score(boxes{c},model,angl_bin,pair_bin,leng_bin);
        [penal,leng_penal(c),pair_penal(c),angle_penal(c)] = defined_penalty(boxes{c},model,angl,pair,leng);
        
        [~,pp] = HogScore(boxes{c},test(i),HOGModels);
        Hprob = mean(pp);
        
        cachData(c).score0O = boxes{c}(1,end);
        boxes{c}(1,end)  = boxes{c}(1,end) + hogWeight*Hprob;
        boxes{c}(1,end) = boxes{c}(1,end) - penal;
        boxes{c} = boxes{c}(1,:);
        
        %%% Original Inverse
        orig_inv_boxes{c} = changeLengs(boxes{c});
        %%%% Right calculation
        fixed = 'R';
        [right_fixed_boxes{c},rcandids{c},~] = new_detect(test(i),model,par,candids{c}(1,:,:),fixed,mus,pyra, unary_map, idpr_map,0);
        [~,pp] = HogScore(right_fixed_boxes{c},test(i),HOGModels);
        Hrprob = mean(pp);
        [bin_score,rleng_score(c),rpair_score(c),rangle_score(c),Rdc] = calc_score(right_fixed_boxes{c},model,angl_bin,pair_bin,leng_bin);
        [rpenal,rleng_penal(c),rpair_penal(c),rangle_penal(c)] = defined_penalty(right_fixed_boxes{c},model,angl,pair,leng);
        right_inv_boxes{c} = changeLengs(right_fixed_boxes{c});
        cachData(c).score0R = right_fixed_boxes{c}(1,end);
        right_fixed_boxes{c}(1,end) = right_fixed_boxes{c}(1,end) + hogWeight*Hrprob;
        right_fixed_boxes{c}(1,end) = right_fixed_boxes{c}(1,end) - rpenal;
        
        
        %%%% Left calculation
        fixed = 'L';
        [left_fixed_boxes{c},lcandids{c},~] = new_detect(test(i),model,par,candids{c}(1,:,:),fixed,mus,pyra, unary_map, idpr_map,0);
        [~,pp] = HogScore(left_fixed_boxes{c},test(i),HOGModels);
        Hlprob = mean(pp);
        [bin_score,lleng_score(c),lpair_score(c),langle_score(c),Ldc] = calc_score(left_fixed_boxes{c},model,angl_bin,pair_bin,leng_bin);
        [lpenal,lleng_penal(c),lpair_penal(c),langle_penal(c)] = defined_penalty(left_fixed_boxes{c},model,angl,pair,leng);
        left_inv_boxes{c} = changeLengs(left_fixed_boxes{c});
        cachData(c).score0L = left_fixed_boxes{c}(1,end);
        left_fixed_boxes{c}(1,end) = left_fixed_boxes{c}(1,end) + hogWeight*Hlprob;
        left_fixed_boxes{c}(1,end) = left_fixed_boxes{c}(1,end)  - lpenal;
        %%%%%%%%%%%%% crossed legs %%%%%%%%%%%%%
        [best,~] = compare_res(boxes{c},right_fixed_boxes{c},left_fixed_boxes{c});
        tempboxes{c} = best;
        boxesJoints = conf.box2det(tempboxes(c), 26);
        joints = boxesJoints.joints(:,:,1);
        joints = joints';
        joints = joints(:,convertVector);
%         imJoints(:,1) = joints(:,26);
%         imJoints(:,2) = joints(:,24);
%         imJoints(:,3) = joints(:,22);
%         imJoints(:,4) = joints(:,10);
%         imJoints(:,5) = joints(:,12);
%         imJoints(:,6) = joints(:,14);
        imName = strrep(test(i).im,'./dataset/LSP/images/','');
        im_id = strrep(imName,'im','');
        im_id = strrep(im_id,'.ipg','');
        im = imread(test(i).im);
        testPatch = extractPatch(im,joints);
        [predictedLabel,jointEvidence] = isCrossed(joints,testPatch,crossedClassifier,0.5);
        if predictedLabel ~=jointEvidence
            best = changeLengs(best);
            
        end
        myboxes{c} = best;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ests(c) = conf.box2det(boxes(c), 26);
        estim = ests(c).joints(:,:,1);
        tmp(1) = my_eval(estim,test(i).joints);
        
        ests(c) = conf.box2det(right_fixed_boxes(c), 26);
        estim = ests(c).joints(:,:,1);
        tmp(2) = my_eval(estim,test(i).joints);
        
        ests(c) = conf.box2det(left_fixed_boxes(c), 26);
        estim = ests(c).joints(:,:,1);
        tmp(3) = my_eval(estim,test(i).joints);
        
        
        ests(c) = conf.box2det(orig_inv_boxes(c), 26);
        estim = ests(c).joints(:,:,1);
        tmp(4) = my_eval(estim,test(i).joints);
        
        
        ests(c) = conf.box2det(right_inv_boxes(c), 26);
        estim = ests(c).joints(:,:,1);
        tmp(5) = my_eval(estim,test(i).joints);
        
        ests(c) = conf.box2det(left_inv_boxes(c), 26);
        estim = ests(c).joints(:,:,1);
        tmp(6) = my_eval(estim,test(i).joints);
        
%         [best,~] = compare_res(boxes{c},right_fixed_boxes{c},left_fixed_boxes{c});
        
        
        [T,F,ss] = calculateRate(tmp(1),tmp(2),tmp(3),2000,tmp(5),tmp(6),boxes{c}(1,end),right_fixed_boxes{c}(1,end),left_fixed_boxes{c}(1,end));
        trues = trues + T;
        falses = falses + F;
        sumjoints = sumjoints + ss;
        if TestConfig.show == 1
            im = imreadx(test(i));
            name = strrep(test(i).im,'./dataset/LSP/images/','./result/');
            name =  strrep(name,'.jpg','');
            axes(handles.axes1);
            showskeletons(im,boxes{c}(1,:), conf.pa);
            title({strcat('Original Estimate Score = ',num2str(round(boxes{c}(1,end),2)));...
                strcat('pixel Score = ',num2str(tmp(1)))});
            
            axes(handles.axes2);
            showskeletons(im, right_fixed_boxes{c}, conf.pa);
            %         tmp(2) = round(tmp(2),2);
            title({strcat('Right Estimate Score = ',num2str(round(right_fixed_boxes{c}(1,end),2)));...
                strcat('pixel Score = ',num2str(tmp(2)))});
            
            
            axes(handles.axes3);
            showskeletons(im, left_fixed_boxes{c}, conf.pa);
            
            %         tmp(3) = round(tmp(3),2);
            title({strcat('Left Estimate Score = ',num2str(round(left_fixed_boxes{c}(1,end),2)));...
                strcat('pixel Score = ',num2str(tmp(3)))});
            
            axes(handles.axes7);
            showskeletons(im,myboxes{c},conf.pa);
            
            title({strcat('Selected Skeleton = ',num2str(round(myboxes{c}(1,end),2)));...
                strcat('pixel improvement = ',num2str(round(ss)))});

            if T==1
                name = strrep(test(i).im,'./dataset/LSP/images/','./result/T/');
                name =  strrep(name,'.jpg','');
                saveas(gca,name,'jpg');
            elseif F == 1
                name = strrep(test(i).im,'./dataset/LSP/images/','./result/F/');
                name =  strrep(name,'.jpg','');
                saveas(gca,name,'jpg');
            else
                name = strrep(test(i).im,'./dataset/LSP/images/','./result/noChange/');
                name =  strrep(name,'.jpg','');
                saveas(gca,name,'jpg');
            end
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cachData(c).HOGprob = Hprob;
        cachData(c).HOGlprob = Hlprob;
        cachData(c).HOGrprob = Hrprob;
        cachData(c).ang_scoreO = angle_score(c);
        cachData(c).ang_scoreR = rangle_score(c);
        cachData(c).ang_scoreL = langle_score(c);
        cachData(c).leng_scoreO = leng_score(c);
        cachData(c).leng_scoreR = rleng_score(c);
        cachData(c).leng_scoreL = lleng_score(c);
        cachData(c).pair_scoreO = pair_score(c);
        cachData(c).pair_scoreR = rpair_score(c);
        cachData(c).pair_scoreL = lpair_score(c);
        
        cachData(c).ang_penalO = angle_penal(c);
        cachData(c).ang_penalR = rangle_penal(c);
        cachData(c).ang_penalL = langle_penal(c);
        cachData(c).leng_penalO = leng_penal(c);
        cachData(c).leng_penalR = rleng_penal(c);
        cachData(c).leng_penalL = lleng_penal(c);
        cachData(c).pair_penalO = pair_penal(c);
        cachData(c).pair_penalR = rpair_penal(c);
        cachData(c).pair_penalL = lpair_penal(c);
        
        cachData(c).realScr = tmp;
        cachData(c).Odc = Odc;
        cachData(c).Ldc = Ldc;
        cachData(c).Rdc = Rdc;
        
    end
end
save([cachedir  'OrigBoxes.mat'],'boxes');
save([cachedir  'RightBoxes.mat'],'right_fixed_boxes');
save([cachedir  'LeftBoxes.mat'],'left_fixed_boxes');
% %     disp(sumjoints);
save('cache_data.mat','cachData');

