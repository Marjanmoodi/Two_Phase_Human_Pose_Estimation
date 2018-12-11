startup;
clear mex;
clc;
updateconfig;
global GLOBAL_OVERRIDER;
GLOBAL_OVERRIDER = @lsp_conf;
conf = global_conf();
cachedir = conf.cachedir;
pa = conf.pa;
p_no = length(pa);
note = [conf.note];
diary([cachedir note '_log_' datestr(now,'mm-dd-yy') '.txt']);
cachedir = conf.cachedir;
%--------------------------------------------------------------------------
if ~exist('angl','var')
    load('angle_penal.mat');
end
if ~exist('angl_bin','var')
    load('angle_score.mat');
end
if ~exist('pair_bin','var')
    load('pair_score.mat');
end
if ~exist('pair','var')
    load('pair_penal.mat');
end
if ~exist('leng_bin','var')
    load('leng_score.mat');
end

if ~exist('leng','var')
    load('leng_penal.mat');
end
if ~exist('features','var')
    load('features.mat');
end
% -------------------------------------------------------------------------
% read data
% -------------------------------------------------------------------------
%  [pos_train, pos_val, pos_test, neg_train, neg_val, tsize] = LSP_data();
%  pos_test =pos_test(1:200);
cls = 'myData.mat';
load([cachedir cls]);
% -------------------------------------------------------------------------
% train dcnn
% -------------------------------------------------------------------------
% caffe_solver_file = 'external/my_models/lsp/lsp_solver.prototxt';
% train_dcnn(pos_train, pos_val, neg_train, tsize, caffe_solver_file);
% -------------------------------------------------------------------------
% train graphical model
% -------------------------------------------------------------------------
% model = train_model(note, pos_val, neg_val, tsize);
clss = 'CNN_Deep_13_graphical_model.mat';
load([cachedir clss]);
% -------------------------------------------------------------------------
% testing
% -------------------------------------------------------------------------
global TestConfig;
% boxes = test_model2([note,'_LSP'], model, pos_test,handles,deg,pair,leng,tt);
% boxes = test_model([note,'_LSP'], model, pos_test);
[myboxes,boxes] = test_model([note,'_LSP'],...
    model, pos_test,handles,angl,pair,leng,angl_bin,pair_bin,leng_bin,features);
pos_test = pos_test(TestConfig.testIndex);
% -------------------------------------------------------------------------
% evaluation
% -------------------------------------------------------------------------
evall = TestConfig.eval;
if evall ==1
eval_method = {'strict_pcp', 'pdj'};

fprintf('=============base method On test =============\n');
ests = conf.box2det(boxes, p_no);
% my_eval(ests,pos_test(ii).joints);
% generate part stick from joints locations
for ii = 1:numel(ests)
  ests(ii).sticks = conf.joint2stick(ests(ii).joints);
  pos_test(ii).sticks = conf.joint2stick(pos_test(ii).joints);
end
show_eval(pos_test, ests, conf, eval_method);
 % -----------------------------------------------------------------------
ests = conf.box2det(myboxes, p_no);
% my_eval(ests,pos_test(ii).joints);
% generate part stick from joints locations
for ii = 1:numel(ests)
  ests(ii).sticks = conf.joint2stick(ests(ii).joints);
  pos_test(ii).sticks = conf.joint2stick(pos_test(ii).joints);
end
show_eval(pos_test, ests, conf, eval_method);
end
% % diary off;
% % clear mex;
