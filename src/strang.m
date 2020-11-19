clear all
clc

[xmin,xmax,ymin,ymax] = deal(-10, 10, 0, 10);

N = 256;
x = linspace(xmin,xmax,N); % generate X axis
delta_x = x(2) - x(1);
delta_k = 2*pi/(N*delta_x);

k = [0:delta_k:(N/2-1)*delta_k,0,-(N/2-1)*delta_k:delta_k:-delta_k];
c_1 = 13;
c_2 = 3;
c_3 = 5;

u = 1/2*c_1*(sech(sqrt(c_1)*(x+8)/2)).^2 + 1/2*c_2*(sech(sqrt(c_2)*(x+1)/2)).^2 + 1/2*c_3*(sech(sqrt(c_3)*(x+5)/2)).^2;

delta_t = 0.4/N^2;
t=0;

%% Draw the initial diagram
plot(x,u,'LineWidth',2)
axis([xmin xmax ymin ymax])
xlabel('x')
ylabel('u')
text(6,9,['t = ',num2str(t,'%1.2f')],'FontSize',14)
drawnow

tmax = 1.5;
t_plot = floor((tmax/100)/delta_t);
nmax = round(tmax/delta_t);
udata = u'; tdata = 0;
U = fft(u);

tic
for n = 1:nmax
    t = n*delta_t;
    % lineal
    U = U.*exp(1i*k.^3*delta_t/2);
    % no lineal
    U = U  - (3i*k*delta_t).*fft((real(ifft(U))).^2);
    % lineal
    U = U.*exp(1i*k.^3*delta_t/2);
    if mod(n,t_plot) == 0
        u = real(ifft(U));
        udata = [udata u']; tdata = [tdata t];

        % Only plot specific times
        if mod(n,4*t_plot) == 0
            plot(x,u,'LineWidth',2)
            axis([xmin xmax ymin ymax])
            xlabel('x')
            ylabel('u')
            text(6,9,['t = ',num2str(t,'%1.2f')],'FontSize',10)
            drawnow
        end
    end
end
toc