function [hogFeatures] = getHOGFeatures(train_data,m,n)
for ii = 1:length(train_data)
    img = train_data(ii).patch;
    img = rgb2gray(img);
    img = imresize(img,[m,n]);
    [tt] = extractHOGFeatures(img,'CellSize',[5 5]);
    hogFeatures(ii,:) = tt;
end
end