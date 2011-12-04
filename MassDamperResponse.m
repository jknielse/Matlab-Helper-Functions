function []= MassDamperResponse(m,b,k,lapFunc,x1,x2,res)
syms outputFun Y s 

Y  = (1/(m * s^2 + b * s + k)) 
Y = Y * lapFunc

outputFun = ilaplace(Y)

funHandle = matlabFunction(outputFun);

dx = (x2-x1)/res;

xcur = x1;
i = 1;

while(xcur < x2)
    xVal(i) = xcur;
    yVal(i) = funHandle(xcur);
    xcur = xcur + dx;
    i = i + 1;
end

plot(xVal,yVal);

    
    