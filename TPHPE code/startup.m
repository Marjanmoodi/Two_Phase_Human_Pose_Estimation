function startup
if ~exist('./bin', 'dir')
  mkdir('./bin');
end

if ~isdeployed
  addpath('./CrossedLegs');
  addpath('./dataio');
  addpath('./bin');
  addpath('./evaluation');
  addpath('./visualization');
  addpath('./src');
  addpath('./tools');
  addpath('./external');
  addpath('./external/qpsolver');
  addpath('./extract_dataset_features')
  addpath('./my_implement');
  addpath('./my_cache');
  addpath('./src/mex');
  % path to DCNN library, e.g., caffe
  conf = global_conf();
  caffe_root = conf.caffe_root;
  if exist(fullfile(caffe_root, '/matlab/+caffe'), 'dir')
%     addpath(fullfile(caffe_root, '/matlab/+caffe'));
%      addpath(fullfile(caffe_root,'/Build/x64/Release/matcaffe'));
  else
    warning('Please install Caffe in %s', caffe_root);
  end
end
