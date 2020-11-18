clc

fileID = fopen('metrics.txt','w');
fprintf(fileID,'%s\t%s\t%s\t%s\n','time','order', 'parallel', 'delta_t');

orders = [2, 4, 6];

N = 256;
x = linspace(-10,10,N);        % domain, is this ok?
tmax =  1.5;
t=0;

% Initial conditions
A=25;
B =16;
u = 3.*(A.^2).*(sech(A.*(x+2)./2).^2) + 3.*(B.^2).*(sech(B.*(x+1)./2).^2);

% Plots initial condition (we want to get a better idea of what we are dealing with)
plot(x,u,'LineWidth',1)
axis([-10 10 0 2100])
xlabel('x')
ylabel('u')
text(6,2000,['t = ',num2str(t,'%1.2f')],'FontSize',14)
drawnow

% METRICS
for i=1:length(orders)
    parallel = true; % TODO when using parallel true computer crashes, fix this
    f = @() Approximate(u, x, N, tmax, orders(i), parallel);
    time = timeit(f, 0);
    fprintf(fileID,'%E\t%d\t%s\n',time, orders(i), string(parallel));
    
    parallel = false;
    f = @() Approximate(u, x, N, tmax, orders(i), parallel);
    time = timeit(f, 0);
    fprintf(fileID,'%E\t%d\t%s\n',time, orders(i), string(parallel));
end


fclose(fileID);
% in main you define the equation you want to aproximate and its initial
% conditions
% Here you call Approximate -> MethodStep (for each iteration) ->
% LieTrotter