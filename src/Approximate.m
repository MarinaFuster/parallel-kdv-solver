function results = Approximate(u, x, N, tmax, order, parallel, delta_t)
    % clc
    % set(gca,'FontSize',8)
    % set(gca,'LineWidth',2)

    delta_x = x(2) - x(1);         % x step
    delta_k = 2*pi/(N*delta_x);
    %delta_t = 0.0005;

    k = [0:delta_k:(N/2-1)*delta_k,0,-(N/2-1)*delta_k:delta_k:-delta_k];
    plot_iteration = floor((tmax/100)/delta_t);
    nmax = round(tmax/delta_t);
    
    U = fft(u);
    udata = u.'; tdata = 0;

    % We now have everything set to start running our approximation method

    for n = 1:nmax
        t = n*delta_t;

        U = MethodStep(U, k, delta_t, order, parallel);
        % Method step completed
        results{n}=U;

        if mod(n,plot_iteration) == 0
            u = real(ifft(U));
            udata = [udata u.']; tdata = [tdata t];
            plot(x,u,'LineWidth',1);
            axis([-10 10 0 10]);
            xlabel('x');
            ylabel('u');
            text(6,9,['t = ',num2str(t,'%1.2f')],'FontSize',10);
            drawnow
        end
    end
   
figure

waterfall(x,tdata(1:4:end),udata(:,1:4:end)')
xlabel x, ylabel t, axis([-10 10 0 tmax 0 10]), grid off
zlabel u

end