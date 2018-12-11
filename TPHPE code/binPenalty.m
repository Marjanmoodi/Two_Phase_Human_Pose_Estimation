function penal = binPenalty(d,deg)
hh = (deg.h)./max(max(deg.h));
if (d > deg.hbin(1) && d < deg.hbin(end))
ind = max(find(d >= deg.hbin));
penal = hh(ind);
else
penal = 0;
end

end