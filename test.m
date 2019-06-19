% line plot
x1=1:10;
y1=1:10;
%bar 1 data
xb1 = [2 5 7];
yb1 = [2 2 2]; 
%bar 2 data
xb2 = [1 2 9];
yb2 = [2 2 2];
figure
p1 = plot(x1,y1);
hold on
dist1 = -10;
dist2 = -20;
b1 = plot([xb1; xb1], [yb1+dist1; ones(1,size(yb1,2)).*dist1],'-b');
b2 = plot([xb2; xb2], [yb2+dist2; ones(1,size(yb2,2)).*dist2],'-r');
axis([0  10    ylim])
