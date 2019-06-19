x=[];
s=segs;
for i=1:19
    temp=s(i,2)-s(i,1);
    temp=round(temp*10)
    temp=ones(1,temp);
    temp=temp*mod(i,2);
    x=[x,temp];
end
xt=x;
x=[];
s=segs2;
for i=1:17
    temp=s(i,2)-s(i,1);
    temp=round(temp*10)
    temp=ones(1,temp);
    temp=temp*mod(i,2);
    x=[x,temp];
end

x=[x,ones(1,6)];
test=0
for i=1:3706
    if xt(i)==x(i)
        test=test+1;
    end
end
acc=test/3706
