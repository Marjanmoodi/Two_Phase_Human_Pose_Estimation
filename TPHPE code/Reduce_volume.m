for i = 1:1
 try
 name = strcat('im',num2str(1000 + i),'.mat');  
 load(name);
 rmfield(pyra,'feat');
 save(name,'pyra','unary_map','idpr_map');
 catch
     continue;
 end
    
    
end