function pos_test = prepare_my_test()
imfolder = 'F:\my_test_dataset/';
images = dir('F:\my_test_dataset/*.jpg');
joints = zeros(14,2);
for im = 1:length(images)

pos_test(im).im = strcat(imfolder,images(im).name);
pos_test(im).isflip = 0;
pos_test(im).r_degree = 0;
pos_test(im).joints = joints;
end
end