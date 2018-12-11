global TestConfig;
%%% testIndex between 1 and 1000
%  TestConfig.testIndex  = [41,54,116,149,150,163,165,189,501,514,536,551,562]; 
%  load('footDc.mat');
%  foot_dc_ind = foot_dc_ind - 1000;
%  save('my_cache/footDc.mat','foot_dc_ind');
% TestConfig.testIndex = 1:1000;
% TestConfig.testIndex = 1;
% DC(:) P(:) L(:) A(:) Hog(:)
% -1.0000    0.1000   -0.1000    0.1000    0.1000
TestConfig.testIndex = 500:600;
TestConfig.lengthPenalty = -0.1;
TestConfig.pairPenalty = 0.1;
TestConfig.degreePenalty =0.1;
TestConfig.hog = 0.1;
TestConfig.eval = 1;
TestConfig.show = 0;
%%% 2--->do not change  1--->selected 0--->not selected
TestConfig.deg_config = [2 0 0 0 0 0 2 0 0 1 1 1 1 2 0 0 0 0 2 0 0 1 1 1 1 2;
                         2 0 0 2 2 2 2 2 2 2 2 2 2 2 0 2 2 2 2 2 2 2 2 2 2 2];
TestConfig.leng_config = [0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1];            
% TestConfig.leng_config = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
TestConfig.pair_config = [2 2 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1];
%%% k-->penalty func
TestConfig.K = 0.9999;
