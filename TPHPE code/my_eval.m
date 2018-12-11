function s = my_eval(estimate,label)
dis = (abs(label - estimate)).^2;
s = sum(sqrt(sum(dis,2)));
end