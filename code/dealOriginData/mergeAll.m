function mergeAll(  )
%MERGEALL 此处显示有关此函数的摘要
%   此处显示详细说明
clear all;
close all;
width = 500;
feaLength = 39;
dataRoot = 'mfccFeature/';
peopleNum = 2;

filelistAll = dir(dataRoot);

ff=1;
for rr=1:length(filelistAll)
    if(filelistAll(rr).isdir==1&&~strcmp(filelistAll(rr).name,'.')&&~strcmp(filelistAll(rr).name,'..'))
        filelist{ff}=[filelistAll(rr).name];%存储字库文件夹名
        ff=ff+1;
    end
end
disp(length(filelist));
assert(length(filelist) == peopleNum);

labelPair = cell(peopleNum,1);
picNum    = zeros(peopleNum,1);
if exist('mergeData','dir')
    rmdir('mergeData','s');
    mkdir('mergeData');
else
    mkdir('mergeData');
end
cd(dataRoot); 
for i=1:length(filelist)
    label = i -1;
    Folder = filelist{i}; %打印出每个文件名字
    disp(sprintf('doing %s...',Folder));
    cd(Folder);
	csvFiles = dir(fullfile(cd,'*.csv'));
    %disp(waveFiles(1).name);
    for j=1:1%length(csvFiles)
            csvfile = csvFiles(j).name;
            try
                csv = csvread(csvfile);
                colNum = size(csv,2);
                colLef = mod(colNum,width);
                csv = csv(:,1:colNum - colLef);
                csv = reshape(csv,feaLength*width,[])';
                if  j == 1
                    csvAll = [label*ones(size(csv,1),1) csv];
                else
                    csvAll = [csvAll;[label*ones(size(csv,1),1) csv]];
                end
            catch
                csvfile;
            end
     end;
     cd ..;
     csvfile = ['../mergeData/',num2str(label),'.csv'];
     csvwrite(csvfile,csvAll);
     labelPair{i} = Folder;
     picNum(i) = size(csvAll,1);
end
cd ..;

disp('doing label...');
labelOut = fopen(sprintf('label.txt'), 'w');
picAllNum = 0;
for i = 1:peopleNum
    fprintf(labelOut,'%d %s %d\r\n',i-1 , labelPair{i},picNum(i));
    picAllNum = picAllNum + picNum(i);
end
fprintf(labelOut,'all pic num:%d',picAllNum);
fclose(labelOut);
disp('all done!');
% csvfile = ['test','csv'];
% csvwrite(csvfile,testCsv);

end
