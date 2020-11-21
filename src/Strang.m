function result = Strang(u, x, N, tmax, delta_t)
    label_size = 14;
    delta_x = x(2) - x(1);
    delta_k = 2*pi/(N*delta_x);

    k = [0:delta_k:(N/2-1)*delta_k,0,-(N/2-1)*delta_k:delta_k:-delta_k];
    t=0;

    %% Draw the initial diagram
    plot(x,u,'LineWidth',2)
    axis([-10 10 0 10])
    xlabel('x','FontSize',label_size)
    ylabel('u','FontSize',label_size)
    text(6,9,['t = ',num2str(t,'%1.2f')],'FontSize',label_size )
    drawnow

    t_plot = floor((tmax/100)/delta_t);
    nmax = round(tmax/delta_t)
    udata = u'; tdata = 0;
    U = fft(u);

    for n = 1:nmax
        t = n*delta_t;
        % linear half step
        U = U.*exp(1i*k.^3*delta_t/2);
        % no linear full step
        U = U  - (3i*k*delta_t).*fft((real(ifft(U))).^2);
        % linear half step
        U = U.*exp(1i*k.^3*delta_t/2);
        result{n} = U;
        if mod(n,t_plot) == 0
            u = real(ifft(U));
            udata = [udata u']; tdata = [tdata t];
            % Only plot specific times
            if mod(n,4*t_plot) == 0
                plot(x,u,'LineWidth',2)
                axis([-10 10 0 10])
                xlabel('x', 'FontSize',label_size)
                ylabel('u', 'FontSize',label_size)
                text(6,9,['t = ',num2str(t,'%1.2f')],'FontSize', label_size)
                drawnow
            end
        end
    end