
%{
    finitediff() will return the matrix A, and vector b where:
    n is the number of iterations for the region x0 to xn,
    y0, and yn are the boundary values,
    and funP, funQ, and funR are function handles for a second-order
    differential equation.

    A\b will yield the solution to the finite difference problem.
    
%}
function [ A, b ] = finitediff(n, x0, xn, y0, yn, funP, funQ, funR)
    deltaX = (xn-x0)/n;

    for i=1:n-1,
        b(i) = deltaX^2 * funR(x0 + deltaX * i);
        A(i,i) = -2 + deltaX^2 * funQ(x0 + deltaX * i);
        if i < n-1
            A(i+1,i) = 1 + deltaX/2 * funP(x0 + deltaX * i);
        end
        if i > 1
            A(i-1,i) = 1 - deltaX/2 * funP(x0 + deltaX * i);
        end
    end
    
    b(1) = b(1) - y0 + y0 * deltaX / 2 * funP(x0 + deltaX);
    b(n-1) = b(n-1) - yn + yn * deltaX / 2 * funP(xn - deltaX);
    
    b = b'
    A = A'
    
    helpery = A\b
    helperx(1) = x0;
    helperx(n) = xn;
    for i=1:n-1,
        helpery(n + 1-i) = helpery(n - i);
    end
    for i=2:n-1,
        helperx(i) = x0 + deltaX * i;
    end
    
    helpery(1) = y0;
    helpery(n) = yn;
    
    plot(helperx,helpery);

end