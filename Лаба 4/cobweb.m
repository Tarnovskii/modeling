function cobweb(x0, tol, a, b, n)
    %function cobweb(x0,tol,a,b,n)
    %   x0: поч. значення Х
    %   tol: різниця між сусідніми значеннями при ітерації
    %   a: ліва границя Х
    %   b: права границя Х
    %   n: кількість проміжних значень Х між а та b
    %
    %  Приклад: cobweb(0.001,1e-20,0,1,100)
 
    format compact
    fs = 25;
    lw = 2;
    xx = linspace(a, b, n);
    %cub = inline('(3.*x-x.^3)./2');
    %cub = inline('2*x.*(1-x)');
    cub = inline('4*x.*(1+x)');     
    w = cub(xx);
    yy = xx;
    figure(1);
    %clf;
    hold on
    set(gca, 'DefaultLineLineWidth', lw)
    set(gca, 'FontSize', fs)
    xlabel('X(n)')
    ylabel('X(n+1)')
    plot(xx, w, xx, yy)
    plot(xx, xx*0, 'k')
    plot(xx*0, xx, 'k')
    i = 1;
    x(i) = x0;
    x(i+1) = cub(x(i));
    plot([x(i), x(i)], [0, x(i+1)], 'r')
    fprintf('x(%d)=%1.20f\n', i, x(i));
    while (((abs(x(i+1)-x(i))>tol && abs(x(i+1))<3) || i<5) && min(abs(x(end)-x(1:end-1)))>tol)
        i=i+1;
        x(i+1) = cub(x(i));
        plot([x(i-1), x(i)],[x(i), x(i)],'r')
        plot([x(i), x(i)], [x(i), x(i+1)], 'r')
        fprintf('x(%d)=%1.20f\n', i, x(i));
        axis auto
        break
    end
    %funcvalues=x'
    %iter=length(x)
