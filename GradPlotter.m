function []= Plotter(x1,x2,y1,y2,func)
resolution = 200;
x = x1:(x2-x1)/resolution:x2;
y = y1:(y2-y1)/resolution:y2;

for i=1:resolution+1,
    for j=1:resolution+1,
        z(i,j) = func(x(i),y(j));
    end
end

surf(x,y,z,'EdgeColor','none')

[dx,dy] = gradient(z,x,y);

z = 0;

for i = 1:length(dx),
    for j = 1:length(dy),
        z(i,j) = sqrt(dx(i)^2 + dy(j)^2);
    end
end

figure(2)

surf(x,y,z,'EdgeColor','none')