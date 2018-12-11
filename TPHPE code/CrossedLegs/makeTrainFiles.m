function makeTrainFiles()
if(exist('./Crossed','dir'))
    rmdir('./Crossed','s');
end

if(exist('./notCrossed','dir'))
    rmdir('./notCrossed','s');
end
mkdir('Crossed');
mkdir('notCrossed');

for ii = 1 : length(trainingFiles)
    name = trainingFiles(ii).name;
    name = strrep(name,'im','');
    imgId = str2double(strrep(name,'.jpg',''));
    if (labels (imgId) == 1) % Crossed
        copyfile(fullfile(folder,trainingFiles(ii).name), fullfile('Crossed',trainingFiles(ii).name));
    else % Not Crossed
        copyfile(fullfile(folder,trainingFiles(ii).name), fullfile('notCrossed',trainingFiles(ii).name));
    end
end

if(exist('./pos','dir'))
    rmdir('./pos','s');
end

if(exist('./neg','dir'))
    rmdir('./neg','s');
end
extractPatch('', joints,'pos');
extractPatch('', joints,'neg');

end

