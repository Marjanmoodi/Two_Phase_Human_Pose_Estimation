clear variables;
clc;
% c = 0;
% L = [0,0.1,0.3,0.5];
% % P = [0,0.01,0.1,0.8,0.9,0.95,1,1.1,1.2,1.5,2,3,5,10,20];
% P = [0.1,0.9,0.95,1,1.05,1.1,1.2];
% D = logspace(-2,-1,5);
% % DC = logspace(-3,-1,50);
% DC = [0.0139,0.0153,0.168];
% % Hog = logspace(-2,0,20);
% Hog = [0.1129, 0.4833];
L = -0.1;
P = -1.05;
D = -0.01;
DC = -0.0139;
Hog = -0.1129;

[L,P,D,DC,Hog] = ndgrid(L,P,D,DC,Hog);
Q = [L(:) P(:) D(:) DC(:) Hog(:)];
% Q = [Q ; -1 * Q];
better = zeros(size(Q,1),1);
worse = better;
summation = worse;
for c = 1:size(Q,1)
    if mod(c,10)==0
        fprintf('%d/%d\n',c,size(Q,1))
        disp(max(better-worse));
    end
    [trues,falses,sumJoint] = tunning(Q(c,1) ,Q(c,2),Q(c,3),Q(c,4),Q(c,5));
    better(c) = trues;
    worse(c) = falses;
    summation(c) = sumJoint;    
end

[A,B] = max(better - worse);
A
Q(find((better-worse) == A),:)
Q(B,:)
