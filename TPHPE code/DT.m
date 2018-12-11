function [dst,ptr]=DT(src,step,len,a_c,b_c,a_p,b_p...
    ,dshift_c,dshift_p,dlen)
v = zeros(len,1);
Z = zeros(len+1,1);
v(1) = 1;
Z(1) = -inf;
Z(2) = inf;
k = 1;
%q = 1;
for q=2:len
    s = ( (src(q*step) - src(v(k)*step))...
        - b_c * -(q - v(k)) + a_c * (power(q,2) - power(v(k),2))...
        - b_p * (q - v(k)) + a_p * (power(q,2) - power(v(k),2))....
        + 2*a_c * (q-v(k))*(-dshift_c) + 2*a_p * (q-v(k))*(dshift_p))...
        / ( 2*a_c*(q-v(k)) + 2*a_p*(q-v(k)) );
    while (s <= Z(k))
        k = k-1;
        s = ( (src(q*step) - src(v(k)*step))...
            - b_c * -(q - v(k)) + a_c * (power(q,2) - power(v(k),2))...
            - b_p * (q - v(k)) + a_p * (power(q,2) - power(v(k),2))...
            + 2*a_c * (q-v(k))*(-dshift_c) + 2*a_p * (q-v(k))*(dshift_p))...
            /( 2*a_c*(q-v(k)) + 2*a_p*(q-v(k)) );
    end
    k = k + 1;
    v(k) = q;
    Z(k) = s;
    Z(k+1) = inf;
    
end

k =1;
for q=1:dlen
    while (Z(k+1) < q)
        k = k+1;
    end
    q = double(q);
    v(k) = double(v(k));
        dst(q*step) =src(v(k)*step) + a_c * power(q + dshift_c - v(k),2) + b_c * -(q + dshift_c - v(k))...
            + a_p * power(q - dshift_p - v(k),2) + b_p * (q - dshift_p - v(k));
        ptr(q*step) = v(k);
end