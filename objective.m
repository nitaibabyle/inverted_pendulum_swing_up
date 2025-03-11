function f=objective(MMM)

ut=MMM(61:70);
a=0;
for i=1:9
    a=(2/9)*(ut(i)^2+ut(i+1)^2)+a;
end
f=a;



