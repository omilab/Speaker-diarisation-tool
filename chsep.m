%{
filename='C:\Users\user1\Documents\maptest\הקלטות\FNL000A.wav';
[wavData fs]=audioread(filename);
filename='temp.wav';
audiowrite(filename,wavData(:,1),fs)
[segs, classes, L1, C1] = silenceRemoval(filename, 0.05,0, 0);
audiowrite(filename,wavData(:,2),fs)
[segs2, classes2, L2, C2] = silenceRemoval(filename, 0.05,0, 0);
%}


x=4
bar(C1,(L1-1),'FaceColor','b','BarWidth',1.1)
hold on
bar(C2,(L2+1),'FaceColor','r','BarWidth',1.1,'BaseValue',2)
axis([0 max(C1) 0 5 ])
legend('Speaker 1','Speaker 2')


%classes = c1 + 1;
%classes2 = c2 + 1;

a=size(wavData);
totalDuration = a(1) / fs;    % get the input file's duration in seconds
%{
Width = 1000; Height = 20;
Ratio = Width / totalDuration;

% Generate image to plot (from class labels):
plotLabels = [];
plotLabels2 = [];
for i=1:size(segs,1)
    plotLabels = [plotLabels classes(i) * ones(Height, round(Ratio * (segs(i,2)-segs(i,1))))];
end

for i=1:size(segs2,1)
    plotLabels2 = [plotLabels classes2(i) * ones(Height, round(Ratio * (segs2(i,2)-segs2(i,1))))];
end
% choose a "lines" color mapping
map = colormap(lines(length(unique(classes))));
%map = colormap(gray(length(unique(classes)))); 

map2(1,:)=map(2,:);
map2(2,:)=uint8([0.6 0.6 0.6]);
map1=map2;
map1(1,:)=map(1,:);
%map=uint8(map);

ax1=subplot(211)

imshow(plotLabels,map1);
axis off
title('Speaker 1')

ax2=subplot(212)
imshow(plotLabels2,map2);
axis off
title('Speaker 2')
linkaxes([ax1,ax2],'xy')
% plot the time segment limits (text):
%}
