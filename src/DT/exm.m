X = randi(100,50,2);
% Create an image with rando values at these points
img = sparse(X(:,2), X(:,1), rand(50,1)*20,100,100);
% Set all other values to a high number
img(img==0) = 1e10;
% Call the function
[D R] = DT(img);
% Plot the results
figure;
subplot(1,2,1);
imagesc(D);
title('Generalized Distance transform');
axis image;
subplot(1,2,2);
imagesc(R);
title('Power diagram');
axis image;

