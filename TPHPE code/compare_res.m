function [best,res] = compare_res(fboxes,rboxes,lboxes)
if fboxes(1,end) >= rboxes(1,end) && fboxes(1,end) >= lboxes(1,end)
    best = fboxes;
    res = 'all fixed';
elseif rboxes(1,end) >= fboxes(1,end) && rboxes(1,end) >= lboxes(1,end)
    best = rboxes;
    res = 'right fixed';
elseif lboxes(1,end) >= fboxes(1,end) && lboxes(1,end) >= rboxes(1,end)
    best = lboxes;
    res = 'left fixed';
end
    
end