function mus = calc_mean_pair(ff)
tmp = [ff.pair];
pairs = reshape(tmp,[26 78000]);
mus = zeros(1,26);
for i = 1:26
    mus(i) = mean(pairs(i,:));
end
% convert pixel distance to patch distance
mus = mus./4;
end