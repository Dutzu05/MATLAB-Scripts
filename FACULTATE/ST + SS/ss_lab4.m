    t = -3:0.01:4;
    
    u = @(t) double(t >= 0);
    x1 = @(t) u(t) - u(t - 2);
    
    % triangle known output
    y1 = @(t) (t).*(t >= 0 & t < 1) + (2 - t).*(t >= 1 & t <= 2);
    
    % x2, y2
    x2 = x1(t+1) + x1(t);
    y2 = y1(t+1) + y1(t);
    
    % x3, y3
    x3 = x1(t+2) + x1(t-2);
    y3 = y1(t+2) + y1(t-2);
    
    % x4, y4
    x4 = -x1(t+2);
    y4 = -y1(t+2);
    
    % x5, y5
    x5 = -x1(t);
    y5 = -y1(t);
    
    figure
    
    subplot(4,2,1)
    plot(t,x2,'LineWidth',2), grid on
    title('x2(t)')
    
    subplot(4,2,2)
    plot(t,y2,'LineWidth',2), grid on
    title('y2(t)')
    
    subplot(4,2,3)
    plot(t,x3,'LineWidth',2), grid on
    title('x3(t)')
    
    subplot(4,2,4)
    plot(t,y3,'LineWidth',2), grid on
    title('y3(t)')
    
    subplot(4,2,5)
    plot(t,x4,'LineWidth',2), grid on
    title('x4(t)')
    
    subplot(4,2,6)
    plot(t,y4,'LineWidth',2), grid on
    title('y4(t)')
    
    subplot(4,2,7)
    plot(t,x5,'LineWidth',2), grid on
    title('x5(t)')
    
    subplot(4,2,8)
    plot(t,y5,'LineWidth',2), grid on
    title('y5(t)')