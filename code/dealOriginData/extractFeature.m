clear all;
close all;

peopleNum = 97;
dataRoot = 'data/';
filelistAll = dir(dataRoot);

ff=1;
for rr=1:length(filelistAll)
    if(filelistAll(rr).isdir==1&&~strcmp(filelistAll(rr).name,'.')&&~strcmp(filelistAll(rr).name,'..'))
        filelist{ff}=[filelistAll(rr).name];%�洢�ֿ��ļ�����
        ff=ff+1;
    end
end
addpath('/data1/hsy/data');
assert(length(filelist) == peopleNum);

if exist('mfccFeature','dir')
    rmdir('mfccFeature','s');
    mkdir('mfccFeature');
else
    mkdir('mfccFeature');
end
cd(dataRoot); 

for i=1:length(filelist)-95
    Folder = filelist{i}; %��ӡ��ÿ���ļ�����
    cd(Folder);
    disp(sprintf('doing %s',Folder));
	waveFiles = dir(fullfile(cd,'*.wav'));
    %disp(waveFiles(1).name);
    for j=1:length(waveFiles)
            wavefile = waveFiles(j).name;
            %disp(wavefile);
            %disp(waveFiles(j).name);
            try
                [d,sr] = audioread(wavefile);
                
                [mfc,freqresp,fb,fbrecon,freqrecon]= mfcc(d,sr);
               
                %fbrecon(:,mfc(1,:)<-16) = [];%��������Ƭ��
              
                %mfc(:,mfc(1,:)<-16) = [];%��������Ƭ��
                
                del = deltas(mfc);
                
                ddel = deltas(deltas(mfc,5),5);
                
                mfc = [mfc;del;ddel];
                
                if ~exist(sprintf('../../mfccFeature/%s',Folder),'dir')
                    mkdir(sprintf('../../mfccFeature/%s',Folder));
                end;
                wavefile = ['../../mfccFeature/',Folder,'/',wavefile(1:9),'csv'];
                %mfc = [mfc;fbrecon];
                csvwrite(wavefile,mfc);
            catch
                wavefile
            end
     end;
     cd ..;
end
cd ..;