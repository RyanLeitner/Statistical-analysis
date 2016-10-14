data = load('normtemp.txt');
newdata = [];
for i =1:length(data)
    newdata(i,1) = data(i);
    newdata(i,2) = data(i);
end
newdata;
fileID = fopen('newdata.txt','w');
fprintf('%s',newdata)