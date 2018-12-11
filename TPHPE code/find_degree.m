function degree = find_degree(par,cur,child)
a = [par(1)-cur(1),par(2)-cur(2)];
b = [child(1)-cur(1),child(2)-cur(2)];
d = rad2deg(atan2(a(2),a(1))-atan2(b(2),b(1)));
if d<0
    degree = 360 + d;
else
    degree = d;
end
end