function []= ColourPlotter(x1,x2,y1,y2,func,tempFunc)
resolution = 500;
x = x1:(x2-x1)/resolution:x2;
y = y1:(y2-y1)/resolution:y2;

for i=1:resolution+1,
    for j=1:resolution+1,
        z(i,j) = func(x(i),y(j));
        c(i,j) = tempFunc(x(i),y(j),z(i,j));
    end
end
surf(x,y,z,c,'EdgeColor','none')