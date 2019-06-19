x1=magic(5);

f=figure;
subplot(2,1,1)
x=plot(x1)
y=subplot(2,1,2)
copyobj(x,y);
saveas(f,'Barchart.png')
return;

filename='1.wav';
[y,fs]=audioread(filename);
%[vs,zo]=vadsohn(y,fs,'p') ;
%   threshold = 0.1; % Decision threshold of the likelihood ratio test
%   win_dur = 0.05;  % Window duration in seconds
%   hop_dur = 0.025; % Hop duration in seconds
%   num_noise = 20;  % Number of noise frames at the beginning of file
%   argin = 1;

%[segs, classes, L1, C1] = silenceRemoval(filename, 0, 0);


%s = subplot(2,1,1);
%plot(C1, L1, 'k');
%axis([0 max(C1) 0 3]);
%set(s, 'YTick', [0 1 2 3])
%set(s, 'YTickLabel', {'','Silence', 'Speech', ''})
%xlabel('Time (sec)');
%title('Simple merging');




[segs, classes l2 c2] = speakerDiarization(filename,3,0.04,0.04,1,0.05);

y = y(:,1);
colorVec = hsv(3);
dt = 1/fs;
t = 0:dt:(length(y)*dt)-dt;
%plot(t,y); xlabel('Seconds'); ylabel('Amplitude');

SDy=[];
classes=classes+1;
time=(length(y)*dt)-dt;
% Generate arbitrary random variables
subplot(2,1,1)
hold on;
axis([0 time 0 max(classes)])
%bar(c2,l2,'FaceColor',colorVec(classes(i),:),'BarWidth',1.1)
subplot(2,1,2)
hold on;
axis([0 time 0 max(classes)])
yn=zeros(1,length(y));
% for i=1:length(segs)
%     %subplot(2,1,1)
%     %yt=y((segs(i,1)*fs+1):(segs(i,2)*fs));
%     tt=t((segs(i,1)*fs+1):(segs(i,2)*fs));
%     %plot(tt,yt,'Color',colorVec(classes(i),:));
%     
%     %subplot(2,1,2)
%     x=ones(1,length(tt));
%     x=x*classes(i);
%     %plot(tt,x,'Color',colorVec(classes(i),:));
%     bar(tt,x,'FaceColor',colorVec(classes(i),:),'BarWidth',1.1)
%     yn((segs(i,1)*fs+1):(segs(i,2)*fs))=classes(i);
%     
% end

for i=1:length(segs)
    %subplot(2,1,1)
    %yt=y((segs(i,1)*fs+1):(segs(i,2)*fs));
    tt=t((segs(i,1)*fs+1):(segs(i,2)*fs));
    %plot(tt,yt,'Color',colorVec(classes(i),:));
    
    %subplot(2,1,2)
    x=ones(1,length(tt));
    x=x*classes(i);
    %plot(tt,x,'Color',colorVec(classes(i),:));
    bar(tt,ones(1,length(tt)),'FaceColor',colorVec(classes(i),:),'BarWidth',1.1)
    yn((segs(i,1)*fs+1):(segs(i,2)*fs))=classes(i);
    
end


hold off;


