function [output] = specificHeatDistribution(deltaLength)
%this function is extremely specific. it returns an N by M heat map of the
%plate defined in problem 3 of our numerical methods project 2.

%{
In order to solve this problem, A will be an ((N+1)*(M+1)) sized square 
matrix such that Ay = b, where y = [T11, T12, T13 ... T1M, T21 ... TNM]
(where 1 .. N represent the x coordinates, and 1 .. M represent the y 
coordinate) and b is populated with all zeroes save for the last (N+M)*2-4
rows, which will be populated with entries to represent the boundary
conditions of the problem.

Note to self: Good luck, and godspeed.
%}

N = 15 / deltaLength;
M = 20 / deltaLength;

%This will just cause A and b to be initialized at the correct size.
%A((N+1)*(M+1),(N+1)*(M+1)) = 0;
%b((N+1)*(M+1)) = 0;

%for each iteration of this loop, we will be inserting a row into A. In
%order to keep track of what row we're on, I will use i.

i = 0;
for x=1:N+1,
    for y=0:M,
        i = 1 + i;
        if(x == 1)
            A(x + (N+1)*y,i) = 1;
            b(i) = 100;
            continue
        end
        if(x == N+1)
            A(x + (N+1)*y,i) = 1;
            b(i) = 50;
            continue
        end
        if(y == 0)
            A(x + (N+1)*y,i) = 1;
            b(i) = 150;
            continue
        end
        if(y == M)
            A(x + (N+1)*y,i) = 1;
            b(i) = 200;
            continue
        end

        A((x-1)+(N+1)*(y),i) = 1;
        A((x+1)+(N+1)*(y),i) = 1;
        A((x)+(N+1)*(y+1),i) = 1;
        A((x)+(N+1)*(y-1),i) = 1;
        A(x+(N+1)*y,i) = -4;
        b(i) = 0;
    end
end

A = A';
b = b';

helper = A\b;
%output(N,M) = 0;

for i=0:(M+1)*(N+1)-1
    output(mod(i,N+1 ) + 1,floor(i / (N+1)) + 1) = helper(i + 1);
end
    

