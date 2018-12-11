function [penal,c] = bin2Penalty(disx,disy,pair,pp)
hh = (pair.h)./max(max(pair.h));
c = 0;
if (disx > pair.hbin{1}(1) && disx < pair.hbin{1}(end) && disy > pair.hbin{2}(1) && disy < pair.hbin{2}(end) )
    indx = max(find(disx >= pair.hbin{1}));
    indy = max(find(disy >= pair.hbin{2}));
    if pp == 1 && norm([disx,disy])<10
     c = c + 1;
     penal = 0;
    else
     penal = hh(indx,indy);
    end
    
else
    penal = 0;
    disp('OoOops');
end
end