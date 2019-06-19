filename='3.wav';
[wavData fs]=audioread(filename);


[segs, classes, L1, C1] = silenceRemoval(filename, 0.05,0, 0);

%wavData = (wavData(:,1)+wavData(:,2))/2;
Vadmarker = imresize(L1, [length(wavData) 1], 'nearest');
A = rot90(Vadmarker);
A1 = rot90(wavData);
D = diff(find([1,diff(A),1]));

C = mat2cell(A,1,D);
try
    C1 = mat2cell(wavData,1,D);
catch
    C1 = mat2cell(A1,1,D);
end
%DescLen=diff(find([1,diff(Vadmarker.'),1]))/Fs;
tempsignal=[];
for ii = 1:length(C)
    if  (C{ii}==1)
        vada=0;
    else
        vada=1;
        tempsignal=[tempsignal C1{ii}];
    end
end
audiowrite('2.wav',tempsignal,fs)
filename='2.wav';

[segs, classes]=speakerDiarization(filename,2,0.04, 0.04, 1,0.5);
segmentationPlotResults(segs,classes,filename);

