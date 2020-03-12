A = [3 9 5];
B = [2 1 5];
C=A./B.^2
C=(A./B).^2
B=sqrt (A(2))+2*B(1)

A=[2 7 6; 9 0 -1; 3 0.5 6];
B= [8 0.2 0; -3 2 5; 4 -1 7] ;
    if A < B
    'A<B'
    else
    'A>B'
    end

x(1) = 2;
for i = 2:6
   x(i) = 2*x(i-1);
end

A = magic (4)

a=7.5
b=3.342
myfile(a, b);

B = rand (4, 3, 2)

x = 0:10;
y = sin(x);
xi = 0:0.25:10;
yi = spline (x,y,xi);
plot (x,y,'o',xi,yi,'b'), grid
