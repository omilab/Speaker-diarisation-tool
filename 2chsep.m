filename='3.wav';
[wavData fs]=audioread(filename);


[segs, classes, L1, C1] = silenceRemoval(filename, 0.05,0, 0);

s = subplot(2,1,1);
plot(C1, L1, 'k');
axis([0 max(C1) 0 3]);
set(s, 'YTick', [0 1 2 3])
set(s, 'YTickLabel', {'','Silence', 'Speech', ''})
xlabel('Time (sec)');
title('Simple merging');